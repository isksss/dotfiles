import assert from "node:assert/strict";
import { readdirSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { test } from "node:test";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const agentsDir = join(root, "dotfiles/.pi/agent/agents");
const expected = [
	"planner.md",
	"worker.md",
	"reviewer-spec.md",
	"reviewer-concurrency.md",
	"reviewer-security.md",
	"reviewer-completeness.md",
];

function frontmatter(file) {
	const content = readFileSync(join(agentsDir, file), "utf8");
	const match = content.match(/^---\n([\s\S]*?)\n---/);
	assert.ok(match, `${file}: frontmatter is required`);
	return match[1];
}

test("harness agents are discoverable", () => {
	const files = new Set(readdirSync(agentsDir));
	for (const file of expected) {
		assert.ok(files.has(file), `${file}: agent definition is missing`);
		const metadata = frontmatter(file);
		assert.match(metadata, /^name: \S+$/m, `${file}: name is required`);
		assert.match(metadata, /^description: .+$/m, `${file}: description is required`);
	}
});

test("subagent extension uses isolated sessionless child processes", () => {
	const source = readFileSync(join(root, "dotfiles/.pi/agent/extensions/subagent/index.ts"), "utf8");
	assert.match(source, /"--no-session"/);
	assert.match(source, /tasks:\s*Type\.Optional\(Type\.Array/);
	assert.match(source, /chain:\s*Type\.Optional\(Type\.Array/);
});

test("Pi instructions opt into the harness only for large tasks", () => {
	const instructions = readFileSync(join(root, "dotfiles/.pi/agent/AGENTS.md"), "utf8");
	assert.match(instructions, /`\/skill:harness`/);
	assert.match(instructions, /小さな修正・単一ファイルの変更にはこの手順を強制しない/);
});
