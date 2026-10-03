{ config, lib, ... }:

# Claude Code commands and skills. Shared with the home server.
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles/home";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";

in
{
  home.file = {
    ".claude/commands".source = link ".claude/commands";
  }
  # Share pi skills with Claude Code. Link each skill individually because
  # ~/.claude/skills also holds Claude-managed skills (e.g. synced/).
  // lib.mapAttrs' (name: _: lib.nameValuePair ".claude/skills/${name}" {
    source = link ".pi/agent/skills/${name}";
  }) (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ../home/.pi/agent/skills));
}
