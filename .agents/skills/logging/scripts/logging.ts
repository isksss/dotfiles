#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-run --allow-ffi --allow-net=jsr.io,github.com

import { Database } from "jsr:@db/sqlite@0.13.0";
import { basename, dirname, join } from "jsr:@std/path@1.0.9";

type RepoInfo = {
  repoName: string;
  repoPath: string;
  cwd: string;
  gitRemote: string;
  gitBranch: string;
  gitHead: string;
};

type RecordOptions = {
  promptFile?: string;
  noteFile?: string;
  summaryFile?: string;
  eventFiles: string[];
  includeGitPatch: boolean;
};

const now = () => new Date().toISOString();

function usage(): never {
  console.error(`Usage:
  logging.ts record --prompt-file <path|-> [--note-file <path>] [--summary-file <path>] [--event-file <path> ...] [--include-git-patch]
  logging.ts search <query>
  logging.ts show <session-id>

Environment:
  LOGGING_DB_PATH  Override DB path. Default: $HOME/logs.db`);
  Deno.exit(1);
}

function dbPath(): string {
  const override = Deno.env.get("LOGGING_DB_PATH");
  if (override) return override;
  const home = Deno.env.get("HOME");
  if (!home) {
    console.error("HOME is not set");
    Deno.exit(1);
  }
  return join(home, "logs.db");
}

function openDb(): Database {
  const path = dbPath();
  try {
    Deno.mkdirSync(dirname(path), { recursive: true });
  } catch {
    // Parent may already exist or be the current directory.
  }
  const db = new Database(path);
  initSchema(db);
  return db;
}

function initSchema(db: Database): void {
  db.exec(`
    PRAGMA journal_mode = WAL;
    CREATE TABLE IF NOT EXISTS sessions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      prompt TEXT NOT NULL DEFAULT '',
      note TEXT NOT NULL DEFAULT '',
      summary TEXT NOT NULL DEFAULT '',
      repo_name TEXT NOT NULL DEFAULT '',
      repo_path TEXT NOT NULL DEFAULT '',
      cwd TEXT NOT NULL DEFAULT '',
      git_remote TEXT NOT NULL DEFAULT '',
      git_branch TEXT NOT NULL DEFAULT '',
      git_head TEXT NOT NULL DEFAULT ''
    );
    CREATE TABLE IF NOT EXISTS events (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      session_id INTEGER NOT NULL,
      created_at TEXT NOT NULL,
      kind TEXT NOT NULL,
      title TEXT NOT NULL DEFAULT '',
      content TEXT NOT NULL DEFAULT '',
      FOREIGN KEY(session_id) REFERENCES sessions(id) ON DELETE CASCADE
    );
    CREATE INDEX IF NOT EXISTS idx_sessions_repo ON sessions(repo_name, repo_path);
    CREATE INDEX IF NOT EXISTS idx_events_session ON events(session_id);
  `);

  try {
    db.exec(`
      CREATE VIRTUAL TABLE IF NOT EXISTS sessions_fts
      USING fts5(prompt, note, summary, repo_name, cwd);
      CREATE VIRTUAL TABLE IF NOT EXISTS events_fts
      USING fts5(kind, title, content);
    `);
  } catch {
    // FTS5 is optional; search falls back to LIKE.
  }
}

function hasFts(db: Database, table: string): boolean {
  const rows = db.prepare(
    "SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?",
  ).all(table);
  return rows.length > 0;
}

async function readTextFile(path: string | undefined): Promise<string> {
  if (!path) return "";
  if (path === "-") return await new Response(Deno.stdin.readable).text();
  return await Deno.readTextFile(path);
}

function parseRecordOptions(args: string[]): RecordOptions {
  const options: RecordOptions = { eventFiles: [], includeGitPatch: false };
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === "--prompt-file") options.promptFile = args[++i];
    else if (arg === "--note-file") options.noteFile = args[++i];
    else if (arg === "--summary-file") options.summaryFile = args[++i];
    else if (arg === "--event-file") options.eventFiles.push(args[++i]);
    else if (arg === "--include-git-patch") options.includeGitPatch = true;
    else usage();
  }
  if (
    !options.promptFile && !options.summaryFile &&
    options.eventFiles.length === 0
  ) {
    console.error(
      "record requires at least --prompt-file, --summary-file, or --event-file",
    );
    Deno.exit(1);
  }
  return options;
}

