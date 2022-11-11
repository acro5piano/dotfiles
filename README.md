# Dotfiles

acro5piano's personal dotfiles. It aims to automate setup my development PC idempotently.

Core technologies:

- Arch Linux
- i3
- yay
- Ansible

![image](https://user-images.githubusercontent.com/10719495/176838810-ea61f97a-7f7f-4c8b-80f7-243ee8eb8de9.png)

![image](https://user-images.githubusercontent.com/10719495/176839022-bcaf0d70-3395-4b6e-812e-ff676c8294c0.png)

# Setup process

## Install Arch Linux with Windows 10 or 11 multi boot

- Reduce Windows partition and create a blank partition
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

# %wheel ALL=(ALL) ALL
visudo

exit
```

and login as kazuya:

```sh
localhost login> kazuya
password:
```

## Install dotfiles

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
scp -r 192.168.xxx.yyy:/home/kazuya/.aws $HOME/.aws
scp -r 192.168.xxx.yyy:/home/kazuya/.ssh $HOME/.ssh
scp -r 192.168.xxx.yyy:/home/kazuya/var/music $HOME/var
```

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
