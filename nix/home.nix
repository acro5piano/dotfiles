{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  # Packages from yay.yml
  home.packages = with pkgs; [
    brave
    chromium
    delta
    fzf
    ipaexfont
    ripgrep
    rust-analyzer
    ruff
    stylua
    terraform
  ];

  # mise (runtime version manager)
  programs.mise = {
    enable = true;
    globalConfig = {
      tools = {
        node = "24";
        pnpm = "latest";
        rust = "stable";
        "npm:@anthropic-ai/claude-code" = "2.0.59";
        "npm:prettier" = "latest";
        "npm:pyright" = "latest";
        "npm:typescript-language-server" = "latest";
        "npm:@astrojs/language-server" = "latest";
        "ubi:LuaLS/lua-language-server" = "latest";
      };
    };
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Link existing Neovim config
  xdg.configFile = {
    "nvim/init.lua".source = ../home/.config/nvim/init.lua;
    "nvim/lua".source = ../home/.config/nvim/lua;
  };
}
