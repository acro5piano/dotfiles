import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { createHash } from "node:crypto";
import { existsSync, mkdirSync, readdirSync, readFileSync, rmSync, statSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { dirname, join, relative, resolve, sep } from "node:path";

function isDirectory(path: string): boolean {
  try {
    return statSync(path).isDirectory();
  } catch {
    return false;
  }
}

function isFile(path: string): boolean {
  try {
    return statSync(path).isFile();
  } catch {
    return false;
  }
}

function collectMarkdownFiles(dir: string): string[] {
  if (!isDirectory(dir)) return [];

  const files: string[] = [];
  const visit = (current: string) => {
    for (const entry of readdirSync(current, { withFileTypes: true })) {
      if (entry.name === "node_modules") continue;

      const fullPath = join(current, entry.name);
      if (entry.isDirectory()) {
        visit(fullPath);
      } else if ((entry.isFile() || entry.isSymbolicLink()) && entry.name.endsWith(".md") && isFile(fullPath)) {
        files.push(fullPath);
      }
    }
  };

  visit(dir);
  return files.sort();
}

function commandNameFor(root: string, filePath: string): string {
  const rel = relative(root, filePath).replace(/\.md$/i, "");
  return rel.split(sep).join(":");
}

function safeOutputName(commandName: string): string {
  // Pi command names are derived from file names. Keep Claude's ':' namespace
  // convention, but replace path separators and characters that are awkward in
  // file names or slash-command parsing.
  return commandName.replace(/[\\/\s\0]/g, "-");
}

function writeCommandAliases(outputDir: string, root: string, sourceFile: string, prefix: "user" | "project") {
  const source = readFileSync(sourceFile, "utf8");
  const commandName = safeOutputName(commandNameFor(root, sourceFile));
  const aliases = new Set([
    commandName,
    `${prefix}:${commandName}`,
  ]);

  for (const alias of aliases) {
    writeFileSync(join(outputDir, `${alias}.md`), source, "utf8");
  }
}

function findProjectClaudeCommandRoots(cwd: string): string[] {
  const roots: string[] = [];
  let current = resolve(cwd);

  while (true) {
    const commandDir = join(current, ".claude", "commands");
    if (isDirectory(commandDir)) roots.unshift(commandDir);

    // Stop at the repository root if we can recognize it; otherwise keep walking
    // to the filesystem root so non-git projects also work.
    if (existsSync(join(current, ".git"))) break;

    const parent = dirname(current);
    if (parent === current) break;
    current = parent;
  }

  return roots;
}

function refreshGeneratedCommands(cwd: string): string[] {
  const generatedRoot = join(homedir(), ".pi", "agent", "generated", "claude-commands");
  mkdirSync(generatedRoot, { recursive: true });

  const cwdHash = createHash("sha256").update(resolve(cwd)).digest("hex").slice(0, 12);
  const userOutputDir = join(generatedRoot, "user");
  const projectOutputDir = join(generatedRoot, `project-${cwdHash}`);

  rmSync(userOutputDir, { recursive: true, force: true });
  rmSync(projectOutputDir, { recursive: true, force: true });
  mkdirSync(userOutputDir, { recursive: true });
  mkdirSync(projectOutputDir, { recursive: true });

  const userRoot = join(homedir(), ".claude", "commands");
  for (const sourceFile of collectMarkdownFiles(userRoot)) {
    writeCommandAliases(userOutputDir, userRoot, sourceFile, "user");
  }

  for (const projectRoot of findProjectClaudeCommandRoots(cwd)) {
    for (const sourceFile of collectMarkdownFiles(projectRoot)) {
      // Ancestors are processed first; nearer project commands overwrite aliases.
      writeCommandAliases(projectOutputDir, projectRoot, sourceFile, "project");
    }
  }

  const promptPaths: string[] = [];
  if (collectMarkdownFiles(projectOutputDir).length > 0) promptPaths.push(projectOutputDir);
  if (collectMarkdownFiles(userOutputDir).length > 0) promptPaths.push(userOutputDir);
  return promptPaths;
}

export default function (pi: ExtensionAPI) {
  pi.on("resources_discover", async (event) => {
    return {
      promptPaths: refreshGeneratedCommands(event.cwd),
    };
  });
}
