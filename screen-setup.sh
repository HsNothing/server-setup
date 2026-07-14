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
#   همون پروژه توی یه اسکرین جدا اجرا می‌شه و بعد خودش برمی‌گرده به ترمینال.
#

# ============================================================
#  اینجا پروژه‌هاتو تعریف کن
#  فرمت هر خط: "اسم نمایشی|اسم اسکرین|مسیر دایرکتوری|دستور اجرا"
# ============================================================
PROJECTS=(
    "ربات|bot|/root/bot|python3 main.py"
    "پنل|panel|/root/panel|python3 app.py"
)
# مثال بیشتر:
# "بک‌آپ گیر|backup|/root/backup|python3 backup.py"
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
        echo -e "${RED}✘ خطا: مسیر '$dir' پیدا نشد.${NC}"
        return 1
    fi

    # اگه اسکرین با همین اسم از قبل باز باشه، بهش خبر می‌ده
    if screen -list | grep -q "\.${screen_name}[[:space:]]"; then
        echo -e "${YELLOW}⚠ یه اسکرین با اسم '${screen_name}' از قبل وجود داره.${NC}"
        read -rp "می‌خوای بهش وصل بشی (attach) یا لغو کنی؟ [a=attach / c=cancel]: " ans
        if [[ "$ans" == "a" ]]; then
            screen -r "$screen_name"
        else
            echo "لغو شد."
        fi
        return
    fi

    echo -e "${CYAN}>> در حال اجرای «$title» توی اسکرین '$screen_name'...${NC}"
    echo -e "${CYAN}   مسیر: $dir${NC}"
    echo -e "${CYAN}   دستور: $cmd${NC}"

    # ساخت اسکرین جدید در حالت detached و اجرای دستور توش
    screen -dmS "$screen_name" bash -c "cd '$dir' && $cmd; exec bash"

    sleep 1
    echo -e "${GREEN}✔ اسکرین '$screen_name' ساخته شد و برنامه در پس‌زمینه اجرا شد.${NC}"
    echo -e "برای وصل شدن به اون بعداً بزن: ${YELLOW}screen -r $screen_name${NC}"
}

show_menu() {
    echo ""
    echo -e "${YELLOW}=== منوی اجرای پروژه‌ها ===${NC}"
    local i=1
    for entry in "${PROJECTS[@]}"; do
        IFS='|' read -r title screen_name dir cmd <<< "$entry"
        echo "$i) $title  (screen: $screen_name)"
        ((i++))
    done
    echo "0) خروج"
    echo ""
    read -rp "شماره پروژه رو انتخاب کن: " choice

    if [[ "$choice" == "0" ]]; then
        echo "خروج."
        exit 0
    fi

    local index=$((choice - 1))
    if [[ -z "${PROJECTS[$index]}" ]]; then
        echo -e "${RED}گزینه‌ی نامعتبر.${NC}"
        return
    fi

    IFS='|' read -r title screen_name dir cmd <<< "${PROJECTS[$index]}"
    run_project "$title" "$screen_name" "$dir" "$cmd"
}

show_menu
