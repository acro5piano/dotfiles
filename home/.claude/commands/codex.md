---
name: codex
description: Solve complex problem using OpenAI's Codex CLI.
context: fork
---

# Codex

A skill for executing analysis using Codex CLI.

## Request

$ARGUMENTS

## Command

codex exec --full-auto --sandbox read-only --cd <project_directory> "<request>"

## Parameters

| Parameter             | Description                              |
| --------------------- | ---------------------------------------- |
| `--full-auto`         | Run in fully automatic mode              |
| `--sandbox read-only` | Read-only sandbox (for safe analysis)    |
| `--cd <dir>`          | Target project directory                 |
| `"<request>"`         | Request content (any language supported) |

## Examples

### Bug Investigation

codex exec --full-auto --sandbox read-only --cd /path/to/project "Investigate the cause of errors occurring in authentication processing"

## Execution Steps

1. Receive the request from the user
2. Identify the target project directory
3. Execute Codex using the command format above
4. Report the results to the user

## Notes

- If you use Codex skill for analysis, double-check and verify the output on your own.
- Use this skill when you needs extra knowledge or third party opinions.
