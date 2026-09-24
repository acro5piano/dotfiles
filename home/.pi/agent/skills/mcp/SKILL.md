---
name: mcp
description: Use registered MCP servers through the mcp CLI. Use when a task can be handled by an available MCP server such as Linear.
---

# MCP CLI

Check CLI usage and registered servers:

```bash
mcp --help
mcp list
```

List a server's available tools before choosing one:

```bash
mcp linear
```

Call tools with flags or JSON, for example:

```bash
mcp linear get_issue --id ABC-123
mcp linear get_issue '{"id":"ABC-123"}'
```

Use `mcp <server> tools` when full tool schemas are needed.
