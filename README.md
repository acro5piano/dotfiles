# Backup

The following files are not included in this repository so back up

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
- create new partition (n)
- add boot flag (a)
- write (w)

```sh
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt
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
pacstrap /mnt base base-devel
genfstab -U -p /mnt >> /mnt/etc/fstab

# Enter new arch
arch-chroot /mnt

# Very basic things
pacman -S yay grub iwd

# Configure iwd
cat <<'EOF'| sudo tee /etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true
EOF

# Connect to a Network
iwctl

# Grub
grub-install /dev/sda
grub-mkconfig > /boot/grub/grub.cfg

exit
umount -R /mnt
reboot
```

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
$HOME/.dotfiles/bin/dot link
```

and install packages:

```
bash $HOME/.dotfiles/pkg_init/arch
```

# Mozc settings

```
cd
rm -rf .mozc
git clone git@github.com:acro5piano/mozc.git .mozc
```
