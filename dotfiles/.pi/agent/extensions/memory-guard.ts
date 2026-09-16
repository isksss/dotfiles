import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { realpathSync } from "node:fs";
import { homedir } from "node:os";
import { isAbsolute, join, parse, resolve, sep } from "node:path";

const policy = "data.local への書き込みは用途・skill を問わず禁止。メモ・知見は ~/memory に保存し、保存・整理前に ~/.pi/agent/skills/memory/SKILL.md を読む。メモ以外の代替出力先は確認する。別ツール・間接実行で制限を回避しない。";
const hasDataLocal = (path: string) => path.split(/[\\/]/).includes("data.local");

function protectedPath(input: string, cwd: string): boolean {
	let path = input.replace(/^@/, "");
	if (path === "~" || path.startsWith("~/")) path = homedir() + path.slice(1);
	if (hasDataLocal(path)) return true;
	if (!isAbsolute(path)) path = `${cwd}/${path}`;
	// Resolve each existing component, including symlink parents of new files.
	let current = parse(path).root;
	for (const part of path.slice(current.length).split(sep)) {
		current = join(current, part);
		try {
			current = realpathSync(current);
		} catch (error) {
			if (!["ENOENT", "ENOTDIR"].includes((error as NodeJS.ErrnoException).code ?? "")) throw error;
		}
		if (hasDataLocal(current)) return true;
	}
	return false;
}

export default function (pi: ExtensionAPI) {
	// Runs after skill expansion, so the policy also applies to explicit /skill calls.
	pi.on("before_agent_start", (event) => ({
		systemPrompt: `${event.systemPrompt}\n\n${policy}`,
	}));

	pi.on("tool_call", (event, ctx) => {
		if (event.toolName === "write" || event.toolName === "edit") {
			if (typeof event.input.path !== "string") return { block: true, reason: "保存先を検査できません。" };
			if (protectedPath(event.input.path, ctx.cwd)) return { block: true, reason: policy };
		}
		if (event.toolName === "bash" || event.toolName === "powershell") {
			// ponytail: conservative text guard, not a sandbox. Indirect scripts/aliases
			// can evade it; use OS isolation if complete filesystem enforcement is needed.
			if (typeof event.input.command !== "string" || event.input.command.includes("data.local") || protectedPath(resolve(ctx.cwd), ctx.cwd)) {
				return { block: true, reason: `${policy} data.local を含むシェル呼び出し（読み取りも含む）は拒否する。参照には read / find / grep / ls を使う。` };
			}
		}
	});
}
