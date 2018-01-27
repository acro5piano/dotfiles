# Install Arch Linux

- Create arch linux install usb.
- Boot to usb and run the following:

### File system

```sh
# partition
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

### pacman

```sh
vim /etc/pacman.d/mirrorlist
```

select mirror.

```sh
vim /etc/pacman.conf
```

add them:

```
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
```

### Install base system

```sh
pacstrap /mnt base base-devel
genfstab -U -p /mnt >> /mnt/etc/fstab

# Enter new arch
arch-chroot /mnt

# Network tools
pacman -Syy
pacman -S grub  wireless_tools wpa_supplicant wpa_actiond dialog
systemctl enable dhcpcd.service

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

# %wheel ALL=(ALL) NOPASSWD: ALL
visudo

# Ubuntu, Debian
gpasswd -a kazuya sudo
apt-get install git curl

# Arch
gpasswd -a kazuya wheel
pacman -S git curl

exit
```

and login as kazuya:

```sh
localhost login> kazuya
password:
```

then run:

```sh
curl -L https://raw.githubusercontent.com/acro5piano/dotfiles/master/install.sh | sh
```
