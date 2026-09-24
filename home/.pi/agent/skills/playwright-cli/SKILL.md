---
name: playwright-cli
description: Automate and inspect web pages with @playwright/cli. Use for browser navigation, interaction, screenshots, and UI testing. Prefer attaching to an existing browser over launching a new one.
---

# Playwright CLI

Prefer a CDP session:

```bash
playwright-cli attach --cdp=http://localhost:9222
```

If you can't connect, run browser background:

```bash
chromium --remote-debugging-port=9222 --user-data-dir=/home/kazuya/chrome-profiles/chromium-for-playwright-mcp
```

Then run commands against the attached browser, for example:

```bash
playwright-cli goto https://example.com
```

Use `playwright-cli --help` or `playwright-cli <command> --help` when needed.
