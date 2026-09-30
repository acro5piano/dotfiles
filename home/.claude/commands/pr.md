---
allowed-tools: Bash(gh:*), Bash(git:*)
description: Generate PR description and automatically create pull request on GitHub
---

## Context

- Current git status: !`git status`
- Changes in this PR: !`git diff origin/main...HEAD`
- Branch name argument (if provided): $ARGUMENTS

## Your task

- If a branch name (ticket ID) was provided as an argument, use it as the branch name
- If the current branch is `main` or `master`, create an appropriate branch
  - If a branch name is provided, use it
  - If not provided, create a branch on your own. Ignore project-specific rule in this case.
- Commit to git
- Push to current branch
- Create a pull request

## Notes

- Write **"Why"** rather than "What" in commit message.
- Do not modify code. I might have updated code after you modified code.
- Do not use `git push`. use `git push origin <branch>` to avoid unexpected operations.
- Commit immediately, without confirming human.
