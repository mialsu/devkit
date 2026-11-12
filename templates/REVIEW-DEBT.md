# REVIEW-DEBT.md — <PROJECT>

The standing ledger of everything the green tests do NOT prove. Written at the moment a corner
is cut (`/confess`); dispositioned by the Owner at the close of each mandate (`/mandate`), from a
recommendation per entry: fixed / accepted-with-reason / promoted-to-issue. A stale ledger is worse
than none, because sessions trust it.

Two layers, so a fresh session does not pay for the whole file:
- **Index** — one line per entry still in the file. Sessions read this, and open an entry only
  when their work touches its files.
- **Entries** — the full record, below the index.

**Fixed** and **promoted-to-issue** entries leave the file, index line and all; git history keeps
them. **Accepted** entries stay: they describe a limit the code still has (a `CEILING:` among them).

## Index

<!-- Newest first. One line per entry: date — title — disposition. -->
- YYYY-MM-DD — <one-line title> — open

<!-- Entries, newest first. Template for an entry: -->

## YYYY-MM-DD — <one-line title>
- **What:** <what is stubbed / faked / deferred / weaker than spec>
- **Where:** <file:line anchors>
- **Criterion:** <`AC-N` from `specs/NNNN-slug.md`, quoted — omit if there was no spec>
- **Invariant:** `INV-N` from `INVARIANTS.md`, quoted  (omit unless a domain rule is involved)
- **Ceiling:** <what breaks at the limit, and the upgrade path — omit unless a `CEILING:` landed>
- **What green tests do NOT prove here:** <the specific gap>
- **Disposition:** open
