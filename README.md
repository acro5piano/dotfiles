# Dotfiles

acro5piano's personal dotfiles. It aims to automate setup my development PC idempotently.

Core technologies:

- Arch Linux
- Sway
- Neovim
- Alacritty
- keyd/Xremap
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
  - create a new partition and set `1G` size for it
  - Set the type to `EFI System`
- Create a partition for swap (for hibernation) `/dev/nvme0n1p2`
  - create a new partition and set `40G` size for it (I have 24GB machine)
  - Set the type to `Linux swap`
- Create a partition for main `/dev/nvme0n1p3`
  - create a new partition and set maximum size for it
  - Set the type to `Linux Filesystem`
- write out

Swap is required for hibernation.

![image](https://github.com/user-attachments/assets/9a2e3df2-d1c4-43ce-b94f-a3535c473800)

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

pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware iwd git vim
genfstab -U /mnt >> /mnt/etc/fstab

# Enter new arch
arch-chroot /mnt

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
#   %wheel ALL=NOPASSWD: /bin/systemctl suspend
#   %wheel ALL=NOPASSWD: /bin/systemctl hibernate
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
./bin/apply-etc.sh
./bin/apply-aur.sh
./bin/apply-nix.sh
```

For groups, please take a look at:

https://github.com//acro5piano/dotfiles/blob/e0ef379e4326bd102abddc28bd5946b52cbeee06/pkg_init/arch#L1

## Bluetooth

By default bluetooth connection takes too much time. Here is the fix: https://gist.github.com/andrebrait/961cefe730f4a2c41f57911e6195e444#enable-bluetooth-fast-connect-config

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

# pnpm completion

Not works. use Yarn completion for now.

```
pnpm completion fish > ~/.config/fish/completions/pnpm.fish
```

# Disable Logi Bold wakeup from sleep

/etc/udev/rules.d/99-logibolt-power.rules

```
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c548", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"
```

# Sync GoPro photo and video

```
cd var/gopro
sudo mount -o uid=1000,gid=1000 /dev/mmcblk0p1 /mnt
cp /mnt/DCIM/100GOPRO/*.{THM,LRV} .
```
