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
xdg-mime default chromium.desktop video/quicktime
xdg-mime default libreoffice.desktop text/csv
xdg-mime default libreoffice.desktop application/docx
xdg-mime default evince.desktop application/pdf
xdg-mime default pcmanfm.desktop inode/directory

# Keyboard repeat frequency
xset r rate 250

# start service async
# fcitx-autostart &
xremap ~/.xremap 2>&1 > /tmp/xremap.log &
chromium &
start-fcitx &
flameshot &

# keyboard layout customize
xmodmap $HOME/.xmodmap

exec awesome
