# Install Arch Linux

Ref: https://qiita.com/j8takagi/items/235e4ae484e8c587ca92

- Create arch linux install usb.
  - download latest iso image
  - `dd if=/path/to/iso of=/dev/sdX`
- Boot to usb and run the following:

## File system (UEFI)

select disk to write arch linux

```sh
gdisk /dev/sda
```

- delete whole partition (d)
  - press (d) until all partitions deleted
- create a new partition (n) and set `+512M` for the partition size
- UEFI boot flag `ef00`
- create a new partition (n)
- write (w)

```sh
# UEFI
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
```

## Install base system

```sh
# Connect to a Network
iwctl

pacstrap /mnt base base-devel linux linux-firmware vi vim iwd
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
mkdir /boot
mount /dev/sda1 /boot
bootctl install

exit
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
$HOME/.dotfiles/bin/dotfiles
```

and install packages:

```
bash $HOME/.dotfiles/pkg_init/arch
```

# Install extra dotfiles

```
rm -rf .ssh
git clone git@github.com:acro5piano/ssh.git $HOME/.ssh

rm -rf .mozc
git clone git@github.com:acro5piano/mozc.git $HOME/.mozc
```

# Copy large & secure files

```
mkdir $HOME/var
scp -r 192.168.xxx.yyy:/home/kazuya/var/music $HOME/var/music
scp -r 192.168.xxx.yyy:/home/kazuya/.aws $HOME/.aws
```

