#!/bin/bash
if [[ $EUID -ne 0 ]]; then
  echo -e "MUST RUN AS ROOT USER! use sudo"
  exit 1
fi
#update system
sudo yum update && sudo yum upgrade -y
#open ports
sudo iptables -A INPUT -p udp -m udp --dport 1:65535 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 1:65535 -j ACCEPT
sudo iptables -A OUTPUT -p udp -m udp --dport 1:65535 -j ACCEPT
sudo iptables -A OUTPUT -p tcp -m tcp --dport 1:65535 -j ACCEPT
# echo
echo "All ports open sucsesfully"
#dnf modify
echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf
echo "Modificate dnf..."
sudo dnf -y upgrade --refresh
#enable rpm fusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf upgrade --refresh
sudo dnf groupupdate core
sudo dnf install -y rpmfusion-free-release-tainted
sudo dnf install -y rpmfusion-nonfree-release-tainted 
sudo dnf install -y dnf-plugins-core
sudo dnf install -y *-firmware 
echo "rpm fusion on"
#flatpack activate
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update
echo "flatpack on"
#snapd activate
sudo dnf install -y snapd
sudo ln -s /var/lib/snapd/snap /snap # for classic snap support
echo "snapd on"
#programs install
sudo dnf install -y libdvdcss 
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,ugly-\*,base} gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg
sudo dnf install -y lame\* --exclude=lame-devel 
sudo dnf -y groupupdate sound-and-video
sudo dnf config-manager --set-enabled fedora-cisco-openh264
sudo dnf install -y gstreamer1-plugin-openh264 mozilla-openh264
sudo dnf group upgrade --with-optional Multimedia
sudo dnf install -y geary
sudo dnf install -y gnome-tweak-tool 
sudo dnf install -y vlc 
sudo dnf -y install unzip p7zip p7zip-plugins unrar 
sudo dnf -y install gimp
sudo dnf -y install qbittorrent 
sudo dnf config-manager --add-repo=https://negativo17.org/repos/fedora-spotify.repo  
sudo dnf -y install spotify-client 
sudo dnf -y install dropbox nautilus-dropbox 
sudo dnf -y install audacity 
sudo dnf -y install obs-studio
sudo dnf -y install gparted
sudo dnf install fedora-workstation-repositories
echo "apps installed!"
#fonts Pop-OS
sudo dnf install -y fira-code-fonts 'mozilla-fira*' 'google-roboto*'
echo "fonts installed!"
echo "done!"
