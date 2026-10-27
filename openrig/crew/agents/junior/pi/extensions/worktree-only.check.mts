// worktree-only.check.mts: the junior's worktree gate, run against paths it must allow and refuse.
//
//   node --experimental-strip-types openrig/crew/agents/junior/pi/extensions/worktree-only.check.mts
//
// The gate is the only thing between a small model with write access and the Owner's home folder,
// so every escape it was built against is a case here: ~, @, file://, .., absolute paths, a symlink
// out of the worktree, the folders that run as the Owner (.git, hooks), search patterns that climb,
// and a tool it does not know. Exits 1 on any case that goes the wrong way.
import { mkdtempSync, mkdirSync, rmSync, symlinkSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const base = mkdtempSync(join(tmpdir(), "worktree-only-"));
const root = join(base, "worktree");
const outside = join(base, "outside");
mkdirSync(join(root, "src"), { recursive: true });
mkdirSync(outside);
symlinkSync(outside, join(root, "escape"));
process.env.CREW_JUNIOR_ROOT = root;

const gate = fileURLToPath(new URL("./worktree-only.ts", import.meta.url));
type Handler = (event: { toolName: string; input: unknown }) => Promise<{ block?: boolean } | undefined>;
let handler: Handler | undefined;
(await import(gate)).default({ on: (_event: string, h: Handler) => { handler = h; } });

const cases: [tool: string, input: Record<string, unknown>, allowed: boolean][] = [
  ["write", { path: "src/new.ts" }, true],
  ["write", { path: join(root, "src/new.ts") }, true],
  ["read", { path: "src/new.ts" }, true],
  ["grep", { pattern: "x" }, true],
  ["ls", {}, true],
  ["find", { pattern: "**/*.ts" }, true],
  ["write", { path: "~/.bashrc" }, false],
  ["write", { path: "@~/.bashrc" }, false],
  ["write", { path: "../evil" }, false],
  ["write", { path: "/etc/evil" }, false],
  ["write", { path: `file://${outside}/evil` }, false],
  ["read", { path: "escape/secret" }, false],
  ["write", { path: "escape/new" }, false],
  ["write", { path: ".git/hooks/pre-commit" }, false],
  ["write", { path: ".githooks/pre-commit" }, false],
  ["write", { path: "src/../.git/config" }, false],
  ["write", { path: ".pi/settings.json" }, false],
  ["write", { path: ".claude/settings.local.json" }, false],
  ["find", { pattern: "../../**" }, false],
  ["grep", { pattern: "x", glob: "/etc/*" }, false],
  ["bash", { command: "id" }, false],
];

let wrong = 0;
for (const [tool, input, allowed] of cases) {
  const result = await handler!({ toolName: tool, input });
  const got = !result?.block;
  if (got !== allowed) wrong++;
  console.log(`${got === allowed ? "ok  " : "FAIL"} ${tool} ${JSON.stringify(input)} -> ${got ? "allowed" : "blocked"}`);
}
rmSync(base, { recursive: true, force: true });
console.log(wrong ? `${wrong} of ${cases.length} went the wrong way` : `all ${cases.length} cases hold`);
process.exit(wrong ? 1 : 0);
