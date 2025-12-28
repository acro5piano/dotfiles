{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  # Packages from yay.yml
  home.packages = with pkgs; [
    ipaexfont
    brave
    chromium
  ];

  # mise (runtime version manager)
  programs.mise = {
    enable = true;
    globalConfig = {
      tools = {
        node = "24";
        "npm:@anthropic-ai/claude-code" = "latest";
      };
    };
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Dependencies for plugins and formatters used in init.lua
    extraPackages = with pkgs; [
      # LSP servers
      pyright
      typescript-language-server
      lua-language-server
      rust-analyzer
      solargraph
      astro-language-server

      # Formatters
      stylua
      ruff
      terraform

      # Tools
      ripgrep
      fzf
      delta # for git diff preview
    ];
  };

  # Link existing Neovim config
  xdg.configFile = {
    "nvim/init.lua".source = ../home/.config/nvim/init.lua;
    "nvim/lua".source = ../home/.config/nvim/lua;
  };
}
