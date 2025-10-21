#!/usr/bin/env bash

# Stop on first error
set -e

# --- CONFIGURATION ---
pacman_packages=(
    "hyprland"
    "hyprlock"
    "waybar"
    "ghostty"
    "wofi"
    "dunst"
    "polkit-kde-agent"
    "pipewire"
    "wireplumber"
    "xdg-desktop-portal-hyprland"
    "qt5-wayland"
    "qt6-wayland"
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "ttf-font-awesome"
    "ttf-nerd-fonts-symbols"
    "stow"
    "git"
    "fish"
    "base-devel"
)

aur_packages=(
  
)
# --- END CONFIGURATION ---


# --- HELPER FUNCTIONS ---
install_yay() {
    if ! command -v yay &> /dev/null; then
        echo "yay (AUR helper) not found. Installing..."
        sudo pacman -S --needed base-devel git
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        (cd /tmp/yay && makepkg -si --noconfirm)
        rm -rf /tmp/yay
        echo "yay installed successfully."
    else
        echo "yay is already installed."
    fi
}

# --- MAIN SCRIPT ---
echo "Starting setup..."

# 1. Install Pacman packages
echo "Installing Pacman packages..."
sudo pacman -Syu --needed --noconfirm "${pacman_packages[@]}"

# 2. Install AUR Helper (yay)
install_yay

# 3. Install AUR packages
echo "Installing AUR packages..."
yay -S --needed --noconfirm "${aur_packages[@]}"

# 4. Other setup commands
echo "Running post-install commands..."

# Change default shell to Fish
if [ "$SHELL" != "$FISH_PATH" ]; then
    echo "Changing default shell to Fish for $(whoami)..."
    chsh -s $FISH_PATH
else
    echo "Default shell is already Fish."
fi

# Enable Pipewire
systemctl --user enable --now pipewire.service pipewire.socket pipewire-pulse.service

echo "-----------------------------------"
echo "Setup complete!"
echo "Now, run 'stow *' to link your configs."
echo "Then, reboot your system."
echo "-----------------------------------"
