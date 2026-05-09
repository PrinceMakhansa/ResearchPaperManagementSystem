---
name: commit-preference
description: User wants to verify changes before committing/pushing
type: feedback
---

**Rule:** Never auto-commit or auto-push. Always show changes first and let user verify before committing.

**Why:** User wants to review and control when code goes to remote.

**How to apply:** After completing work, show `git status` and `git diff` so user can review before committing and pushing themselves.