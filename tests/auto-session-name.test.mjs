import assert from "node:assert/strict";
import { test } from "node:test";
import install from "../dotfiles/.pi/agent/extensions/auto-session-name.ts";

function setup({ name, entries = [], complete } = {}) {
	const handlers = {};
	const calls = [];
	const warnings = [];
	const pi = {
		on: (event, handler) => { handlers[event] = handler; },
		getSessionName: () => name,
		setSessionName: (value) => { name = value; },
	};
	const ctx = {
		model: { id: "current-model" },
		hasUI: true,
		ui: { notify: (...args) => warnings.push(args) },
		sessionManager: { getEntries: () => entries },
		modelRegistry: {
			find: (provider, id) => ({ provider, id }),
			complete: async (...args) => {
			calls.push(args);
			return complete ? complete(...args) : {
				stopReason: "stop", content: [{ type: "text", text: " piの\n自動命名 " }],
			};
		} },
	};
	install(pi);
	return { pi, ctx, calls, warnings, handlers,
		input: (text = "piのセッションを自動命名したい", source = "interactive") =>
			handlers.input({ text, source }, ctx),
	};
}

test("最初の発言だけを指定モデルで要約し、手動名・既存会話を保護する", async () => {
	const s = setup();
	await s.input("a".repeat(9000));
	assert.equal(s.pi.getSessionName(), "piの 自動命名");
	assert.deepEqual(s.calls[0][0], { provider: "openai-codex", id: "gpt-5.6-luna" });
	assert.equal(s.ctx.model.id, "current-model");
	assert.equal(s.calls[0][1].messages[0].content.length, 8000);
	s.pi.setSessionName(undefined);
	await s.input();
	assert.equal(s.calls.length, 1);
	for (const options of [
		{ name: "手動名" },
		{ entries: [{ type: "message", message: { role: "user" } }] },
	]) {
		const existing = setup(options);
		await existing.input();
		assert.equal(existing.calls.length, 0);
	}
	const injected = setup();
	await injected.input("自動注入", "extension");
	assert.equal(injected.calls.length, 0);
	await injected.input();
	assert.equal(injected.calls.length, 1);
});

test("失敗しても入力を妨げず再試行しない。生成中の手動変更・終了も保護する", async () => {
	for (const complete of [
		async () => { throw new Error("private error must not be displayed"); },
		async () => ({ stopReason: "error", content: [{ type: "text", text: "partial" }] }),
		async () => ({ stopReason: "stop", content: [] }),
	]) {
		const s = setup({ complete });
		assert.equal(await s.input(), undefined);
		await s.input();
		assert.equal(s.calls.length, 1);
		assert.equal(s.warnings.length, 1);
		assert.equal(s.pi.getSessionName(), undefined);
		assert.ok(!JSON.stringify(s.warnings).includes("private"));
	}
	const missing = setup();
	missing.ctx.modelRegistry.find = () => undefined;
	await missing.input();
	assert.equal(missing.calls.length, 0);
	assert.equal(missing.warnings.length, 1);
	assert.equal(missing.pi.getSessionName(), undefined);
	for (const action of ["rename", "shutdown"]) {
		let resolve;
		const s = setup({ complete: () => new Promise((r) => { resolve = r; }) });
		const pending = s.input();
		if (action === "rename") s.pi.setSessionName("手動名");
		else s.handlers.session_shutdown();
		resolve({ stopReason: "stop", content: [{ type: "text", text: "自動名" }] });
		await pending;
		assert.equal(s.pi.getSessionName(), action === "rename" ? "手動名" : undefined);
		assert.equal(s.calls[0][2].signal.aborted, action === "shutdown");
	}
	const long = setup({ complete: async () => ({
		stopReason: "stop", content: [{ type: "text", text: "😀".repeat(40) }],
	}) });
	await long.input();
	assert.equal(Array.from(long.pi.getSessionName()).length, 30);
});
