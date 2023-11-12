#!/bin/bash

brew tap homebrew/cask

# Declare an array of string with type
declare -a apps=(
    "android-platform-tools"
    "googletest"
    "ninja"
    "nmap"
    "node"
    "pkg-config"
    "pnpm"
    "prettier"
    "python"
    "qt"
    "sfml"
    "yarn"
)

for app in ${apps[@]}; do
    echo "installing ${app}"
    brew install $app >/dev/null
done

declare -a cask_apps=(
    "fig"
    "gimp"
    "logitech-g-hub"
    "rectangle"
    "spotify"
    "whatsapp"
)

for app in ${cask_apps[@]}; do
    echo "installing ${app}"
    brew install --cask $app >/dev/null
done