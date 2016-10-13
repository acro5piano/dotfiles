export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gtk/IMModule':<'fcitx'>}"

fcitx-autostart

# Set mime type

xdg-mime default chromium.desktop text/html
xdg-mime default libreoffice text/csv

xdg-mime default chromium.desktop x-scheme-handler/http
xdg-mime default chromium.desktop x-scheme-handler/https
xdg-mime default evince.desktop application/pdf

xdg-settings set default-web-browser browser.desktop

exec openbox-session
