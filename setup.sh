#!/usr/bin/env bash
#
# setup.sh — Quick package installer for a fresh Ubuntu server
#
# Usage (after uploading to GitHub):
#   bash <(curl -sSL https://raw.githubusercontent.com/HsNothing/server-setup/main/setup.sh)
#
set -e

# ---------- Colors for better display ----------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ---------- Install functions ----------
install_base() {
    echo -e "${CYAN}>> Installing base: python3, pip, screen${NC}"
    apt update
    apt install -y python3 python3-pip screen
}

install_telegram_bot() {
    echo -e "${CYAN}>> Installing python-telegram-bot${NC}"
    python3 -m pip install python-telegram-bot --break-system-packages
}

install_pytelegrambotapi() {
    echo -e "${CYAN}>> Installing pyTelegramBotAPI${NC}"
    python3 -m pip install pyTelegramBotAPI --break-system-packages
}

install_flask() {
    echo -e "${CYAN}>> Installing flask${NC}"
    python3 -m pip install flask --break-system-packages --ignore-installed blinker
}

install_aiosqlite() {
    echo -e "${CYAN}>> Installing aiosqlite${NC}"
    python3 -m pip install aiosqlite --break-system-packages
}

install_aiohttp() {
    echo -e "${CYAN}>> Installing aiohttp${NC}"
    python3 -m pip install aiohttp --break-system-packages
}

install_telethon() {
    echo -e "${CYAN}>> Installing telethon and requests${NC}"
    python3 -m pip install telethon requests --break-system-packages
}

# ---------- Install everything ----------
install_all() {
    install_base
    install_telegram_bot
    install_pytelegrambotapi
    install_flask
    install_aiosqlite
    install_aiohttp
    install_telethon
}

# ---------- Menu ----------
show_menu() {
    echo ""
    echo -e "${YELLOW}=== Server Setup Menu ===${NC}"
    echo "1) Base install (python3 + pip + screen)"
    echo "2) Install python-telegram-bot"
    echo "3) Install pyTelegramBotAPI"
    echo "4) Install flask"
    echo "5) Install aiosqlite"
    echo "6) Install aiohttp"
    echo "7) Install telethon + requests"
    echo "8) Install everything above"
    echo "0) Exit"
    echo ""
    read -rp "Enter option number(s), space-separated (e.g. 1 3 4): " choices
    for choice in $choices; do
        case $choice in
            1) install_base ;;
            2) install_telegram_bot ;;
            3) install_pytelegrambotapi ;;
            4) install_flask ;;
            5) install_aiosqlite ;;
            6) install_aiohttp ;;
            7) install_telethon ;;
            8) install_all ;;
            0) echo "Exiting."; exit 0 ;;
            *) echo -e "${YELLOW}Invalid option: $choice${NC}" ;;
        esac
    done
}

# ---------- Run ----------
# If --all is passed as an argument, install everything without showing the menu
if [[ "$1" == "--all" ]]; then
    install_all
else
    show_menu
fi

echo -e "${GREEN}✔ Setup complete.${NC}"
