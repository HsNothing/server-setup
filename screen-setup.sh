#!/usr/bin/env bash
#
# run.sh — اجرای پروژه‌ها توی screen با انتخاب از منو
#
# استفاده:
#   bash run.sh
#
# نحوه‌ی کار:
#   لیست پروژه‌ها رو پایین‌تر (قسمت PROJECTS) تعریف کن.
#   هر پروژه سه چیز داره: اسم اسکرین، مسیر (دایرکتوری) و دستور اجرا.
#   وقتی اسکریپت رو اجرا کنی، یه منو نشون داده می‌شه و با زدن عدد
#   همون پروژه توی یه اسکرین جدا اجرا می‌شه، دقیقاً مثل اینکه خودت
#   دستی با «screen -S اسم» رفته باشی تو و دستورات رو تایپ کرده باشی.
#
# ============================================================
#  اینجا پروژه‌هاتو تعریف کن
#  فرمت هر خط: "اسم نمایشی|اسم اسکرین|مسیر دایرکتوری|دستور اجرا"
# ============================================================
PROJECTS=(
    "XLR|XLR|/root/Static/XLR|python3 XLR.py"
    "Bot EL |EL_bot|/root/Dynamic/EL/Customer_EL|python3 bot.py" 
    "Panel EL |EL_panel|/root/Dynamic/EL/Customer_EL|python3 panel.py" 
    "Mini app EL |EL_miniApp|/root/Dynamic/EL/Customer_EL|python3 miniapp.py" 
    "seller EL |EL_seller|/root/Dynamic/EL/Seller_EL|python3 panel.py" 
    "factor |factor|/root/Static/factor|python3 factor.py"
)

# ============================================================
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'
run_project() {
    local title="$1"
    local screen_name="$2"
    local dir="$3"
    local cmd="$4"
    if [[ ! -d "$dir" ]]; then
        echo -e "${RED}✘ Error: path '$dir' not found.${NC}"
        return 1
    fi
    # اگه اسکرین با همین اسم از قبل باز باشه، بهش خبر می‌ده
    if screen -list | grep -q "\.${screen_name}[[:space:]]"; then
        echo -e "${YELLOW}⚠ A screen named '${screen_name}' already exists.${NC}"
        read -rp "Attach to it or cancel? [a=attach / c=cancel]: " ans
        if [[ "$ans" == "a" ]]; then
            screen -r "$screen_name"
        else
            echo "Cancelled."
        fi
        return
    fi
    echo -e "${CYAN}>> Starting \"$title\" in screen '$screen_name'...${NC}"
    echo -e "${CYAN}   Path: $dir${NC}"
    echo -e "${CYAN}   Command: $cmd${NC}"
    # دقیقا مثل روش دستی: اول یه اسکرین خالی می‌سازیم (بدون bash -c دور دستور)
    screen -dmS "$screen_name"
    sleep 0.5
    # حالا دستورات رو انگار داریم خودمون تایپ می‌کنیم داخل همون اسکرین می‌فرستیم
    screen -S "$screen_name" -X stuff "cd '$dir'$(printf \\r)"
    screen -S "$screen_name" -X stuff "$cmd$(printf \\r)"
    sleep 1
    echo -e "${GREEN}✔ Screen '$screen_name' created and the program is running in the background.${NC}"
    echo -e "To attach to it later, run: ${YELLOW}screen -r $screen_name${NC}"
}
show_menu() {
    echo ""
    echo -e "${YELLOW}=== Project Launcher Menu ===${NC}"
    local i=1
    for entry in "${PROJECTS[@]}"; do
        IFS='|' read -r title screen_name dir cmd <<< "$entry"
        echo "$i) $title  (screen: $screen_name)"
        ((i++))
    done
    echo "0) Exit"
    echo ""
    read -rp "Select project number: " choice
    if [[ "$choice" == "0" ]]; then
        echo "Exiting."
        exit 0
    fi
    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Invalid option.${NC}"
        return
    fi
    local index=$((choice - 1))
    if [[ -z "${PROJECTS[$index]}" ]]; then
        echo -e "${RED}Invalid option.${NC}"
        return
    fi
    IFS='|' read -r title screen_name dir cmd <<< "${PROJECTS[$index]}"
    run_project "$title" "$screen_name" "$dir" "$cmd"
}

while true; do
    show_menu
done
