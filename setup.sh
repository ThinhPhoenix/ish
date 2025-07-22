#!/bin/ash

# Ask for username and hostname
echo "Nhập tên user:"
read USERNAME
echo "Nhập hostname:"
read HOSTNAME

# 1. Tạo ~/.ashrc nếu chưa tồn tại
touch ~/.ashrc

# 2. Ghi cấu hình prompt vào ~/.ashrc
cat << EOF > ~/.ashrc
PS1='\\n\\[\\033[37m\\]$USERNAME@$HOSTNAME\\[\\033[0m\\]\\n\\[\\033[1;34m\\]\\w\\[\\033[0m\\]\\n\\[\\033[1;32m\\]↝ \\[\\033[0m\\]'
EOF

# 3. Thêm ENV vào ~/.profile nếu chưa có
grep -q 'export ENV=~/.ashrc' ~/.profile 2>/dev/null || echo 'export ENV=~/.ashrc' >> ~/.profile

# 4. Tải lại ~/.ashrc
. ~/.ashrc

# 5. Cài neofetch (nếu chưa có)
if ! command -v neofetch >/dev/null 2>&1; then
  apk update && apk add neofetch
fi

# 6. Lấy phiên bản Alpine
ALPINE_VERSION=$(cat /etc/alpine-release)

# 7. Tạo thư mục config nếu chưa có
mkdir -p ~/.config/neofetch

# 8. Ghi cấu hình neofetch vào ~/.config/neofetch/config.conf
cat << EOF > ~/.config/neofetch/config.conf
print_info() {
    info title
    info "OS" "iOS (Alpine Linux $ALPINE_VERSION)"
    info kernel
    info uptime
    info packages
    info shell
    info resolution
    info terminal
    info cpu
    info memory
}

ascii_distro="macos"
EOF