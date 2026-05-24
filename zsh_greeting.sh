# Greeting art by Naman Bhotika
#My setup: Arch linux running gnome 50 with zsh.

# --- COLORS (ANSI EXTENDED) ---
CLR_TITLE="\e[38;5;51m"   # Bright Cyan
CLR_LABEL="\e[38;5;141m"  # Soft Purple
CLR_VAL="\e[38;5;253m"    # Off-White
CLR_WARN="\e[38;5;203m"   # Coral/Red
CLR_GOOD="\e[38;5;84m"    # Mint Green
CLR_ACCENT="\e[38;5;214m" # Amber/Orange
CLR_DIM="\e[38;5;242m"    # Muted Gray
CLR_RESET="\e[0m"

#DATA  METRICS 

OS_NAME="Arch Linux"
KERNEL_VERSION=$(uname -r)
UPTIME_RAW=$(uptime -p | sed 's/up //;s/ hours\?/h/;s/ minutes\?/m/' | cut -c1-18)  #shortened to fit borders
SHELL_VERSION="zsh $ZSH_VERSION"

PKG_PACMAN=$(pacman -Q | wc -l)
PKG_FOREIGN=$(pacman -Qm | wc -l) # AUR packages

CPU_MODEL=$(grep -m1 'model name' /proc/cpuinfo | awk -F: '{print $2}' | sed 's/^[ \t]*//;s/  */ /g' | cut -c1-57)
CPU_LOAD=$(uptime | awk -F'load averages?: ' '{print $2}' | awk -F',' '{print $1}' | sed 's/ //g')
CPU_CORES=$(nproc)

if [ -f /proc/meminfo ]; then
    MEM_TOTAL_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    MEM_AVAIL_KB=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    MEM_USED_KB=$((MEM_TOTAL_KB - MEM_AVAIL_KB))
    
    MEM_USED_GB=$(echo "scale=2; $MEM_USED_KB / 1024 / 1024" | bc)
    MEM_TOTAL_GB=$(echo "scale=2; $MEM_TOTAL_KB / 1024 / 1024" | bc)
    MEM_PCT=$(echo "scale=0; ($MEM_USED_KB * 100) / $MEM_TOTAL_KB" | bc)
else
    MEM_PCT=0
    MEMORY_STRING="Unavailable"
fi

DISK_DATA=($(df -h / | tail -n 1 | awk '{print $3, $2, $5}'))
DISK_USED=${DISK_DATA[1]}
DISK_TOTAL=${DISK_DATA[2]}
DISK_PCT_RAW=${DISK_DATA[3]}
DISK_PCT=${DISK_PCT_RAW%\%}

IP_LOCAL=$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'src \K\S+' || echo "Disconnected")

#Rendereing

clear

# Render via Figlet
if command -v figlet &> /dev/null; then
    echo -e "${CLR_TITLE}"
    figlet -f standard "your name"
    echo -e "${CLR_RESET}"
else
    echo -e "${CLR_TITLE}=== your name ===${CLR_RESET}\n"
fi

# Divider Block
echo -e "${CLR_DIM}┌───────────────────────────────────────────────────────────────────────────┐${CLR_RESET}"


print_metric() {
    local label_1=$1 value_1=$2 label_2=$3 value_2=$4
    # Enforces 12 chars for labels, 18 chars for values, exactly mapping the grid
    printf "${CLR_DIM}│${CLR_RESET}  ${CLR_LABEL}%-12.12s${CLR_RESET} : ${CLR_VAL}%-18.18s${CLR_RESET}  ${CLR_DIM}│${CLR_RESET}  ${CLR_LABEL}%-12.12s${CLR_RESET} : ${CLR_VAL}%-18.18s${CLR_RESET}  ${CLR_DIM}│\n${CLR_RESET}" "$label_1" "$value_1" "$label_2" "$value_2"
}

print_metric "OS" "$OS_NAME" "Kernel" "$KERNEL_VERSION"
print_metric "Shell" "$SHELL_VERSION" "Uptime" "$UPTIME_RAW"
print_metric "Pacman Pkgs" "$PKG_PACMAN" "AUR Pkgs" "$PKG_FOREIGN"
print_metric "Local IP" "$IP_LOCAL" "CPU Load" "$CPU_LOAD"

printf "${CLR_DIM}│${CLR_RESET}  ${CLR_LABEL}%-12.12s${CLR_RESET} : ${CLR_DIM}%-57.57s${CLR_RESET} ${CLR_DIM}│\n${CLR_RESET}" "CPU Model" "$CPU_MODEL"
generate_bar() {
    local pct=$1 bar_char="■" dim_char="·" total_blocks=15
    local filled_blocks=$(( pct * total_blocks / 100 ))
    local empty_blocks=$(( total_blocks - filled_blocks ))
    
    local bar=""
    for i in {1..$filled_blocks}; do bar+="$bar_char"; done
    for i in {1..$empty_blocks}; do bar+="$dim_char"; done
    echo "$bar"
}

MEM_BAR=$(generate_bar $MEM_PCT)
DISK_BAR=$(generate_bar $DISK_PCT)

MEM_DISPLAY="${MEM_USED_GB}/${MEM_TOTAL_GB} GB (${MEM_PCT}%)"
DISK_DISPLAY="${DISK_USED}/${DISK_TOTAL} (${DISK_PCT}%)"

printf "${CLR_DIM}│${CLR_RESET}  ${CLR_LABEL}%-12.12s${CLR_RESET} : [${CLR_GOOD}%-15.15s${CLR_RESET}] ${CLR_VAL}%-39.39s${CLR_RESET} ${CLR_DIM}│\n${CLR_RESET}" "Memory" "$MEM_BAR" "$MEM_DISPLAY"
printf "${CLR_DIM}│${CLR_RESET}  ${CLR_LABEL}%-12.12s${CLR_RESET} : [${CLR_ACCENT}%-15.15s${CLR_RESET}] ${CLR_VAL}%-39.39s${CLR_RESET} ${CLR_DIM}│\n${CLR_RESET}" "Storage (/)" "$DISK_BAR" "$DISK_DISPLAY"

echo -e "${CLR_DIM}├───────────────────────────────────────────────────────────────────────────┤${CLR_RESET}"
# User Modifiable Section for notes or quotes or anything tbh
echo -e "${CLR_DIM}│${CLR_RESET}  ${CLR_ACCENT} NOTES or Custom Text:${CLR_RESET}                                  ${CLR_DIM}│${CLR_RESET}"
printf "${CLR_DIM}│${CLR_RESET}  %-72.72s ${CLR_DIM}│\n${CLR_RESET}" "• System Status : Ready for work"
printf "${CLR_DIM}│${CLR_RESET}  %-72.72s ${CLR_DIM}│\n${CLR_RESET}" "• Quote  : wip"
printf "${CLR_DIM}│${CLR_RESET}  %-72.72s ${CLR_DIM}│\n${CLR_RESET}" "• Environment   : Arch + Gnome 50 + zsh"

echo -e "${CLR_DIM}└───────────────────────────────────────────────────────────────────────────┘${CLR_RESET}"
echo ""