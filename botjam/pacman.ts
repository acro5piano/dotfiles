import { botjam } from 'botjam'

botjam.configure({
  servers: ['localhost'],
  become: true,
})

for (const pkg of getPackages()) {
  botjam.tasks.pacman({
    name: pkg,
    updateCache: true,
    state: 'present',
  })
}

botjam.run()

// Packages for Linux lovers
function getPackages() {
  return [
    'acpi',
    'adobe-source-code-pro-fonts',
    'arch-install-scripts',
    'bat',
    'curl',
    'dnsutils',
    'docker',
    'docker-compose',
    'dunst',
    'fcitx5',
    'fcitx5-configtool',
    'fcitx5-gtk',
    'fcitx5-mozc',
    'fd',
    'feh',
    'fish',
    'fzf',
    'gcc',
    'gcc-fortran',
    'git',
    'git-delta',
    'github-cli',
    'go',
    'grim',
    'i3status-rust',
    'imagemagick',
    'jq',
    'ldns',
    'lua',
    'make',
    'man-db',
    'neovim',
    'noto-fonts',
    'noto-fonts-emoji',
    'ntp',
    'onefetch',
    'openssh',
    'openssl',
    'pavucontrol-qt',
    'pcmanfm',
    'pipewire',
    'pipewire-alsa',
    'pipewire-pulse',
    'postgresql-client',
    'python',
    'ripgrep',
    'rsync',
    'stylua',
    'terraform',
    'terraform-ls',
    'tmux',
    'tree',
    'ttf-sourcecodepro-nerd',
    'unzip',
    'vim',
    'wireplumber',
    'zip',
  ]
}
