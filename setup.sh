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
RED='\033[0;31m'
NC='\033[0m' # No Color

# ============================================================
#  پکیج‌هاتو اینجا تعریف کن — فقط همین یه خط کافیه
#  فرمت هر خط: "اسم نمایشی|دستور نصب"
#  اگه دستور نصب چند خط/چند دستوره، با && بهم وصلشون کن
# ============================================================
PACKAGES=(
    "Base (python3 + pip + screen)|apt update && apt install -y python3 python3-pip screen"
    "python-telegram-bot|python3 -m pip install python-telegram-bot --break-system-packages"
    "pyTelegramBotAPI|python3 -m pip install pyTelegramBotAPI --break-system-packages"
    "flask|python3 -m pip install flask --break-system-packages --ignore-installed blinker"
    "aiosqlite|python3 -m pip install aiosqlite --break-system-packages"
    "aiohttp|python3 -m pip install aiohttp --break-system-packages"
    "telethon + requests|python3 -m pip install telethon requests --break-system-packages"
)
# مثال اضافه کردن پکیج جدید:
# "django|python3 -m pip install django --break-system-packages"
# ============================================================

install_package() {
    local title="$1"
    local cmd="$2"
    echo -e "${CYAN}>> Installing: $title${NC}"
    bash -c "$cmd"
}

install_all() {
    for entry in "${PACKAGES[@]}"; do
        IFS='|' read -r title cmd <<< "$entry"
        install_package "$title" "$cmd"
    done
}

show_menu() {
    echo ""
    echo -e "${YELLOW}=== Server Setup Menu ===${NC}"
    local i=1
    for entry in "${PACKAGES[@]}"; do
        IFS='|' read -r title cmd <<< "$entry"
        echo "$i) $title"
        ((i++))
    done
    echo "$i) Install everything above"
    local all_index=$i
    echo "0) Exit"
    echo ""
    read -rp "Enter option number(s), space-separated (e.g. 1 3 4), or 'all': " choices

    if [[ "$choices" == "all" ]]; then
        install_all
        return
    fi

    for choice in $choices; do
        if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
            echo -e "${RED}Invalid option: $choice${NC}"
            continue
        fi
        if [[ "$choice" == "0" ]]; then
            echo "Exiting."
            exit 0
        elif [[ "$choice" == "$all_index" ]]; then
            install_all
        else
            local index=$((choice - 1))
            if [[ -z "${PACKAGES[$index]}" ]]; then
                echo -e "${RED}Invalid option: $choice${NC}"
                continue
            fi
            IFS='|' read -r title cmd <<< "${PACKAGES[$index]}"
            install_package "$title" "$cmd"
        fi
    done
}

# ---------- Run ----------
# If --all is passed as an argument, install everything without showing the menu
if [[ "$1" == "--all" ]]; then
    install_all
    echo -e "${GREEN}✔ Setup complete.${NC}"
else
    while true; do
        show_menu
        echo -e "${GREEN}✔ Done.${NC}"
    done
fi
