---
allowed-tools: Bash(gh:*), Bash(git:*)
description: Update current PR's description
context: fork
---

## Context

Because we committed some changes to this branch after the pull request is created, so the pull request title and description could be outdated.

## Your task

Additional instructions from the user:

$ARGUMENTS

Please run the following command and understand the difference between current branch and master branch

```
git fetch origin
git diff origin/main...HEAD
```

Then, update the pull request title and description if needed.
