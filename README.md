# Install

Run the following commands as root:

```sh
# add user
useradd --create-home kazuya
passwd kazuya

# %wheel ALL=(ALL) NOPASSWD: ALL
visudo

# Ubuntu, Debian
gpasswd -a kazuya sudo
apt-get install git

# Arch
gpasswd -a kazuya wheel
pacman -S git

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
