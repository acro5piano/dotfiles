# vim:set mode=sh

export PATH="$HOME/bin:$PATH"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"

# Set mime type, or default applications
xdg-settings set default-web-browser browser.desktop
xdg-mime default chromium.desktop text/html
xdg-mime default chromium.desktop x-scheme-handler/http
xdg-mime default chromium.desktop x-scheme-handler/https
xdg-mime default chromium.desktop text/html
xdg-mime default libreoffice.desktop text/csv
xdg-mime default libreoffice.desktop application/docx
xdg-mime default evince.desktop application/pdf
xdg-mime default pcmanfm.desktop inode/directory

# Keyboard repeat frequency
xset r rate 250

# keyboard layout customize
xmodmap $HOME/.xmodmap

# start service async
bash -c 'sleep 2; xremap ~/.xremap 2>&1 > /tmp/xremap.log &' &
fcitx-autostart &
chromium &

exec awesome
