#!/bin/ash

echo "[*] Setting up iSH..."

# 1. Đặt mật khẩu root
echo "[*] Setting root password"
passwd root

# 2. Tạo user mới và đặt mật khẩu
echo -n "Enter new username: "
read newuser
adduser -D "$newuser"
passwd "$newuser"
echo "[*] Added user: $newuser"

# 3. Ghi hostname (không đổi được thực tế do sandbox)
echo -n "Enter hostname: "
read myhost
echo "$myhost" > /etc/hostname
echo "[!] iSH không cho phép đổi hostname trực tiếp. Đã lưu tên vào /etc/hostname"

# 4. Cài neofetch
apk update && apk add neofetch

# 5. Tùy chỉnh ASCII Apple logo
echo "[*] Customizing neofetch Apple logo"
mkdir -p /usr/share/neofetch/ascii
cat > /usr/share/neofetch/ascii/apple.txt <<'EOF'
             .:'         
         __ :'__        
      .'`__`-'__``.      
     :__________.-'     
     :_________:        
      :_________`-;     
       `.__.-.__.'      
EOF

# 6. Sửa cấu hình neofetch để hiển thị OS + logo vĩnh viễn
echo "[*] Customizing neofetch config"
ALPINE_VERSION=$(cat /etc/alpine-release)
mkdir -p /home/$newuser/.config/neofetch
cat > /home/$newuser/.config/neofetch/config.conf <<EOF
ascii_distro="apple"
print_info() {
    info title
    info underline

    info "OS" "iOS (Alpine Linux $ALPINE_VERSION)"
    info kernel
    info uptime
    info packages
    info shell
    info terminal
    info cpu
    info memory
}
EOF
chown -R $newuser:$newuser /home/$newuser/.config

# 7. Cài SSH
apk add openssh dropbear

# 8. Kích hoạt SSH bằng dropbear
echo "[*] Starting dropbear SSH server"
mkdir -p /etc/dropbear
dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
echo "/usr/sbin/dropbear -E -F -p 22" > /etc/local.d/dropbear.start
chmod +x /etc/local.d/dropbear.start
rc-update add local
/etc/local.d/dropbear.start

# 9. Tự động login vào user khi mở iSH
echo "[*] Configuring auto-login to $newuser"
echo "exec su - $newuser" >> /root/.profile

echo "[✔] Setup complete. iSH will now auto-login as $newuser!"