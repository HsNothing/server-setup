#!/usr/bin/env bash
#
# setup.sh — اسکریپت نصب سریع پکیج‌ها روی سرور اوبونتوی جدید
#
# استفاده (بعد از آپلود در گیت‌هاب):
#   bash <(curl -sSL https://raw.githubusercontent.com/HsNothing/server-setup/main/setup.sh)
#
set -e

# ---------- رنگ‌ها برای نمایش بهتر ----------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ---------- توابع نصب هر بخش ----------

install_base() {
    echo -e "${CYAN}>> نصب پایه: python3, pip, screen${NC}"
    apt update
    apt install -y python3 python3-pip screen
}

install_telegram_bot() {
    echo -e "${CYAN}>> نصب python-telegram-bot${NC}"
    python3 -m pip install python-telegram-bot --break-system-packages
}

install_pytelegrambotapi() {
    echo -e "${CYAN}>> نصب pyTelegramBotAPI${NC}"
    python3 -m pip install pyTelegramBotAPI --break-system-packages
}

install_flask() {
    echo -e "${CYAN}>> نصب flask${NC}"
    python3 -m pip install flask --break-system-packages --ignore-installed blinker
}

install_aiosqlite() {
    echo -e "${CYAN}>> نصب aiosqlite${NC}"
    python3 -m pip install aiosqlite --break-system-packages
}

install_aiohttp() {
    echo -e "${CYAN}>> نصب aiohttp${NC}"
    python3 -m pip install aiohttp --break-system-packages
}

install_telethon() {
    echo -e "${CYAN}>> نصب telethon و requests${NC}"
    python3 -m pip install telethon requests --break-system-packages
}

# ---------- نصب همه چیز ----------
install_all() {
    install_base
    install_telegram_bot
    install_pytelegrambotapi
    install_flask
    install_aiosqlite
    install_aiohttp
    install_telethon
}

# ---------- منو ----------
show_menu() {
    echo ""
    echo -e "${YELLOW}=== منوی نصب سرور ===${NC}"
    echo "1) نصب پایه (python3 + pip + screen)"
    echo "2) نصب python-telegram-bot"
    echo "3) نصب pyTelegramBotAPI"
    echo "4) نصب flask"
    echo "5) نصب aiosqlite"
    echo "6) نصب aiohttp"
    echo "7) نصب telethon + requests"
    echo "8) نصب همه‌ی موارد بالا"
    echo "0) خروج"
    echo ""
    read -rp "شماره گزینه(ها) رو وارد کن (می‌تونی چندتا رو با فاصله بزنی، مثلاً: 1 3 4): " choices

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
            0) echo "خروج."; exit 0 ;;
            *) echo -e "${YELLOW}گزینه‌ی نامعتبر: $choice${NC}" ;;
        esac
    done
}

# ---------- اجرا ----------
# اگر آرگومان --all داده بشه، بدون منو همه چیز نصب می‌شه
if [[ "$1" == "--all" ]]; then
    install_all
else
    show_menu
fi

echo -e "${GREEN}✔ عملیات نصب تمام شد.${NC}"
