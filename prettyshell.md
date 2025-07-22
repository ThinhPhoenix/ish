Dưới đây là phiên bản được trình bày lại bằng Markdown rõ ràng và dễ đọc hơn:

---

## Thiết lập Prompt cho `ash` shell

### 1. Tạo file `~/.ashrc`

```bash
touch ~/.ashrc
```

### 2. Cấu hình Prompt

```bash
echo "PS1='\[\033[37m\]thinhphoenix@iphone\[\033[0m\]\n\[\033[1;34m\]\w\[\033[0m\] \[\033[1;32m\]↝\[\033[0m\] '" > ~/.ashrc
```

> Prompt sẽ hiển thị theo định dạng:
>
> ```
> thinhphoenix@iphone
> /đường/dẫn/hiện/tại ↝ 
> ```

### 3. Liên kết `~/.ashrc` vào shell qua `.profile`

```bash
echo 'export ENV=~/.ashrc' >> ~/.profile
```

### 4. Tải lại cấu hình `~/.ashrc`

```bash
. ~/.ashrc
```

---

Nếu bạn dùng `ash` như trong môi trường `Alpine`, bước 3 là cần thiết để `ash` tự động load `~/.ashrc` khi khởi động shell. Nếu bạn đang dùng `bash`, thì nên dùng `.bashrc` và `.bash_profile` thay.