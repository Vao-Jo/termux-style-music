#!/bin/bash
# Termux Style + Music Installer
# By Vao-Jo

clear
echo -e "\033[1;36m"
echo "████████╗███████╗██████╗ ███╗   ███╗██╗   ██╗██╗  ██╗"
echo "╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║██║ ██╔╝"
echo "   ██║   █████╗  ██████╔╝██╔████╔██║██║   ██║█████╔╝ "
echo "   ██║   ██╔══╝  ██╔═══╝ ██║╚██╔╝██║██║   ██║██╔═██╗ "
echo "   ██║   ███████╗██║     ██║ ╚═╝ ██║╚██████╔╝██║  ██╗"
echo "   ╚═╝   ╚══════╝╚═╝     ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝"
echo -e "\033[0m"

# Animasi loading
loading() {
    echo -ne "\033[1;33mMenginstall paket"
    for i in {1..5}; do
        echo -n "."
        sleep 0.4
    done
    echo -e "\033[0m"
}

# Install paket
loading
pkg update -y && pkg upgrade -y
pkg install figlet -y
pkg install mpv -y
pkg install ruby -y
pkg install curl -y
gem install lolcat

# Buat musik startup
mkdir -p ~/termux-style
curl -L -o ~/termux-style/startup.mp3 https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3

# Minta nama user
echo -ne "\033[1;32mMasukkan nama untuk prompt: \033[0m"
read username
if [ -z "$username" ]; then
    echo "Nama tidak boleh kosong!"
    exit 1
fi

# Edit .bashrc
cat <<EOL > ~/.bashrc
# Musik startup
mpv --really-quiet ~/termux-style/startup.mp3 &
trap 'killall mpv 2>/dev/null' EXIT

# Banner
clear
figlet "Welcome" | lolcat

# Prompt custom
PS1="~ ☠️${username}☠️ "
EOL

clear
figlet "Sukses!" | lolcat
echo "Tutup dan buka lagi Termux untuk melihat hasilnya."
