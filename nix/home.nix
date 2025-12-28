{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  # Packages from yay.yml
  home.packages = with pkgs; [
    # Fonts
    ipaexfont

    # Browsers
    brave
    chromium

    # Development
    nodejs_24
    pnpm
    nodePackages.prettier
  ];

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
      nodePackages.vscode-langservers-extracted # eslint, html, css, json
      astro-language-server

      # Formatters
      stylua
      ruff
      nodePackages.prettier
      nodePackages.sql-formatter
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
