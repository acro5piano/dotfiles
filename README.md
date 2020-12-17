# Backup

The following files are not included in this repository so back up

- ~/.mozc
- ~/.ssh
- ~/.aws
- ~/var

```
sudo mount /dev/sdb1 /mnt
mkdir /mnt/backup/thinkpad-x240/$(now)
cat | xargs -i cp -r {} /mnt/backup/thinkpad-x240/$(now)

# Then paste backup file list
```

# Install Arch Linux

- Create arch linux install usb.
  - download latest iso image
  - `dd if=/path/to/iso of=/dev/sdX`
- Boot to usb and run the following:

## File system

select disk to write arch linux

```sh
fdisk /dev/sda
```

- delete whole partition (d)
  - press (d) until all partitions deleted
- If you use Legacy MBR boot:
  - create a new partition (n)
  - add boot flag (a)
- else if you use UEFI boot:
  - create a new partition (n) and set `+512M` for the partition size
  - UEFI boot flag using (t) and `1`
  - create a new partition (n)
- write (w)

```sh
# Legacy boot
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt

# UEFI
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
```

## pacman and yaourt

TODO: move this section into `yay`.

```sh
vim /etc/pacman.d/mirrorlist
```

select mirror.

```sh
vim /etc/pacman.conf
```

add them:

```
# comment in multilib
[multilib]
Include = /etc/pacman.d/mirrorlist

[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
```

## Install base system

```sh
# Connect to a Network
iwctl

# FSTab
pacstrap /mnt base base-devel linux linux-firmware vi vim iwd
genfstab -U /mnt >> /mnt/etc/fstab

# Enter new arch
arch-chroot /mnt

# Very basic things
# pacman -S yay

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
mkdir /boot
mount /dev/sda1 /boot
bootctl install

exit
umount -R /mnt
reboot
```

If you have any problems on resolving name, edit `/etc/systemd/resolved.conf` and fix dns to `8.8.8.8`.

# Install dotfiles

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

then install dotfiles:

```sh
cd ~
git clone git@github.com:/acro5piano/dotfiles $HOME/.dotfiles
$HOME/.dotfiles/bin/dotfiles link
```

and install packages:

```
bash $HOME/.dotfiles/pkg_init/arch
```

# Install extra dotfiles

```
rm -rf .ssh
git clone https://github.com/acro5piano/ssh.git $HOME/.ssh

rm -rf .mozc
git clone git@github.com:acro5piano/mozc.git $HOME/.mozc
```
