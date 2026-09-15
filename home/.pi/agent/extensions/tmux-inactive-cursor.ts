import { execFile } from "node:child_process";

import { CustomEditor, type ExtensionAPI } from "@earendil-works/pi-coding-agent";

const CHECK_INTERVAL_MS = 250;
const TMUX_QUERY_TIMEOUT_MS = 1000;
const REVERSE_VIDEO_CURSOR_RE = /\x1b\[7m([\s\S]*?)\x1b\[0m/;

class TmuxInactiveCursorEditor extends CustomEditor {
  private readonly tmuxPane = process.env.TMUX_PANE;
  private paneActive = true;
  private checking = false;
  private timer: ReturnType<typeof setInterval> | undefined;

  constructor(...args: ConstructorParameters<typeof CustomEditor>) {
    super(...args);

    if (this.tmuxPane) {
      this.checkPaneActive();
      this.timer = setInterval(() => this.checkPaneActive(), CHECK_INTERVAL_MS);
    }
  }

  dispose(): void {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = undefined;
    }
  }

  render(width: number): string[] {
    const originalFocused = this.focused;

    // Suppress the hardware cursor marker while this tmux pane is inactive.
    if (!this.paneActive) {
      this.focused = false;
    }

    let lines: string[];
    try {
      lines = super.render(width);
    } finally {
      this.focused = originalFocused;
    }

    if (this.paneActive) return lines;

    // Pi renders a fake cursor with reverse video. Hide just that first marker,
    // leaving prompt text and autocomplete UI intact in the inactive pane.
    let removed = false;
    return lines.map((line) => {
      if (removed) return line;
      const next = line.replace(REVERSE_VIDEO_CURSOR_RE, (_match, text: string) => {
        removed = true;
        return `${text}\x1b[0m`;
      });
      return next;
    });
  }

  private checkPaneActive(): void {
    if (!this.tmuxPane || this.checking) return;

    this.checking = true;
    execFile(
      "tmux",
      ["display-message", "-p", "-t", this.tmuxPane, "#{pane_active}"],
      { timeout: TMUX_QUERY_TIMEOUT_MS },
      (error, stdout) => {
        this.checking = false;

        // Fail open so the cursor behaves normally outside/after tmux hiccups.
        const nextPaneActive = error ? true : stdout.trim() === "1";
        if (nextPaneActive === this.paneActive) return;

        this.paneActive = nextPaneActive;
        this.tui.requestRender();
      },
    );
  }
}

export default function (pi: ExtensionAPI) {
  let editor: TmuxInactiveCursorEditor | undefined;

  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return;

    ctx.ui.setEditorComponent((tui, theme, keybindings) => {
      editor?.dispose();
      editor = new TmuxInactiveCursorEditor(tui, theme, keybindings);
      return editor;
    });
  });

  pi.on("session_shutdown", () => {
    editor?.dispose();
    editor = undefined;
  });
}
