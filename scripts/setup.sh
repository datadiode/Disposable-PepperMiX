#!/bin/bash

# Add 32-bit archictecture
dpkg --add-architecture i386 && apt-get update

# Add essential packages
apt-get install -y crudini cabextract p7zip-full xvfb cpu-x systemd-sysv devilspie2

# Disable automatic updates
if [[ "$(lsb_release -si)" == "Sparky" ]]; then
  apt-get remove -y sparky-aptus-upgrade-checker
fi

# https://www.dropvps.com/blog/install-wine-on-debian-13/
apt-get install -y wget ca-certificates
mkdir -pm755 /etc/apt/keyrings
wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources
apt-get update

# Get fix for https://github.com/Winetricks/winetricks/issues/2344
wget -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/00427b67de70bfefd282d0abc7edd1daa442e73e/src/winetricks
chmod +x /usr/bin/winetricks

# Enable auto login
if $AUTO_LOGIN; then
  crudini --set /etc/lightdm/lightdm.conf "Seat:*" autologin-user vagrant
  crudini --set /etc/lightdm/lightdm.conf "Seat:*" autologin-user-timeout 0
fi

# Disable session saving
mkdir /etc/xdg/xfce4/kiosk
crudini --set /etc/xdg/xfce4/kiosk/kioskrc "xfce4-session" SaveSession NONE

# Disable user-dirs update prompt
crudini --set /etc/xdg/autostart/user-dirs-update-gtk.desktop "Desktop Entry" Hidden true

# On seven-sisters, use files for trixie if such exist
if [[ "$(lsb_release -si)" == "Sparky" ]]; then
  ln -s /home/vagrant/files/trixie /home/vagrant/files/seven-sisters
  ln -s /home/vagrant/files/trixie /home/vagrant/files/tiamat
fi

exit 0