async function runGit(
  args: string[],
  cwd: string,
  options: { allowFailure?: boolean } = {},
): Promise<string> {
  const command = new Deno.Command("git", {
    args,
    cwd,
    stdout: "piped",
    stderr: "null",
  });
  const output = await command.output();
  if (!output.success && !options.allowFailure) return "";
  return new TextDecoder().decode(output.stdout).trimEnd();
}

async function repoInfo(): Promise<RepoInfo> {
  const cwd = Deno.cwd();
  const repoPath = await runGit(["rev-parse", "--show-toplevel"], cwd);
  const root = repoPath || cwd;
  return {
    repoName: repoPath ? basename(repoPath) : "",
    repoPath,
    cwd,
    gitRemote: repoPath
      ? await runGit(["remote", "get-url", "origin"], root)
      : "",
    gitBranch: repoPath ? await runGit(["branch", "--show-current"], root) : "",
    gitHead: repoPath ? await runGit(["rev-parse", "HEAD"], root) : "",
  };
}

function insertEvent(
  db: Database,
  sessionId: number,
  kind: string,
  title: string,
  content: string,
): void {
  db.prepare(
    "INSERT INTO events (session_id, created_at, kind, title, content) VALUES (?, ?, ?, ?, ?)",
  ).run(sessionId, now(), kind, title, content);
  const eventId = Number(db.lastInsertRowId);
  if (hasFts(db, "events_fts")) {
    db.prepare(
      "INSERT INTO events_fts (rowid, kind, title, content) VALUES (?, ?, ?, ?)",
    ).run(eventId, kind, title, content);
  }
}

async function record(args: string[]): Promise<void> {
  const options = parseRecordOptions(args);
  const db = openDb();
  const info = await repoInfo();
  const timestamp = now();
  const prompt = await readTextFile(options.promptFile);
  const note = await readTextFile(options.noteFile);
  const summary = await readTextFile(options.summaryFile);

  db.prepare(
    `INSERT INTO sessions
      (created_at, updated_at, prompt, note, summary, repo_name, repo_path, cwd, git_remote, git_branch, git_head)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
  ).run(
    timestamp,
    timestamp,
    prompt,
    note,
    summary,
    info.repoName,
    info.repoPath,
    info.cwd,
    info.gitRemote,
    info.gitBranch,
    info.gitHead,
  );
  const sessionId = Number(db.lastInsertRowId);
  if (hasFts(db, "sessions_fts")) {
    db.prepare(
      "INSERT INTO sessions_fts (rowid, prompt, note, summary, repo_name, cwd) VALUES (?, ?, ?, ?, ?, ?)",
    ).run(sessionId, prompt, note, summary, info.repoName, info.cwd);
  }

  for (const file of options.eventFiles) {
    insertEvent(db, sessionId, "event", file, await readTextFile(file));
  }

  if (options.includeGitPatch) {
    if (!info.repoPath) {
      insertEvent(
        db,
        sessionId,
        "git-patch-skip",
        "Git patch skipped",
        "Not inside a git repository.",
      );
    } else {
      const status = await runGit(["status", "--short"], info.repoPath);
      const worktreePatch = await runGit(["diff", "--binary"], info.repoPath);
      const stagedPatch = await runGit(
        ["diff", "--cached", "--binary"],
        info.repoPath,
      );
      const untrackedFiles = (await runGit(
        ["ls-files", "--others", "--exclude-standard"],
        info.repoPath,
      )).split("\n").filter(Boolean);
      insertEvent(db, sessionId, "git-status", "git status --short", status);
      insertEvent(
        db,
        sessionId,
        "git-patch",
        "git diff --binary",
        worktreePatch,
      );
      insertEvent(
        db,
        sessionId,
        "git-patch",
        "git diff --cached --binary",
        stagedPatch,
      );
      for (const file of untrackedFiles) {
        const patch = await runGit(
          ["diff", "--no-index", "--binary", "--", "/dev/null", file],
          info.repoPath,
          { allowFailure: true },
        );
        insertEvent(
          db,
          sessionId,
          "git-patch",
          `git diff --no-index --binary /dev/null ${file}`,
          patch,
        );
      }
    }
  }

  db.close();
  console.log(`recorded session ${sessionId}`);
}

function likePattern(query: string): string {
  return `%${query.replaceAll("%", "\\%").replaceAll("_", "\\_")}%`;
}

function snippet(text: string, max = 160): string {
  const compact = text.replace(/\s+/g, " ").trim();
  return compact.length > max ? `${compact.slice(0, max)}...` : compact;
}

function search(args: string[]): void {
  const query = args.join(" ").trim();
  if (!query) usage();
  const db = openDb();
  const useFts = hasFts(db, "sessions_fts") && hasFts(db, "events_fts");
  let rows: Array<[number, string, string, string, string, string]>;

  if (useFts) {
    try {
      const ids = new Set<number>();
      for (
        const [id] of db.prepare(
          "SELECT rowid FROM sessions_fts WHERE sessions_fts MATCH ?",
        ).values(query) as Array<[number]>
      ) {
        ids.add(id);
      }
      for (
        const [id] of db.prepare(
          `SELECT e.session_id
           FROM events e
           JOIN events_fts ef ON ef.rowid = e.id
           WHERE events_fts MATCH ?`,
        ).values(query) as Array<[number]>
      ) {
        ids.add(id);
      }

      if (ids.size === 0) {
        rows = [];
      } else {
        const placeholders = Array.from(ids).map(() => "?").join(",");
        rows = db.prepare(
          `SELECT id, created_at, repo_name, cwd, summary, prompt
           FROM sessions
           WHERE id IN (${placeholders})
           ORDER BY id DESC
           LIMIT 20`,
        ).values(...ids) as Array<
          [number, string, string, string, string, string]
        >;
      }
    } catch {
      rows = likeSearch(db, query);
    }
  } else {
    rows = likeSearch(db, query);
  }

  for (const [id, createdAt, repoName, cwd, summary, prompt] of rows) {
    console.log(`#${id} ${createdAt} ${repoName || "-"} ${cwd}`);
    console.log(`  ${snippet(summary || prompt)}`);
  }
  db.close();
}

