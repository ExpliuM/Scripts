#!/bin/bash

# Request sudo access
sudo echo

# Remove before installing
removeList=(
    # Remove before docker install
    "containerd"
    "docker-compose-v2"
    "docker-compose"
    "docker-doc"
    "docker.io"
    "podman-docker"
    "runc"
)

echo "Removing packages:"
for package in "${removeList[@]}"; do
    echo -e "\tRemoving $package package"
    sudo apt-get remove -y $package
    echo -e "\tRemoved $package package"
done

echo "Installing brew packages"
# Declare an array of string with type
installList=(
    "curl"
    "git"
    "htop"
    "openssh-server"
    "vim"
    # "android-platform-tools"
    # "audacity"
    # "beyond-compare"
    # "boost"
    # "cmake"
    # "digikam"
    # "discord"
    # "dupeguru"
    # "entityx"
    # "fig"
    # "gimp"
    # "google-chrome"
    # "googletest"
    # "grammarly"
    # "htop"
    # "logitech-g-hub"
    # "make"
    # "moonlight"
    # "ninja"
    # "nmap"
    # "node"
    # "nvm"
    # "onedrive"
    # "openshot-video-editor"
    # "pkg-config"
    # "pnpm"
    # "powerlevel10k"
    # "prettier"
    # "python"
    # "qt"
    # "rectangle"
    # "sfml"
    # "spdlog"
    # "spotify"
    # "tig"
    # "visual-studio-code"
    # "vlc"
    # "wget"
    # "whatsapp"
    # "yarn"
    # "zsh"
)

for package in "${installList[@]}"; do
    isPackageInstalled=$(brew list $package 2>/dev/null)
    if [[ ! -z "$isPackageInstalled" ]]; then
        echo -e "\t${package} is already installed"
        continue
    fi
    echo -e "\tinstalling ${package}"
    brew install $package >/dev/null
done

# Define an array with the names of the applications you want to install
apps=(
    "curl"
    "vim"
    "git"
    "htop"
)

# Loop through each app in the array
for app in "${apps[@]}"; do
    echo "Installing $app..."
    sudo apt-get install -y "$app"
done

echo "All applications have been installed."

sudo apt-get install vim
sudo vim /etc/ssh/ssh_config
18 sudo apt-get install openssh-server
21 vim /etc/hostname
22 sudo vim /etc/hostname

30 sudo apt install net-tools
33 sudo snap install plexmediaserver
34 wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# nextcloud
sudo docker run --init --sig-proxy=false --name nextcloud-aio-mastercontainer --restart always --publish 80:80 --publish 8080:8080 --publish 8443:8443 --volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config --volume /var/run/docker.sock:/var/run/docker.sock:ro nextcloud/all-in-one:latest

sudo mkdir -p /mnt/downloads
sudo mount -t cifs -o username=explium //alexsander-s-pc/downloads /mnt/downloads/
