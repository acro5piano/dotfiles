# Dotfiles

acro5piano's personal dotfiles. It aims to automate setup my development PC idempotently.

Core technologies:

- Arch Linux
- i3
- yay
- Ansible

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

## Install Arch Linux with Windows 10 or 11 multi boot

- **On windows**,
  - Reduce Windows partition to minimum 80GB
  - Create a blank partition for Linux
- Create arch linux install usb.
  - download latest iso image
  - `cp /path/to/iso /dev/sdX`
- Boot to usb

### File system (UEFI)

select disk to write arch linux

```sh
cfdisk /dev/nvme0n1
```

- Create a partition for main
  - create a new partition and set maximum size for it
- Create a partition for swap (for hibernation)
  - create a new partition and set `20G` size for it
  - Add swap flag (`8200`)
- write out

```sh
# UEFI
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
mkswap /dev/nvme0n1p3
swapon /dev/nvme0n1p3
mount /dev/nvme0n1p2 /mnt
mkdir /mnt/efi
mount /dev/nvme0n1p1 /mnt/efi
```

### Install base system

```sh
# Connect to a Network
iwctl

pacstrap /mnt base base-devel linux linux-firmware iwd python git neovim os-prober grub
genfstab -U /mnt >> /mnt/etc/fstab

# Enter new arch
arch-chroot /mnt

# Configure iwd
cat <<'EOF'| sudo tee /etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd
EOF

# Connect to a Network
iwctl

# Grub
nvim /etc/default/grub # Enable this line: GRUB_DISABLE_OS_PROBER=false
os-prober
grub-install
grub-mkconfig -o /boot/grub/grub.cfg

exit
reboot
```

Notes:

- Python is required because we use Ansible later.
- If you have any problems on resolving name, edit `/etc/systemd/resolved.conf` and fix dns to `8.8.8.8`.
- Grub is easier than systemd-boot

## Add user

Run the following commands as root:

```sh
# add user
useradd --create-home kazuya
passwd kazuya
gpasswd -a kazuya wheel

visudo /etc/sudoers.d/admin

# Recommended config:
#   %wheel ALL=(ALL) ALL
#   %wheel ALL=NOPASSWD: /bin/systemctl restart iwd
#   %wheel ALL=NOPASSWD: /bin/systemctl restart bluetooth
#   %wheel ALL=NOPASSWD: /bin/systemctl systemctl restart keyd
#   %wheel ALL=NOPASSWD: /home/kazuya/bin/connect-client-vpn

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

## Copy large & secure files

```
mkdir $HOME/var
scp -r 192.168.xxx.yyy:/home/kazuya/var/music $HOME/var/music
scp -r 192.168.xxx.yyy:/home/kazuya/.aws $HOME/.aws
scp -r 192.168.xxx.yyy:/home/kazuya/.ssh $HOME/.ssh
```

## Bluetooth

By default bluetooth connection takes too much time. Here is the fix:

- 1. Edit the file /etc/bluetooth/main.conf
- 1. Uncomment FastConnectable config and set it to true: FastConnectable = true
- 1. Uncomment ReconnectAttempts=7 (set the value to whatever number that you want)
- 1. Uncomment ReconnectIntervals=1, 2, 3

Special Thanks: https://gist.github.com/andrebrait/961cefe730f4a2c41f57911e6195e444#enable-bluetooth-fast-connect-config

# Maintain

```
# Sync dotfiles only
ansible-playbook ansible/main.yml --tags dotfiles

# Install pacman dep only
ansible-playbook --ask-become-pass ansible/main.yml --tags pacman
```

# OSX

```
ansible-playbook ansible/main.yml --tags dotfiles,misc,npm,pip,gem --extra-vars "os=mac"
```

# Linux only (No need Windows)

For Linux only environment, do this on `cfdisk` phase:

- Delete whole partition
- Create a partition for boot
  - create a new partition and set `512M` for the partition size
  - Add UEFI boot flag (`ef00`)

And use this commands for the initial setup, replacing `grub` thing:

```sh
# systemd-boot
mkdir /boot
mount /dev/sda1 /boot
bootctl install
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

# About my keyboard

![image](https://user-images.githubusercontent.com/10719495/224605667-c06a7da0-99e1-414b-8895-cd29130137ab.png)

I use two BLE gridpads as a split keyboard by the power of keyd. keyd has two pitfills:

- 1. KC_BTN1 is not available
- 2. not works outside Linux.

These problems will be fixed by using two ble micro pro controllers as master/slave mode, but it should be difficult at this time. I'll try to implement it in the near future.

### Update BLE Micro Pro config

```bash
cd qmk

# Left hand
sudo make sync-left

# Right hand
sudo make sync-right
```

# Enable hibernation with swapfile

Follow https://www.linuxuprising.com/2021/08/how-to-enable-hibernation-on-ubuntu.html

Create Swap file:

```bash
# Run in root
dd if=/dev/zero of=/swapfile bs=1G count=36 status=progress
chmod 600 /swapfile
mkswap -U clear /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab
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

Get resume physical offset:

```
filefrag -v /swapfile | head

~> sudo filefrag -v /swapfile | head
[sudo] password for kazuya:
Filesystem type is: ef53
File size of /swapfile is 27917287424 (6815744 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..    4095:     446464..    450559:   4096:
   1:     4096..   36863:  109543424.. 109576191:  32768:     450560:
   2:    36864..   69631:  139427840.. 139460607:  32768:  109576192:
   3:    69632..  102399:    8159232..   8191999:  32768:  139460608:
```

Get swap file uuid:

```
~> findmnt -no UUID -T /swapfile

63f7f18e-5a53-4471-9429-e3fc0e2e4666
```

Then modify entry file like this:

```
~> cat /boot/loader/entries/arch.conf

title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=UUID=00000000-1111-2222-3333-444444444444 resume=UUID=63f7f18e-5a53-4471-9429-e3fc0e2e4666 resume_offset=446464 rw
```
