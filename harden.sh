 #! /usr/bin/env bash

set -euo pipefail



sudo ufw allow 22/tcp

echo "y" | sudo ufw enable | cut -d' ' -f2

sudo ufw default deny incoming

sudo ufw default allow outgoing

sudo ufw allow 443/tcp && sudo ufw allow 80/tcp

sudo apt update && sudo apt install fail2ban -y  &> /dev/null

sudo systemctl enable --now fail2ban

cd /etc/fail2ban/

sudo cp jail.conf jail.local


if ! grep -A 10 "^\[sshd\]" /etc/fail2ban/jail.local | grep -qE "^\s*enabled\s*=\s*true"; then

    echo "[+] SSHD uchun enabled = true sozlamasi qo'shilmoqda..."

    

    # Agar enabled parameteri (masalan '#enabled = false') bor bo'lsa, uni almashtiramiz

    if grep -A 10 "^\[sshd\]" /etc/fail2ban/jail.local | grep -qE "^\s*#?\s*enabled"; then

        sudo sed -i '/^\[sshd\]/,/^\[/ s/^\s*#\?\s*enabled.*/enabled = true/' /etc/fail2ban/jail.local

    else

        # Agar 'enabled' kalit so'zi umuman bo'lmasa, [sshd] tagiga to'g'ridan-to'g'ri qo'shamiz

        sudo sed -i '/^\[sshd\]/a enabled = true' /etc/fail2ban/jail.local

    fi

fi


sudo systemctl restart fail2ban

sudo timedatectl set-timezone Asia/Tashkent


b=$(id deploy)

if [[ -z "$b" ]]; then

    sudo useradd -m -s /bin/bash deploy

    sudo passwd deploy

    sudo usermod -aG sudo deploy

fi


sudo cp /etc/ssh/sshd_config /etc/ssh/ssh_config.d/


sudo sed -i 's/^#\?PermitRootLogin no/PermitRootLogin no/' /etc/ssh/ssh_config.d/sshd_config


sudo systemctl restart sshd

sudo passwd -l root


sudo sed -i 's#root:x:0:0:root:/root:/bin/bash#root:x:0:0:root:/root:/sbin/nologin#g' /etc/passwd

echo "configuratsiya tugadi" 
