#!/usr/bin/env bash
#
# setup.sh — اسکریپت نصب سریع پکیج‌ها روی سرور اوبونتوی جدید
#
# استفاده (بعد از آپلود در گیت‌هاب):
#   bash <(curl -sSL https://raw.githubusercontent.com/USERNAME/REPO/main/setup.sh)
#
# یا دانلود و اجرای مستقیم:
#   wget -O setup.sh https://raw.githubusercontent.com/USERNAME/REPO/main/setup.sh
#   bash setup.sh
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
    apt update -y
    apt install -y python3 python3-pip screen
}

install_telegram_bot() {
    echo -e "${CYAN}>> نصب python-telegram-bot${NC}"
    python3 -m pip install python-telegram-bot --break-system-packages
}

install_git_curl_wget() {
    echo -e "${CYAN}>> نصب git, curl, wget${NC}"
    apt install -y git curl wget
}

install_nodejs() {
    echo -e "${CYAN}>> نصب Node.js (LTS)${NC}"
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt install -y nodejs
}

install_docker() {
    echo -e "${CYAN}>> نصب Docker${NC}"
    apt install -y ca-certificates curl gnupg
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt update -y
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

install_requests_lib() {
    echo -e "${CYAN}>> نصب کتابخونه requests${NC}"
    python3 -m pip install requests --break-system-packages
}

# اینجا می‌تونید توابع دلخواه خودتون رو اضافه کنید، مثلاً:
# install_my_bot_deps() {
#     python3 -m pip install some-lib --break-system-packages
# }

# ---------- نصب همه چیز ----------
install_all() {
    install_base
    install_git_curl_wget
    install_telegram_bot
    install_requests_lib
}

# ---------- منو ----------
show_menu() {
    echo ""
    echo -e "${YELLOW}=== منوی نصب سرور ===${NC}"
    echo "1) نصب پایه (python3 + pip + screen)"
    echo "2) نصب git, curl, wget"
    echo "3) نصب python-telegram-bot"
    echo "4) نصب requests"
    echo "5) نصب Node.js"
    echo "6) نصب Docker"
    echo "7) نصب همه‌ی موارد بالا (بدون Node.js و Docker)"
    echo "0) خروج"
    echo ""
    read -rp "شماره گزینه(ها) رو وارد کن (می‌تونی چندتا رو با فاصله بزنی، مثلاً: 1 3 4): " choices

    for choice in $choices; do
        case $choice in
            1) install_base ;;
            2) install_git_curl_wget ;;
            3) install_telegram_bot ;;
            4) install_requests_lib ;;
            5) install_nodejs ;;
            6) install_docker ;;
            7) install_all ;;
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
