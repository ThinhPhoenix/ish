#!/bin/ash

echo "[*] Setting up iSH..."

# 1. Đặt mật khẩu root (sudo dùng root luôn)
echo "[*] Setting root password"
passwd root

# 2. Tạo user mới và đặt mật khẩu
read -p "Enter new username: " newuser
adduser -D "$newuser"
passwd "$newuser"
echo "[*] Added user: $newuser"

# 3. Đặt hostname
read -p "Enter hostname: " myhost
echo "$myhost" > /etc/hostname
hostname "$myhost"
echo "[*] Hostname set to $myhost"

# 4. Cài neofetch
apk update && apk add neofetch

# 5. Chỉnh sửa ASCII art thành Apple logo
echo "[*] Customizing neofetch Apple logo"
cat > /usr/share/neofetch/ascii/apple.txt <<'EOF'
             .:'         
         __ :'__        
      .'`__`-'__``.      
     :__________.-'     
     :_________:        
      :_________`-;     
       `.__.-.__.'      
EOF

# 6. Sửa phần OS hiển thị (kèm version Alpine)
echo "[*] Customizing OS name in neofetch"
ALPINE_VERSION=$(cat /etc/alpine-release)
NEOFETCH_FILE="/usr/bin/neofetch"

# Backup neofetch
cp "$NEOFETCH_FILE" "$NEOFETCH_FILE.bak"

# Replace OS line with iOS (Alpine Linux x.x.x)
sed -i "s/OS:.*/OS: iOS (Alpine Linux $ALPINE_VERSION)/" "$NEOFETCH_FILE"

# 7. Cài openssh và dropbear
apk add openssh dropbear

# 8. Kích hoạt SSH (dropbear)
echo "[*] Starting dropbear SSH server"
mkdir -p /etc/dropbear
dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
echo "/usr/sbin/dropbear -E -F -p 22" > /etc/local.d/dropbear.start
chmod +x /etc/local.d/dropbear.start
rc-update add local
/etc/local.d/dropbear.start

echo "[✔] Setup complete. You can now SSH into iSH!"