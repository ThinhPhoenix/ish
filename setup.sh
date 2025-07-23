#!/bin/ash

# 1. Hỏi tên người dùng và tên máy
read -p "User: " USERNAME
read -p "Hostname: " HOSTNAME

# 2. Tạo ~/.ashrc nếu chưa có
touch ~/.ashrc

# 3. Ghi cấu hình prompt vào ~/.ashrc
cat << EOF > ~/.ashrc
PS1='\\n\\[\\033[37m\\]$USERNAME@$HOSTNAME\\[\\033[0m\\]\\n\\[\\033[1;34m\\]\\w\\[\\033[0m\\]\\n\\[\\033[1;32m\\]↝ \\[\\033[0m\\]'
EOF

# 4. Tự động load ~/.ashrc khi shell khởi động
grep -q 'export ENV=~/.ashrc' ~/.profile 2>/dev/null || echo 'export ENV=~/.ashrc' >> ~/.profile

# 5. Reload lại shell config
. ~/.ashrc

# 6. Cài neofetch nếu chưa có
if ! command -v neofetch >/dev/null 2>&1; then
  apk update && apk add neofetch openssh
fi

# 7. Tạo thư mục config neofetch nếu chưa có
mkdir -p ~/.config/neofetch

# 8. Ghi config neofetch
cat << EOF > ~/.config/neofetch/config.conf
ascii_distro="macos"
EOF

# 9. Tạo script ssh-config
cat << 'EOF' > /tmp/ssh-config
#!/bin/bash

# Usage: ssh-config <host-alias> <user@hostname>
# Example: ssh-config phienserver coffee@ssh.phrimp.io.vn

if [ $# -ne 2 ]; then
  echo "Usage: ssh-config <host-alias> <user@hostname>"
  exit 1
fi

ALIAS="$1"
USER_AT_HOST="$2"

USER=$(echo "$USER_AT_HOST" | cut -d'@' -f1)
HOST=$(echo "$USER_AT_HOST" | cut -d'@' -f2)

CONFIG_FILE="$HOME/.ssh/config"

mkdir -p ~/.ssh
touch "$CONFIG_FILE"

# Check if alias already exists
if grep -q "Host $ALIAS" "$CONFIG_FILE"; then
  echo "[✘] Alias '$ALIAS' already exists in $CONFIG_FILE"
  exit 1
fi

cat <<EOC >> "$CONFIG_FILE"

Host $ALIAS
    HostName $HOST
    User $USER
EOC

echo "[✔] Added SSH config for '$ALIAS' -> $USER@$HOST"
EOF

# 10. Cho phép chạy script ssh-config
chmod +x /tmp/ssh-config

# 11. Di chuyển ssh-config vào /usr/local/bin nếu có quyền
if [ -w /usr/local/bin ]; then
  mv /tmp/ssh-config /usr/local/bin/ssh-config
  chmod +x /usr/local/bin/ssh-config
  echo "[✔] Installed ssh-config to /usr/local/bin"
else
  mv /tmp/ssh-config ~/ssh-config
  echo "[!] Could not write to /usr/local/bin, keeping ssh-config in ~/"
  echo "[!] Use it with: ~/ssh-config <alias> <user@host>"
fi