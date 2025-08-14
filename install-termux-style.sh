#!/bin/bash

# Warna teks
green="\033[32m"
cyan="\033[36m"
yellow="\033[33m"
red="\033[31m"
reset="\033[0m"

clear
echo -e "${cyan}"
figlet "Termux Style" | lolcat
echo -e "${reset}"
sleep 1

# Loading animasi
echo -ne "${yellow}Menginstall paket"
for i in {1..5}; do
    echo -n "."
    sleep 0.3
done
echo -e "${reset}"

# Instal paket
pkg update -y
pkg install sox figlet lolcat -y

# Tanya nama
echo -ne "${cyan}Masukkan nama untuk prompt: ${reset}"
read USERNAME

# Cek musik
if [ ! -f "$HOME/startup.mp3" ]; then
    cp "$HOME/husarski-cyberwave-172902.mp3" "$HOME/startup.mp3" 2>/dev/null || {
        echo -e "${red}File musik tidak ditemukan!${reset}"
        exit 1
    }
fi

# Backup .bashrc
cp "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%s)"

# Tulis .bashrc baru
cat <<EOT > "$HOME/.bashrc"
trap "pkill -f 'play \$HOME/startup.mp3'" EXIT

play "\$HOME/startup.mp3" gain 3 repeat 999 > /dev/null 2>&1 &

clear
figlet "Welcome" | lolcat
echo -e "\\n"

PS1="~ ☠️${USERNAME}☠️ "
EOT

# Pesan sukses
echo -e "${green}"
figlet "Sukses!" | lolcat
echo -e "${reset}Tutup dan buka lagi Termux untuk melihat hasilnya."
