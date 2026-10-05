---
description: Create a Herdr worktree and hand the task to a new agent of the same kind
argument-hint: <task, optionally including a branch name or ticket ID>
allowed-tools: Bash(herdr:*), Bash(git:*), Bash(pwd:*), Bash(test:*)
---

# Work in a new Herdr worktree

## Task

$ARGUMENTS

## Goal

Act as the boss agent. Create a linked Git worktree through Herdr, start a new agent in that worktree, hand the full task to it, and switch the Herdr UI to the new agent. Keep this boss session in its current workspace.

The worker must use the same agent kind as the boss:

- Claude boss → Claude worker
- Pi boss → Pi worker

## Workflow

1. Verify that this session is managed by Herdr:

   ```bash
   test "${HERDR_ENV:-}" = 1
   ```

   If it is not, stop and tell the user that this command must run inside Herdr.

2. Inspect the current pane and repository:

   ```bash
   herdr pane current --current
   git rev-parse --show-toplevel
   git status --short --branch
   git branch --show-current
   ```

   Read the boss agent kind from `.result.pane.agent` in the Herdr response. Do not guess it. Only continue automatically when it is `claude` or `pi`.

3. Choose a branch name:

   - Use an explicit branch name or ticket ID from the task when provided.
   - Otherwise derive a short, descriptive kebab-case branch name from the task.
   - Follow repository-specific branch naming instructions when present.
   - Use the latest remote `main` (or project's default branch) as the base unless the task explicitly specifies another base.
   - Update the remote-tracking branch without changing branches in the boss workspace:

     ```bash
     git fetch origin main
     ```

   - After a successful fetch, use `origin/main` as the base. If the fetch fails or `origin/main` does not exist, stop and report the problem rather than falling back to a stale branch or the current `HEAD`.
   - Do not change branches in the boss workspace.

4. Check existing Herdr worktrees before creating one:

   ```bash
   herdr worktree list --cwd <repo-root>
   ```

   Do not create a duplicate workspace for a branch that is already open. If the requested branch is already being worked on by another agent, stop and report its workspace and agent instead of taking it over.

5. Create the worktree without stealing focus while setup is in progress:

   ```bash
   herdr worktree create --cwd <repo-root> --branch <branch> --base <base-ref> --label <short-label> --no-focus
   ```

   Parse the returned JSON. Use these exact values from the response rather than predicting them:

   - `.result.workspace.workspace_id`
   - `.result.root_pane.pane_id`
   - `.result.worktree.path`

   Do not add `--trust-repository` unless the user has explicitly verified and approved the repository.

6. Create a unique worker name matching `[a-z][a-z0-9_-]{0,31}`. Base it on the branch or ticket and check `herdr agent list` to avoid collisions.

7. Start the same kind of agent in the worktree's root shell pane:

   ```bash
   herdr agent start <worker-name> --kind <boss-agent-kind> --pane <root-pane-id>
   ```

   The root pane already has the worktree as its working directory. Do not start the worker with raw pane input or `herdr pane run`.

8. Hand off the complete original task to the worker. Include the branch and worktree path for clarity, and instruct it to inspect repository guidance, implement the task, run relevant checks, and report completion:

   ```bash
   herdr agent prompt <worker-name> "Work on the following task in branch <branch> at <worktree-path>. Read and follow all repository instructions before changing files. Implement the task, run relevant checks, and report the result. Task: <original task>"
   ```

   Do not use `--wait`; the user should be switched to the worker while it is working. Do not implement the task in the boss pane after handing it off.

9. Switch the Herdr UI to the worker:

   ```bash
   herdr agent focus <worker-name>
   ```

10. Report the branch, worktree path, workspace ID, pane ID, and worker name. State that the task has been handed off.

## Safety

- Never move the boss pane into the worktree workspace. The worker must be a new agent process started in the worktree's root pane.
- Never close a workspace, tab, pane, or agent that this command did not create.
- If agent startup is blocked or fails, inspect it with `herdr agent get` and `herdr agent read`; do not answer approval prompts without the user.
- If worktree creation may have succeeded despite an error, inspect `herdr worktree list` before retrying.
