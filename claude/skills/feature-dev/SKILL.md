---
name: feature-dev
description: |
  Full feature development workflow: branch → implement → test → commit → push.
  Invoke with /feature-dev followed by a task description, issue number, or "issue #42".
  Trigger on: "implement issue #X", "work on this feature", "build X", or any coding
  task that should land on its own branch. PR creation is optional at the end.
  Available across all projects via ~/.claude/skills/.
argument-hint: "[issue #N | feature description] [--no-tests]"
allowed-tools: Read, Write, Bash, mcp__github, WebSearch, CodeReview, and any project-specific tools
---

# Feature Dev

Branch → implement → test → commit → push. PR is optional at the end.

Parse `$ARGUMENTS` first:

- Contains `issue #N` or `#N` → fetch the issue via GitHub CLI, use title + body as scope
- Contains `--no-tests` → skip test phase entirely
- Otherwise → treat the full argument string as the feature description

---

## Step 1 — Establish scope

**From a GitHub issue** (via GitHub MCP `get_issue`):

- Read title, body, and labels
- Use them to define what done looks like
- Branch name: `feat/issue-{N}-{slug}`

**From a description:**

- Use the argument as the feature description
- Branch name: `feat/{slug}` or `fix/{slug}` for bug fixes

Slugs: lowercase, hyphenated, max 4 words.

If no arguments were given, ask: "What are we building, and is there a GitHub issue number?"

---

## Step 2 — Create the branch

```bash
git checkout -b {branch-name}
```

Confirm branch is created before writing any code. If the branch already exists, ask: "Continue on the existing branch or create a fresh one?"

---

## Step 3 — Detect project type and test framework

Scan before touching anything:

| File present                           | Project type         |
| -------------------------------------- | -------------------- |
| `package.json`                         | Node.js / TypeScript |
| `pyproject.toml` or `requirements.txt` | Python               |
| `go.mod`                               | Go                   |
| `Cargo.toml`                           | Rust                 |

Within Node.js: check `package.json` for `jest`, `vitest`, or a `test` script.
Within Python: check for `pytest` or `unittest`.

**Testing decision:**

- Framework + existing tests → TDD by default, no need to ask
- Framework + no tests → ask: "Use TDD, write tests after, or skip?"
- No framework → ask: "Skip testing or set up a minimal harness?"
- `--no-tests` flag → skip without asking

---

## Step 4 — Implement

### With TDD (red → green)

For each meaningful component:

1. Write the failing test(s)
2. Implement until they pass
3. Show test output inline
4. Move to the next component

### Without tests

Implement directly. Briefly explain each significant decision as you go — what pattern you chose and why. Keep it concise, not a lecture.

---

## Step 5 — Full test run before committing

Run the complete suite:

```bash
npm test        # Node.js
pytest          # Python
go test ./...   # Go
cargo test      # Rust
```

Show the output. If failures:

- Explain what broke
- Ask: "Fix these before committing, or proceed anyway?"

Never commit a failing suite without explicit confirmation.

---

## Step 6 — Commit message review

Draft a conventional commit and show it before doing anything:

```
feat: {short description} [(fixes #N)]

- What was added/changed and why
- Any non-obvious decisions
- Test coverage summary (if tests were written)
```

Ask: "Approve, edit, or cancel?"

Do not run `git add` or `git commit` until the user approves.

Once approved:

```bash
git add .
git commit -m "{approved message}"
```

---

## Step 7 — Push, then ask about PR

```bash
git push origin {branch-name}
```

Then ask once:

> "Pushed to `{branch-name}`. Want me to open a PR, or are you merging directly?"

**PR requested:**

- Create via GitHub MCP `create_pull_request` with the issue link and a short summary
- Share the URL

**No PR:**

- Done. Branch is pushed and ready to merge whenever.

---

## Decision points

Only ask when genuinely ambiguous. Don't ask about things you can detect.

| When                     | Ask                                     |
| ------------------------ | --------------------------------------- |
| No arguments given       | "What are we building? Issue number?"   |
| Branch already exists    | "Continue on it or start fresh?"        |
| Testing ambiguous        | "TDD, write tests after, or skip?"      |
| Tests failing pre-commit | "Fix first or commit anyway?"           |
| Commit message           | Always show for approval before pushing |
| After push               | "Open a PR or merging directly?"        |

---

## Error handling

| Scenario               | Action                                                     |
| ---------------------- | ---------------------------------------------------------- |
| Issue not found        | Fall back to treating args as a description, mention it    |
| No git remote          | Warn, skip push step, offer to set up remote               |
| Push rejected          | Show the error, suggest fix (pull first, force push, etc.) |
| GitHub MCP auth fails  | Surface the auth error, ask user to reconnect the MCP      |
| Test framework missing | Ask before skipping — user may want to set one up          |
