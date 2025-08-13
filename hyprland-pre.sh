#!/bin/bash

# Colors
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# ==============================
# Default options
SHOW_ESTIMATE=true
INSTALL_AUR=true
RUN_HYDE=true
SAVE_LOG=true
LOG_FILE="$HOME/hyde_install.log"
# ==============================

echo -e "${YELLOW}[*] Arch + Hyprland + HyDe Full Setup (Option-Controlled) စတင်နေပါတယ်...${RESET}"

# Step 0: Show download estimate
if [ "$SHOW_ESTIMATE" = true ]; then
    PACMAN_ESTIMATE_MB=1000
    AUR_ESTIMATE_MB=700
    TOTAL_ESTIMATE_MB=$((PACMAN_ESTIMATE_MB + AUR_ESTIMATE_MB))
    DISK_USAGE_ESTIMATE_MB=4000
    echo -e "${YELLOW}[*] Rough Estimate before install:${RESET}"
    echo -e "  Pacman packages download: ~${PACMAN_ESTIMATE_MB} MB"
    echo -e "  AUR packages download   : ~${AUR_ESTIMATE_MB} MB"
    echo -e "  Total download          : ~${TOTAL_ESTIMATE_MB} MB"
    echo -e "  Estimated disk usage    : ~${DISK_USAGE_ESTIMATE_MB} MB\n"
fi

# Step 1: System update
echo -e "${YELLOW}[1/5] System update လုပ်နေပါတယ်...${RESET}"
if [ "$SAVE_LOG" = true ]; then
    sudo pacman -Syu --noconfirm | tee -a "$LOG_FILE"
else
    sudo pacman -Syu --noconfirm
fi

# Step 2: Yay install check
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}[2/5] yay မရှိသေးလို့ တင်နေပါတယ်...${RESET}"
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    echo -e "${GREEN}[✓] yay ရှိပြီးသားပါ${RESET}"
fi

# Step 3: Pacman dependencies
PACMAN_PACKAGES=(
    waybar wofi swaybg swaylock grim slurp wl-clipboard xdg-desktop-portal-hyprland polkit-kde-agent
    ttf-jetbrains-mono-nerd ttf-font-awesome ttf-nerd-fonts-symbols papirus-icon-theme nwg-look lxappearance
    pipewire pipewire-alsa pipewire-pulse wireplumber pavucontrol
    neovim kitty thunar file-roller btop unzip zip gvfs gvfs-mtp fastfetch
)

echo -e "${YELLOW}[3/5] Pacman dependencies တင်နေပါတယ်...${RESET}"
if [ "$SAVE_LOG" = true ]; then
    sudo pacman -S --noconfirm --needed "${PACMAN_PACKAGES[@]}" | tee -a "$LOG_FILE"
else
    sudo pacman -S --noconfirm --needed "${PACMAN_PACKAGES[@]}"
fi

# Step 4: AUR dependencies
AUR_PACKAGES=(
    bibata-cursor-theme-bin ttf-material-design-icons ttf-ms-fonts ttf-ubuntu-font-family ttf-google-sans
    nordic-theme catppuccin-gtk-theme-mocha catppuccin-cursors-mocha sddm-theme-catppuccin
    pamixer brightnessctl pavucontrol-qt nerd-fonts-ubuntu-mono nerd-fonts-fira-code grimblast swww
    nwg-displays nwg-drawer nwg-panel nwg-shell
)

if [ "$INSTALL_AUR" = true ]; then
    echo -e "${YELLOW}[4/5] AUR dependencies တင်နေပါတယ်...${RESET}"
    if [ "$SAVE_LOG" = true ]; then
        yay -S --noconfirm --needed "${AUR_PACKAGES[@]}" | tee -a "$LOG_FILE"
    else
        yay -S --noconfirm --needed "${AUR_PACKAGES[@]}"
    fi
else
    echo -e "${YELLOW}[4/5] AUR installation ကို skip လုပ်ထားပါတယ်${RESET}"
fi

# Step 5: HyDe install
if [ "$RUN_HYDE" = true ]; then
    echo -e "${YELLOW}[5/5] HyDe installer ဆွဲပြီး Run လုပ်နေပါတယ်...${RESET}"
    git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE
    cd ~/HyDE/Scripts || exit
    if [ "$SAVE_LOG" = true ]; then
        ./install.sh | tee -a "$LOG_FILE"
    else
        ./install.sh
    fi
else
    echo -e "${YELLOW}[5/5] HyDe installer run ကို skip လုပ်ထားပါတယ်${RESET}"
fi

echo -e "${GREEN}[✓] Arch + Hyprland + HyDe Setup အဆင်ပြေပြီးပါပြီ 😘${RESET}"
if [ "$SAVE_LOG" = true ]; then
    echo -e "${YELLOW}[*] Installation log ကို $LOG_FILE မှာ သိမ်းထားပြီးပါပြီ${RESET}"
fi
