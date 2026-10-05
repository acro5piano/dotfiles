{ username, ... }:

# Shared by every machine (desktop and home server)
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # mise (runtime version manager)
  programs.mise = {
    enable = true;
    globalConfig = {
      tools = {
        node = ["24" "22"];
        rust = "stable";
        bun = "latest";
        "npm:pnpm" = "10.34.1"; # To prevent mise ERROR Failed to install aqua:pnpm/pnpm@latest: no asset found: pnpm-linux-x64
        "npm:@anthropic-ai/claude-code" = "2.1.282";
        "npm:@openai/codex" = "0.157.0";
        "npm:prettier" = "latest";
        "npm:pyright" = "latest";
        "npm:typescript" = "latest";
        "npm:typescript-language-server" = "latest";
        "npm:@astrojs/language-server" = "latest";
        "npm:snyk" = "latest";
        "npm:@earendil-works/pi-coding-agent" = "0.87.1";
        "npm:@brave/brave-search-cli" = "1.7.0";
        "npm:@playwright/cli" = "0.1.21";
        "npm:wrangler" = "latest";

        herdr = "latest";
        python = "latest";
        uv = "latest";
        pipx = "latest";
        "pipx:awscli" = "latest";
        "pipx:ipython" = "latest";
        "pipx:iredis" = "latest";
        "pipx:litecli" = "latest";
        "pipx:mycli" = "latest";
        "pipx:athenacli" = "latest";
        "pipx:virtualenv" = "latest";

        "http:pinact" = {
          version = "4.0.0";
          url = "https://github.com/suzuki-shunsuke/pinact/releases/download/v4.0.0/pinact_linux_amd64.tar.gz";
          sha256 = "f8ce19b1f85c9754482e1e95d6344727a99d0362cb53860c688b540183034623";
        };

        "http:toggl" = {
          version = "0.1.6";
          url = "https://github.com/acro5piano/toggl-cli-rs/releases/download/v0.1.6/toggl-cli-rs";
          sha256 = "10960df89d10f853a1790299f62013c87105e93de5564350e19be298e70392c7";
          bin = "toggl";
        };

        "http:clipman" = {
          version = "1.6.2";
          url = "https://github.com/acro5piano/clipman/releases/download/1.6.2/clipman";
          sha256 = "bfa8e0fb4ec9c58185a9259089060dd610ec7a841f73b1fc82d70d1750c1e6ca";
        };

        "http:xremap" = {
          version = "0.14.8";
          url = "https://github.com/xremap/xremap/releases/download/v0.14.8/xremap-linux-x86_64-wlroots.zip";
          sha256 = "d405dde9bc66c57f43e23c0aee3da03b0e938fa9586517b3a4a380a7579092d5";
        };

        "http:gitleaks" = {
          version = "8.30.1";
          url = "https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz";
        };

        "http:mcp" = {
          version = "0.1.0";
          url = "https://github.com/acro5piano/mcp-cli/releases/download/v0.1.0/mcp-x86_64-unknown-linux-musl";
          sha256 = "ca6c4663333067c33475b3f1af62a95fb6e7a5dede47936f8e94ed028f3ae802";
        };
      };
    };
  };
}
