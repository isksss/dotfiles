import assert from "node:assert/strict";
import { mkdtempSync, mkdirSync, symlinkSync, rmSync } from "node:fs";
import { tmpdir, homedir } from "node:os";
import { join } from "node:path";
import { test } from "node:test";
import install from "../dotfiles/.pi/agent/extensions/memory-guard.ts";

test("memory policy applies after skill expansion and blocks data.local mutations", () => {
	const handlers = {};
	install({ on: (name, handler) => { handlers[name] = handler; } });
	const root = mkdtempSync(join(tmpdir(), "memory-guard-"));
	try {
		mkdirSync(join(root, "data.local"));
		symlinkSync(join(root, "data.local"), join(root, "alias"));
		const call = (toolName, input, cwd = root) => handlers.tool_call({ toolName, input }, { cwd });
		for (const tool of ["write", "edit"]) {
			for (const path of ["data.local/memo.md", "./data.local/new/a.json", "@data.local/a", join(root, "data.local/a"), "alias/new/a", "alias/../a", "~/data.local/a"]) {
				assert.equal(call(tool, { path })?.block, true, `${tool}: ${path}`);
			}
			assert.equal(call(tool, { path: "memo.md" }, join(root, "data.local"))?.block, true);
			assert.equal(call(tool, { path: "memo.md" }, join(root, "alias"))?.block, true);
			for (const path of ["src/a.ts", "data.local-backup/a", "data.local.md", join(homedir(), "memory/20_note/a.md")]) {
				assert.equal(call(tool, { path }), undefined, path);
			}
		}
		for (const tool of ["read", "find", "grep", "ls"]) {
			assert.equal(call(tool, { path: "data.local/a" }), undefined);
		}
		for (const tool of ["bash", "powershell"]) {
			for (const command of ["echo memo > data.local/a", "rm -rf data.local", "cat data.local/a", "python -c 'open(\"data.local/a\", \"w\")'"]) {
				assert.equal(call(tool, { command })?.block, true);
			}
			assert.equal(call(tool, { command: "touch a" }, join(root, "alias"))?.block, true);
			assert.equal(call(tool, { command: "git status --short" }), undefined);
		}
		const result = handlers.before_agent_start({ systemPrompt: "existing", prompt: "expanded skill" });
		assert.ok(result.systemPrompt.startsWith("existing\n\n"));
		assert.ok(result.systemPrompt.includes("~/.pi/agent/skills/memory/SKILL.md"));
	} finally {
		rmSync(root, { recursive: true, force: true });
	}
});
