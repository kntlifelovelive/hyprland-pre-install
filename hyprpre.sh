#!/bin/bash

# Colors
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# ==============================
# Default options
SHOW_ESTIMATE=true
SAVE_LOG=true
LOG_FILE="$HOME/hyprland_install.log"
# ==============================

echo -e "${YELLOW}[*] Arch + Hyprland Setup (Yay only) starting...${RESET}"

# Remove pacman lock if exists
if [ -f /var/lib/pacman/db.lck ]; then
    echo -e "${RED}[!] Removing pacman lock file...${RESET}"
    sudo rm /var/lib/pacman/db.lck
fi

# Step 0: Show download estimate
if [ "$SHOW_ESTIMATE" = true ]; then
    ESTIMATE_MB=1700
    DISK_USAGE_ESTIMATE_MB=4000
    echo -e "${YELLOW}[*] Rough Estimate before install:${RESET}"
    echo -e "  Yay packages download   : ~${ESTIMATE_MB} MB"
    echo -e "  Estimated disk usage    : ~${DISK_USAGE_ESTIMATE_MB} MB\n"
fi

# Step 1: System update
echo -e "${YELLOW}[1/3] System update...${RESET}"
if [ "$SAVE_LOG" = true ]; then
    sudo pacman -Syu --noconfirm | tee -a "$LOG_FILE"
else
    sudo pacman -Syu --noconfirm
fi

# Step 2: Yay install check
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}[2/3] Installing yay...${RESET}"
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    echo -e "${GREEN}[✓] yay already installed${RESET}"
fi

# Step 3: Install all packages via yay
YAY_PACKAGES=(
    waybar wofi swaybg swaylock grim slurp wl-clipboard xdg-desktop-portal-hyprland polkit-kde-agent
    ttf-jetbrains-mono-nerd ttf-font-awesome ttf-nerd-fonts-symbols papirus-icon-theme nwg-look lxappearance
    pipewire pipewire-alsa pipewire-pulse wireplumber pavucontrol
    neovim kitty thunar file-roller btop unzip zip gvfs gvfs-mtp fastfetch
    gum
    bibata-cursor-theme-bin ttf-material-design-icons ttf-ms-fonts ttf-ubuntu-font-family ttf-google-sans
    nordic-theme catppuccin-gtk-theme-mocha catppuccin-cursors-mocha sddm-theme-catppuccin
    pamixer brightnessctl pavucontrol-qt nerd-fonts-ubuntu-mono nerd-fonts-fira-code grimblast swww
    nwg-displays nwg-drawer nwg-panel nwg-shell
)

echo -e "${YELLOW}[3/3] Installing packages with yay...${RESET}"
if [ "$SAVE_LOG" = true ]; then
    yay -S --noconfirm --needed "${YAY_PACKAGES[@]}" | tee -a "$LOG_FILE"
else
    yay -S --noconfirm --needed "${YAY_PACKAGES[@]}"
fi

echo -e "${GREEN}[✓] Arch + Hyprland Setup (Yay only) finished${RESET}"
if [ "$SAVE_LOG" = true ]; then
    echo -e "${YELLOW}[*] Installation log saved to $LOG_FILE${RESET}"
fi
