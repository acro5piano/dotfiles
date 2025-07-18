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
