#!/bin/sh

# ssh-config.sh - Install a script to simplify SSH config entry creation

INSTALL_PATH="/usr/local/bin/ssh-config"
TMP_SCRIPT="/tmp/ssh-config"

# Step 1: Tạo nội dung script ssh-config
cat << 'EOF' > "$TMP_SCRIPT"
#!/bin/sh

# Usage: ssh-config <host-alias> <user@hostname>
# Example: ssh-config phienserver coffee@ssh.phrimp.io.vn

if [ "$#" -ne 2 ]; then
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

# Step 2: Cấp quyền chạy
chmod +x "$TMP_SCRIPT"

# Step 3: Di chuyển vào /usr/local/bin nếu có quyền
if [ -w "/usr/local/bin" ]; then
  mv "$TMP_SCRIPT" "$INSTALL_PATH"
  echo "[✔] Installed ssh-config to /usr/local/bin"
else
  mv "$TMP_SCRIPT" "$HOME/ssh-config"
  echo "[!] Could not write to /usr/local/bin"
  echo "[!] Use it with: $HOME/ssh-config <alias> <user@host>"
fi
