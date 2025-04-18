#!/bin/bash

# Install brew
if ! command -v brew &>/dev/null; then
    echo "Installing brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing brew packages"
# Declare an array of string with type
declare -a packages=(
    "android-platform-tools"
    "audacity"
    "beyond-compare"
    "boost"
    "cmake"
    "digikam"
    "discord"
    "dupeguru"
    "entityx"
    "gimp"
    "google-chrome"
    "googletest"
    "grammarly"
    "htop"
    "iterm2"
    "jq"
    "llvm"
    "logitech-g-hub"
    "make"
    "moonlight"
    "ninja"
    "nmap"
    "node"
    "nvm"
    "onedrive"
    "openshot-video-editor"
    "pkg-config"
    "pnpm"
    "powerlevel10k"
    "prettier"
    "python"
    "qt"
    "rectangle"
    "sfml"
    "shellcheck"
    "shfmt"
    "spdlog"
    "spotify"
    "tig"
    "tig"
    "visual-studio-code"
    "vlc"
    "wget"
    "whatsapp"
    "yarn"
    "zsh"
)

for package in "${packages[@]}"; do
    isPackageInstalled=$(brew list "$package" 2>/dev/null)
    if [[ ! -z "$isPackageInstalled" ]]; then
        echo -e "\t${package} is already installed"
        continue
    fi
    echo -e "\tinstalling ${package}"
    brew install "$package" >/dev/null
done
