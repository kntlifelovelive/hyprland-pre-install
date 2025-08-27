#!/bin/bash
# ArchRiot Hyprland Manual Install Script
# Made with ❤️ for you, ကိုရေ

# Exit if error occurs
set -e

echo ">>> Updating system..."
sudo pacman -Syyu --noconfirm

echo ">>> Installing base & build tools..."
sudo pacman -S --needed --noconfirm base base-devel git curl wget

echo ">>> Installing display server & drivers..."
sudo pacman -S --needed --noconfirm \
    xorg-xwayland wlroots wayland wayland-protocols mesa vulkan-icd-loader

echo ">>> Installing Hyprland..."
sudo pacman -S --needed --noconfirm hyprland

echo ">>> Installing Hyprland helper tools..."
sudo pacman -S --needed --noconfirm \
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
    xdg-desktop-portal xdg-utils

echo ">>> Installing bar & widgets..."
sudo pacman -S --needed --noconfirm waybar

echo ">>> Installing wallpaper daemon..."
sudo pacman -S --needed --noconfirm swww

echo ">>> Installing app launcher..."
sudo pacman -S --needed --noconfirm rofi-wayland

echo ">>> Installing clipboard manager..."
sudo pacman -S --needed --noconfirm cliphist wl-clipboard

echo ">>> Installing notification daemon..."
sudo pacman -S --needed --noconfirm mako

echo ">>> Installing file manager & terminal..."
sudo pacman -S --needed --noconfirm thunar kitty

echo ">>> Installing polkit (authentication agent)..."
sudo pacman -S --needed --noconfirm polkit-gnome

echo ">>> Installing audio (pipewire)..."
sudo pacman -S --needed --noconfirm \
    pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber

echo ">>> Installing fonts..."
sudo pacman -S --needed --noconfirm ttf-jetbrains-mono ttf-dejavu noto-fonts

echo ">>> All packages installed successfully ✅"
echo ""
echo "➡️  Now, you can run Hyprland by adding 'exec Hyprland' to your ~/.xinitrc"
echo "➡️  Or install a login manager like gdm/sddm/lightdm to start Hyprland at boot."
