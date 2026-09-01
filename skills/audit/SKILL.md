---
name: audit
description: Audit a repo like a security engineer — authorization, authentication, injection, secrets in history, vulnerable dependencies, SSRF, unsafe data exposure — where every finding carries a verdict (exploited / reachable / suspected) with file:line at each hop, ranked by reachability before severity. Use when the user says "security audit", "audit this codebase", "is this safe to ship", "find vulnerabilities", or before a project first meets real users.
disable-model-invocation: true
argument-hint: "[path or area to audit]"
---

An agent-generated, severity-ranked security report is the **pseudo-artifact** in its purest form:
it reads like understanding, the next session cites it, and it carries none. This failure mode is
not hypothetical — confident, plausible, wrong vulnerability reports are currently the dominant form
of security noise in open source. `ANTI-PATTERNS.md` already rules on it: *an absent document is
honest; a confident wrong one is not.*

So this skill inverts the usual output. **A finding is a claim about the code, and it carries the
same burden as any other claim here** (PRINCIPLES #6): a verdict, and file:line at every hop. A
report of forty ranked "issues" is worth less than three findings you can demonstrate and one honest
sentence about what you did not look at.

Two phases with a hard gate between, for the reason `/prune` has one: finding is safe, and fixing
touches working authentication code.

## What this skill does NOT do (reuse before building)

| Piece | Owned by | Why not here |
|---|---|---|
| the authorization rules themselves | **`INVARIANTS.md`** — *who may see or change a row and why, not just "is logged in"* | this skill **attacks** those rules; it does not invent them. An authz rule it finds unenforced becomes an `INV-n` row with an enforcer, not a paragraph in a report that expires with the session |
| attacking the invariants one slice touches | `/verify-live` (dk) | that runs per-slice, at build time. This runs repo-wide, on demand — the same move at a different scope |
| the standards a fix must conform to | `CODING_STANDARDS.md` → `/code-review` (mp) | its two axes are Standards and Spec. It has no security axis, which is why this skill exists |
| finding secrets, CVEs, and injection patterns | `gitleaks`, the ecosystem's audit command, `semgrep` | never hand-roll a regex sweep for a job a maintained scanner does properly and keeps current |

---

# Phase 1 — find, with verdicts

## 1. Three questions to the Owner, before anything is scanned
Severity is not yours to assign (PRINCIPLES #11). Ranking needs to know what the data is worth and
how far the blast reaches, and only the Owner knows that. Ask, one at a time, each with a
recommendation:

1. **What are we actually protecting?** Name it — "the members' phone numbers and who booked what",
   not "user data". If the honest answer is *nothing yet, there are no users and no real data*, say
   so and let the audit be short. A fixture repo does not need a CVSS table.
2. **Who is plausibly attacking?** For a solo project this is almost always **a logged-in user of
   your own app poking at other people's rows**, and occasionally an untargeted internet scanner.
   It is not a nation state, and ranking as though it were makes the report unreadable.
3. **What is the worst outcome?** Money moves, data leaks, an account is taken over, or a metered
   API gets billed to death. This is the impact axis in step 6.

If the Owner short-circuits, proceed — and record each unanswered question in the report, because a
ranking built on an assumed threat model has to say so.

## 2. Scope, and name what you are not covering
Take the area the Owner named, or the whole repo if it is small. Then write down, before you start,
what this pass will **not** cover — infrastructure, the hosting account, a third-party service, the
CI configuration, anything outside this repo. An audit never proves absence, and a report that does
not say where it stopped implies it looked everywhere.

## 3. Start at the invariants — authorization first
Broken **object-level authorization** is the most common real vulnerability in a solo application,
and this method already has the file for it. If `INVARIANTS.md` exists, every `INV-n` that governs
who may see or change something is a test case: **find the code path that reaches the data without
passing the enforcer.** A second entry point to the same operation, a batch or export route, an
admin helper reused on a user path, a query missing the tenant filter.

If `INVARIANTS.md` does not exist because the domain dial is off, the rules are still somewhere —
usually one middleware and a handful of `if` statements. Write down what they appear to be and
confirm them with the Owner; a rule you inferred is a claim, and an authz check nobody can state is
already the finding.

**Authentication is a different axis and gets checked separately:** session lifetime and revocation,
where the token is stored, whether logout invalidates anything server-side, the password-reset flow
(the most-skipped surface in any app), and whether the JWT library is actually *verifying* rather
than decoding.

## 4. Work the categories — what each looks like in an agent-built repo

| Category | What it actually looks like here |
|---|---|
| **Injection** | one raw query beside forty parameterized ORM calls; a shell-out built by string concatenation; a template rendered from user input. The ORM is usually fine — spend the time on the exceptions |
| **Secrets** | **in git history, not the working tree.** A key committed in March and "removed" in April is still live. Scan the whole history, not the checkout |
| **Dependencies** | the ecosystem's audit command. Cheap, current, and the one category where the tool genuinely outperforms reading |
| **Data exposure** | the endpoint returns the whole row and the UI hides three fields — invisible on screen, total in the response. Plus stack traces reaching the client, PII in logs and crash reports, source maps in production, a debug route that survived |
| **SSRF & unsafe fetch** | anywhere a user-supplied URL is fetched: webhooks, image proxies, link previews, "import from URL". The metadata endpoint is the target |
| **Edges** | file upload (type, size, and the path it lands on), redirect targets, path traversal in anything that joins user input to a filesystem path, deserialization of anything |
| **Transport & headers** | CORS wildcard combined with credentials; missing CSRF protection when auth is cookie-based; cookie flags; a security header set on the page and not the API |

**Rate limiting gets pushed back on, not listed.** It is a mitigation, not a vulnerability class,
and on a project with no users it is usually *correctly* deferred — the honest output is a non-goal
with a trigger ("revisit when: real users, or the first bill"). Two exceptions are real immediately:
anything that **costs money per call** (LLM APIs, SMS, email) and **authentication endpoints**
(credential stuffing). Say which of the two applies, or say neither does.

## 5. Run the tools, then verify they fit
`profiles/<domain>/PROFILE.md` → **Security surface** names them. As always, confirm the tool exists
and is maintained before trusting a row it prints (`/harness` step 1). Scanner output is a source of
**leads**, not findings — every row still has to earn a verdict in step 6.

## 6. Give every finding a verdict, then rank
| Verdict | Earned by |
|---|---|
| **exploited** | you made it happen — the request and response, or a test that fails against a local instance and demonstrates the flaw |
| **reachable** | you traced attacker-controlled input to the flaw with file:line at every hop, but did not fire it |
| **suspected** | a pattern matched and the path is untraced |

**Everything a scanner hands you starts at `suspected`.** That pile is where every hallucinated
finding lives, so it is labelled and never ranked — a suspected finding is a lead, and the honest
report says how many leads it could not run down.

Demonstration is **static plus local execution**: trace, scan, and write failing tests against a
local instance. Nothing deployed is touched — no live traffic, no third-party service, and no
sending this repo's code or secrets to any external scanner (that is a hard limit in `CLAUDE.md`,
not a preference). If a finding can only be proven against the deployed app, it stays `reachable`
and says why.

Then rank **reachability × impact, reachability first**. A SQL injection reachable only from one
admin call site with a literal argument outranks nothing. Impact comes from the Owner's answer to
question 3, not from a generic severity table.

## 7. Report, and stop
One table — finding, verdict, reach, impact, the fix in one sentence — ordered by the ranking, with
the `suspected` pile below a line and counted. Then the paragraph that makes the document honest:
**what you did not look at, and what would have to be true for these findings to be wrong.**

Recommend, do not decide (PRINCIPLES #8). **No fix is written before the Owner's go.**

---

> **Phase gate.** Phase 1 reads. Phase 2 edits authentication and authorization code, where a
> confident wrong finding becomes a confident wrong commit and the gates cannot tell. Separate go,
> and stopping here is a legitimate outcome.

# Phase 2 — fix, one finding at a time

## 8. The regression test comes first
A security fix with no test is a fix that comes back — usually via a second code path, six weeks
later. For each finding: **write the test that demonstrates the flaw, watch it fail, then fix, then
watch it pass.** That is PRINCIPLES #2 aimed at a vulnerability, and it converts the finding from a
verdict into an enforcer that outlives the report.

A finding at `suspected` cannot have that test written, which is the practical reason the pile is
labelled: **do not fix a suspected finding.** Run it down to `reachable` first, or leave it.

## 9. One finding per commit, gates green between
Never batch security fixes, and never fold one into an unrelated change — if a fix breaks
something, the revert must be surgical. The profile's full gate set runs between each.

## 10. Secrets: rotate first, then purge
The order is not negotiable and the sketch of this skill got it backwards. **Rotate the credential
before touching git history** — removing a commit does not un-publish a value that has been on a
remote, in a fork, in someone's cache, or in a CI log. Then purge, then confirm the old value is
dead by trying it. Rewriting shared history is a `/ship`-class act: it needs the Owner's explicit
go, and it is the Owner who runs it.

## 11. Wire what you found into the gates
Same finish as `/prune`, and the same reason — an audit with nothing behind it just runs again in
three months. `gitleaks` in the pre-commit hook, the ecosystem's audit command in the gate set,
`semgrep` if the repo earns it (`/harness` step 6). Then **break each one on purpose and watch it go
red**, or it is not a gate (PRINCIPLES #2). Any authz rule this audit established belongs in
`INVARIANTS.md` with its enforcer named; upgrade the `[review-only]` tags in
`CODING_STANDARDS.md`'s **Secrets & data exposure** section to `[gate]` only for the ones now
genuinely wired.

## 12. Report
What was found and at which verdict; how many leads stayed `suspected` and why; what was fixed, each
with its failing-then-passing test; what was deferred with its trigger; the gates you wired with
their pass → fail → pass; and what you did not look at. Then `/confess` the rest — including, if it
applies, the sentence that an audit is a snapshot and this one had a scope.
