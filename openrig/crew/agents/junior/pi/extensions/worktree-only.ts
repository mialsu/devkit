// worktree-only: the junior seat's file tools reach only its own worktree.
//
// Pi has no sandbox and its file tools take any path, so this gate is the boundary. crew-up writes
// the worktree into ROOT when it installs this file into the seat's agent directory; OpenRig passes
// Pi no environment of ours, so CREW_JUNIOR_ROOT and the launch folder are only the fallback (and
// what worktree-only.check.mts uses). Every read, edit, write, grep, find and ls is resolved,
// symlinks included, and refused unless it lands inside the worktree and outside the paths that
// run as the Owner later (.git, hooks) or configure an agent. A tool this file does not know is refused too, and a handler error blocks
// the call (Pi's fail-safe), so a mistake here fails closed.
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { realpathSync } from "node:fs";
import { homedir } from "node:os";
import { dirname, isAbsolute, join, relative, resolve, sep } from "node:path";
import { fileURLToPath } from "node:url";

const FILE_TOOLS = new Set(["read", "edit", "write", "grep", "find", "ls"]);
const BLOCKED = [".git", ".githooks", ".claude", ".pi", ".openrig", ".crew", "CLAUDE.local.md", "node_modules"];

// The deepest existing ancestor's real path, with the rest appended, so a file that does not
// exist yet is still checked through any symlinked folder above it.
function real(p: string): string {
  let head = p;
  const tail: string[] = [];
  for (;;) {
    try {
      return resolve(realpathSync(head), ...tail.reverse());
    } catch {
      const up = dirname(head);
      if (up === head) return p;
      tail.push(head.slice(up.length + 1));
      head = up;
    }
  }
}

// Pi's own expansion (utils/paths.js normalizePath, which is not exported): unicode spaces, a
// leading @, ~ and file:// URLs. The gate must see the path the tool will open, not the one typed.
function expand(p: string): string {
  let s = p.replace(/[  -   　]/g, " ");
  if (s.startsWith("@")) s = s.slice(1);
  if (s === "~") return homedir();
  if (s.startsWith("~/")) return join(homedir(), s.slice(2));
  if (/^file:\/\//.test(s)) return fileURLToPath(s);
  return s;
}

// find's pattern and grep's glob are matched under the path, but one that climbs or is rooted
// elsewhere is refused rather than reasoned about.
function escapes(pattern: unknown): boolean {
  if (typeof pattern !== "string") return false;
  const s = expand(pattern);
  return isAbsolute(s) || s.split(/[\\/]/).includes("..");
}

const ROOT = "__CREW_JUNIOR_ROOT__";

export default function (pi: ExtensionAPI) {
  const start = ROOT.startsWith("__") ? process.env.CREW_JUNIOR_ROOT || process.cwd() : ROOT;
  const root = real(resolve(start));

  pi.on("tool_call", async (event) => {
    if (!FILE_TOOLS.has(event.toolName)) {
      return { block: true, reason: `${event.toolName} is not a tool this seat may use` };
    }
    const input = event.input as { path?: unknown; pattern?: unknown; glob?: unknown };
    if ((event.toolName === "find" && escapes(input.pattern)) || escapes(input.glob)) {
      return { block: true, reason: "a search pattern may not leave this seat's worktree" };
    }
    const given = typeof input.path === "string" && input.path.length > 0 ? input.path : ".";
    const expanded = expand(given);
    const target = real(isAbsolute(expanded) ? expanded : resolve(root, expanded));
    const rel = relative(root, target);
    if (rel.startsWith("..") || isAbsolute(rel)) {
      return { block: true, reason: `${given} is outside this seat's worktree (${root})` };
    }
    const first = rel.split(sep)[0];
    if (BLOCKED.includes(first)) {
      return { block: true, reason: `${given} is a protected path` };
    }
    return undefined;
  });
}
