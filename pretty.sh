#!/bin/ash

# 1. Tạo ~/.ashrc nếu chưa tồn tại
touch ~/.ashrc

# 2. Ghi cấu hình prompt vào ~/.ashrc
cat << 'EOF' > ~/.ashrc
PS1='\[\033[37m\]thinhphoenix@iphone\[\033[0m\]\n\[\033[1;34m\]\w\[\033[0m\]\n\[\033[1;32m\]↝ \[\033[0m\]'
EOF

# 3. Thêm ENV vào ~/.profile nếu chưa có
grep -q 'export ENV=~/.ashrc' ~/.profile 2>/dev/null || echo 'export ENV=~/.ashrc' >> ~/.profile

# 4. Tải lại cấu hình ngay
. ~/.ashrc