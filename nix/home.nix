{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # Packages from yay.yml
  home.packages = with pkgs; [
    # Fonts
    ipaexfont # otf-ipaexfont equivalent

    # Browsers
    brave # brave-bin equivalent

    # Android SDK - uncomment if needed
    # androidenv.androidPkgs.platform-tools
    # androidenv.androidPkgs.build-tools
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
    "nvim/init.lua".source = ./home/.config/nvim/init.lua;
    "nvim/lua".source = ./home/.config/nvim/lua;
  };
}