function likeSearch(
  db: Database,
  query: string,
): Array<[number, string, string, string, string, string]> {
  return db.prepare(
    `SELECT DISTINCT s.id, s.created_at, s.repo_name, s.cwd, s.summary, s.prompt
       FROM sessions s
       LEFT JOIN events e ON e.session_id = s.id
       WHERE s.prompt LIKE ? ESCAPE '\\'
          OR s.note LIKE ? ESCAPE '\\'
          OR s.summary LIKE ? ESCAPE '\\'
          OR e.content LIKE ? ESCAPE '\\'
          OR e.title LIKE ? ESCAPE '\\'
       ORDER BY s.id DESC
       LIMIT 20`,
  ).values(...Array(5).fill(likePattern(query))) as Array<
    [number, string, string, string, string, string]
  >;
}

function show(args: string[]): void {
  const id = Number(args[0]);
  if (!Number.isInteger(id) || id <= 0) usage();
  const db = openDb();
  const sessions = db.prepare(
    `SELECT id, created_at, updated_at, repo_name, repo_path, cwd, git_remote, git_branch, git_head, prompt, summary
     FROM sessions WHERE id = ?`,
  ).values(id) as Array<
    [
      number,
      string,
      string,
      string,
      string,
      string,
      string,
      string,
      string,
      string,
      string,
    ]
  >;
  if (sessions.length === 0) {
    console.error(`session not found: ${id}`);
    Deno.exit(1);
  }
  const [session] = sessions;
  console.log(`session: ${session[0]}`);
  console.log(`created_at: ${session[1]}`);
  console.log(`updated_at: ${session[2]}`);
  console.log(`repo: ${session[3]} ${session[4]}`);
  console.log(`cwd: ${session[5]}`);
  console.log(`remote: ${session[6]}`);
  console.log(`branch: ${session[7]}`);
  console.log(`head: ${session[8]}`);
  console.log("\n--- prompt ---");
  console.log(session[9]);
  console.log("\n--- summary ---");
  console.log(session[10]);

  const events = db.prepare(
    "SELECT id, created_at, kind, title, content FROM events WHERE session_id = ? ORDER BY id",
  ).values(id) as Array<[number, string, string, string, string]>;
  for (const [eventId, createdAt, kind, title, content] of events) {
    console.log(`\n--- event #${eventId} ${createdAt} ${kind}: ${title} ---`);
    console.log(content);
  }
  db.close();
}

const [command, ...args] = Deno.args;
if (command === "record") await record(args);
else if (command === "search") search(args);
else if (command === "show") show(args);
else usage();
