# Dotfiles

acro5piano's personal dotfiles. It aims to automate setup my development PC idempotently.

Core technologies:

- Arch Linux
- Sway
- Alacritty
- Brave Browser

<table>
  <td>
    <img src="https://user-images.githubusercontent.com/10719495/176838810-ea61f97a-7f7f-4c8b-80f7-243ee8eb8de9.png" />
  </td>
  <td>
    <img src="https://user-images.githubusercontent.com/10719495/176839022-bcaf0d70-3395-4b6e-812e-ff676c8294c0.png" />
  </td>
</table>

<table>
  <td>
    <img src="https://user-images.githubusercontent.com/10719495/202087327-462649bd-d3df-45c7-b0e0-62e35074769f.png" />
  </td>
  <td>
    <img src="https://user-images.githubusercontent.com/10719495/224475627-923fb9fd-592c-4079-8605-91c50755cef8.png" />
  </td>
</table>

# Setup process

The following document assumes you have:

- A UEFI boot device
- No multie boot device (Windows multi boot document below)

## Install Arch Linux

- Create arch linux install usb.
  - download the latest iso image
  - `cp /path/to/iso /dev/sdX`
- Boot to usb

### File system (UEFI)

select disk to write arch linux

```sh
cfdisk /dev/nvme0n1
```

- Create a partition for UEFI `/dev/nvme0n1p1`
  - create a new partition and set maximum size for it
- Create a partition for swap (for hibernation) `/dev/nvme0n1p2`
  - create a new partition and set `40G` size for it
  - Set the type for `Linux swap`
- Create a partition for main `/dev/nvme0n1p3`
  - create a new partition and set maximum size for it
- write out

Swap is required for hibernation.

```sh
# UEFI
mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3
mount /dev/nvme0n1p3 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

### Install base system

```sh
# Connect to a Network
iwctl

pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware iwd python git vim neovim
genfstab -U /mnt >> /mnt/etc/fstab

# Enter new arch
arch-chroot /mnt

# Configure iwd
cat <<'EOF'| sudo tee /etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true
EOF

# Connect to a Network
iwctl

# install /boot
bootctl install
```

Create `/boot/loader/entries/arch.conf`

```
title Arch Linux Zen
linux /vmlinuz-linux-zen
initrd /initramfs-linux-zen.img

options root=UUID=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx acpi_backlight=native rw resume=UUID=xxxxxxxxxxxxxxxxxxxx
```

Add user:

```
# add user
useradd --create-home kazuya
passwd kazuya
gpasswd -a kazuya wheel
EDITOR=vim sudo visudo
```

Then exit and reboot.

Notes:

- Python is required because we use Ansible later.
- If you have any problems on resolving name, edit `/etc/systemd/resolved.conf` and fix dns to `8.8.8.8`.
- systemd-boot is pre-installed and simple to use than Grub unless dual boot with Windows.

## Add user

Run the following commands as root:

```sh

visudo /etc/sudoers.d/admin

# Recommended config:
#   %wheel ALL=(ALL) ALL
#   %wheel ALL=NOPASSWD: /bin/systemctl restart iwd
#   %wheel ALL=NOPASSWD: /bin/systemctl restart bluetooth
#   %wheel ALL=NOPASSWD: /home/kazuya/bin/connect-client-vpn
#   %wheel ALL=NOPASSWD: /home/kazuya/bin/connect-client-vpn-stop

exit
```

and login as kazuya:

```sh
localhost login> kazuya
password:
```

## Install dotfiles

then install dotfiles:

```sh
cd ~
git clone git@github.com:/acro5piano/dotfiles $HOME/.dotfiles
cd $HOME/.dotfiles
python -m ensurepip
export PATH=$PATH:~/.local/bin/
pip install ansible
ansible-galaxy collection install community.general kewlfft.aur
ansible-playbook --ask-become-pass ansible/main.yml
```

For groups, please take a look at:

https://github.com//acro5piano/dotfiles/blob/e0ef379e4326bd102abddc28bd5946b52cbeee06/pkg_init/arch#L1

## Copy large & secure files

```
mkdir $HOME/var
scp -r 192.168.xxx.yyy:/home/kazuya/var/music $HOME/var/music
scp -r 192.168.xxx.yyy:/home/kazuya/.aws $HOME/.aws
scp -r 192.168.xxx.yyy:/home/kazuya/.ssh $HOME/.ssh
```

## Bluetooth

By default bluetooth connection takes too much time. Here is the fix: https://gist.github.com/andrebrait/961cefe730f4a2c41f57911e6195e444#enable-bluetooth-fast-connect-config

# Maintain

```
# Sync dotfiles only ansible-playbook ansible/main.yml --tags dotfiles

