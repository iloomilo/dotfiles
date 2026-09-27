#!/usr/bin/env bash
# ==============================================================================
# Dotfiles & System Setup Script for CachyOS / Arch Linux
# Repos:
#   - Dotfiles:   https://github.com/iloomilo/dotfiles
#   - Quickshell: https://github.com/iloomilo/shell
# ==============================================================================

set -euo pipefail

# ANSI color codes
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RED="\033[1;31m"
RESET="\033[0m"

log_info()    { echo -e "${BLUE}==>${RESET} ${1}"; }
log_success() { echo -e "${GREEN}==>${RESET} ${1}"; }
log_warn()    { echo -e "${YELLOW}==>${RESET} ${1}"; }
log_error()   { echo -e "${RED}==> ERROR:${RESET} ${1}"; }

echo -e "${GREEN}"
echo "  ___ _      ___  __  __ ___ _    ___  "
echo " |_ _| |    / _ \|  \/  |_ _| |  / _ \ "
echo "  | || |   | | | | |\/| || || | | | | |"
echo "  | || |___| |_| | |  | || || |__| |_| |"
echo " |___|_____|\___/|_|  |_|___|_____\___/ "
echo "        Dotfiles & Shell Setup          "
echo -e "${RESET}"

# ------------------------------------------------------------------------------
# 1. Update Mirrors and Install Packages
# ------------------------------------------------------------------------------
log_info "Step 1: Installing system packages..."

PACKAGES=(
    # Core & Dotfile Management
    git
    chezmoi
    matugen
    quickshell
    wl-copy

    # Terminal & Shell
    kitty
    zellij
    fish
    fastfetch
    btop
    neovim

    # Desktop & Services
    awww
    brightnessctl
    playerctl
    cava

    # Applications
    brave-origin-bin
    spotify-launcher
    vesktop
)

# Optional: Rank mirrors if cachyos-rate-mirrors is available
if command -v cachyos-rate-mirrors &>/dev/null; then
    read -rp "Would you like to rank and optimize mirrors first (cachyos-rate-mirrors)? [y/N]: " rate_choice
    if [[ "$rate_choice" =~ ^[yY]$ ]]; then
        log_info "Ranking mirrors..."
        sudo cachyos-rate-mirrors
    fi
fi

log_info "Synchronizing package databases and installing packages..."
sudo pacman -Syu --needed "${PACKAGES[@]}"
log_success "Packages successfully installed."

# ------------------------------------------------------------------------------
# 2. Setup Chezmoi Dotfiles
# ------------------------------------------------------------------------------
log_info "Step 2: Setting up Chezmoi dotfiles..."

DOTFILES_REPO="https://github.com/iloomilo/dotfiles.git"
CHEZMOI_DIR="$HOME/.local/share/chezmoi"

if [ ! -d "$CHEZMOI_DIR/.git" ]; then
    log_info "Initializing chezmoi with $DOTFILES_REPO..."
    chezmoi init --apply "$DOTFILES_REPO"
else
    log_info "Updating existing Chezmoi dotfiles..."
    git -C "$CHEZMOI_DIR" pull
    chezmoi apply
fi
log_success "Dotfiles applied successfully."

# ------------------------------------------------------------------------------
# 3. Setup Quickshell Configuration
# ------------------------------------------------------------------------------
log_info "Step 3: Setting up Quickshell configuration..."

SHELL_REPO="https://github.com/iloomilo/shell.git"
QUICKSHELL_DIR="$HOME/.config/quickshell"

if [ ! -d "$QUICKSHELL_DIR/.git" ]; then
    log_info "Cloning Quickshell repository to $QUICKSHELL_DIR..."
    rm -rf "$QUICKSHELL_DIR"
    git clone "$SHELL_REPO" "$QUICKSHELL_DIR"
else
    log_info "Updating existing Quickshell configuration..."
    git -C "$QUICKSHELL_DIR" pull
fi
log_success "Quickshell configuration is up to date."

# ------------------------------------------------------------------------------
# 4. Install Fonts (Google Sans Flex & Material Symbols)
# ------------------------------------------------------------------------------
log_info "Step 4: Installing fonts for UI and icons..."

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Copy Google Sans Flex from Quickshell assets
if [ -f "$QUICKSHELL_DIR/assets/fonts/GoogleSansFlex.ttf" ]; then
    cp -u "$QUICKSHELL_DIR/assets/fonts/GoogleSansFlex.ttf" "$FONT_DIR/"
    log_info "Google Sans Flex registered."
fi

# Material Symbols Rounded (Variable font for ligature icons)
MATERIAL_FONT_URL="https://github.com/google/material-design-icons/raw/master/variablefont/MaterialSymbolsRounded%5BFILL%2CGRAD%2Copsz%2Cwght%5D.ttf"
if [ ! -f "$FONT_DIR/MaterialSymbolsRounded.ttf" ]; then
    log_info "Downloading Material Symbols Rounded font..."
    curl -fLo "$FONT_DIR/MaterialSymbolsRounded.ttf" "$MATERIAL_FONT_URL"
    log_info "Material Symbols Rounded downloaded."
fi

# Refresh font cache
log_info "Refreshing font cache (fc-cache)..."
fc-cache -f "$FONT_DIR"
log_success "Fonts configured successfully."

# ------------------------------------------------------------------------------
# 5. Initial Theme Generation (Matugen)
# ------------------------------------------------------------------------------
log_info "Step 5: Generating initial theme with Matugen..."

if command -v matugen &>/dev/null; then
    matugen color hex '#5a376b' || true
    log_success "Color templates generated for Quickshell, Niri, Zellij, and Kitty."
else
    log_warn "Matugen not found, skipping initial theme generation."
fi

# ------------------------------------------------------------------------------
# Completion
# ------------------------------------------------------------------------------
echo ""
log_success "Setup completed successfully!"
echo -e "${YELLOW}Tip:${RESET} You can now start Quickshell with 'quickshell -d' or log back into your session."
