---
allowed-tools: Bash(gh:*), Bash(git:*)
description: Commit and push
---

## Context

- Current git status: !`git status`
- Staged changes: !`PAGER=none git diff HEAD`
- Branch name argument (if provided): $ARGUMENTS

## Your task

- If a branch name (ticket ID) was provided as an argument, use it as the branch name
- Commit to git
- Push to current branch, even if it's `main` branch

## Notes

- Write **"Why"** rather than "What" in commit message.
- Do not modify code. I might have updated code after you modified code.
- Do not use `git push`. use `git push origin <branch>` to avoid unexpected operations.
- Commit immediately, without confirming human.