# Install pacman dep only
ansible-playbook --ask-become-pass ansible/main.yml --tags pacman
```

# OSX

```
ansible-playbook ansible/main.yml --tags dotfiles,misc,npm,pip,gem --extra-vars "os=mac"
```

# Windows Multi boot

For Windows Multi boot environment, do this before `cfdisk` phase:

- **On windows**,
  - Reduce Windows partition to minimum 80GB
  - Create a blank partition for Linux

And use this commands for the initial setup, replacing `systemd-boot` thing (as Grub is easier than systemd-boot if you do multi-boot):

```sh
# systemd-boot
mkdir /boot
mount /dev/sda1 /boot

# Grub
os-prober
grub-install
grub-mkconfig -o /boot/grub/grub.cfg

# Grub options
nvim /etc/default/grub # Enable this line: GRUB_DISABLE_OS_PROBER=false
```

# Windows + WSL2 Arch

For Windows, use them:

- Wezterm (To support select-to-copy on Surface touch screen)
- WSL2 Arch
- PowerToys (To customize key bindings on Browsers)

For Arch installation, see the awesome https://github.com/yuk7/ArchWSL

### Tweaks of installation process

Before git clone:

```bash
export PATH=$PATH:~/.local/bin/
sudo pacman -Syu git openssh
```

Replace the Ansile command with:

```
ansible-playbook wsl/ansible/main.yml
ansible-playbook ansible/main.yml --tags pip,npm,misc
chsh -s /usr/bin/fish
```

# Enable hibernation with swap partition

Linux supports swapfile, but it is not reliable as of 2024. swapfile causes the `hibernate inconsistent memory map detected` error while resuming.

Specify swap partition

```bash
# /etc/fstab

UUID=7efab515-xxxx-xxxx-xxxx-7e17afceeacb none swap defaults 0 0
```

Modify HOOKS in mkinitcpio config like this:

```
# /etc/mkinitcpio.conf

HOOKS=(base udev autodetect keyboard modconf block filesystems resume fsck)
```

Then run

```
sudo mkinitcpio -p linux
```

Add resume to the kernel parameter:

```
# /boot/loader/entries/arch.conf

options root=UUID=63f7f18e-xxxx-xxxx-xxxx-e3fc0e2e4666 resume=UUID=7efab515-xxxx-xxxx-xxxx-7e17afceeacb acpi_backlight=native rw
```

You also may want to change the power button behavior:

```
/etc/systemd/logind.conf

# ...
HandlePowerKey=hibernate
HandleLidSwitch=ignore
# ...
```

# Tweak Bluetooth config

Follow https://gist.github.com/acro5piano/9606ce598e04c10dde1948cf7e098f80

Bluez 5.73 may contain a bug which the service hangs up after hibernation. For the time being, let's use 5.72.

```
sudo pacman -U /var/cache/pacman/pkg/bluez-5.72-2-x86_64.pkg.tar.zst /var/cache/pacman/pkg/bluez-libs-5.72-2-x86_64.pkg.tar.zst /var/cache/pacman/pkg/bluez-utils-5.72-2-x86_64.pkg.tar.zst
```

# Backlight is wrong

If `light` does not work properly, try to modify the kernel parameter:

```
~> cat /boot/loader/entries/arch.conf
options root=UUID=... acpi_backlight=native rw
```

ref: https://bbs.archlinux.org/viewtopic.php?id=282805

# ChatGPT CLI

```
curl -L -o chatgpt https://github.com/kardolus/chatgpt-cli/releases/latest/download/chatgpt-linux-amd64 && chmod +x chatgpt && sudo mv chatgpt /usr/local/bin/
```

# Joplin

```
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
```
