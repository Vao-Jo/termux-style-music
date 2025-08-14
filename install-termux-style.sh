#!/data/data/com.termux/files/usr/bin/bash

# Tanya nama user
read -p "Masukkan nama yang ingin dipakai di Termux: " USERNAME
if [ -z "$USERNAME" ]; then
    USERNAME="SUKSES"
fi

# Efek loading
echo -ne "\n[+] Menyiapkan instalasi"
for i in {1..5}; do
    echo -n "."
    sleep 0.3
done
echo -e " OK!\n"

# Pastikan dependensi terpasang
pkg install sox figlet ruby -y > /dev/null 2>&1
gem install lolcat > /dev/null 2>&1

# Salin musik startup
cp husarski-cyberwave-172902.mp3 ~/startup.mp3

# Tambahkan ke .bashrc
cat <<EOT >> ~/.bashrc
trap 'pkill -f "play ~/startup.mp3"' EXIT
play ~/startup.mp3 gain 3 repeat 999 > /dev/null 2>&1 &

clear
figlet "Welcome $USERNAME" | lolcat
PS1="~ ☠️$USERNAME☠️ "
EOT

echo "✅ Instalasi selesai. Silakan buka ulang Termux."
