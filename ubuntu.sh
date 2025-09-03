#!/bin/bash
set -e

echo "=== Updating package list ==="
sudo apt update -y

echo "=== Installing git, nodejs, npm , rsync ==="
sudo apt install -y git nodejs npm rsync vim

echo "=== Installing global npm packages: pm2, nvm, yarn ==="
sudo npm install -g pm2 yarn

wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

echo "=== Checking Node.js version ==="
node -v

echo "Install Docker"
echo "===> Bước 1: Cập nhật hệ thống và cài gói phụ thuộc"
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "===> Bước 2: Thêm GPG key chính thức của Docker"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "===> Bước 3: Thêm Docker repository vào APT"
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "===> Bước 4: Cập nhật lại danh sách package"
sudo apt update

echo "===> Bước 5: Cài đặt Docker Engine và plugin"
sudo apt install -y docker-ce docker-ce-cli containerd.io \
                    docker-buildx-plugin docker-compose-plugin

echo "===> Bước 6: Khởi động Docker và bật chạy cùng hệ thống"
sudo systemctl start docker
sudo systemctl enable docker

echo "===> Bước 7: Kiểm tra phiên bản Docker"
docker --version

echo "🎉 Docker đã được cài đặt thành công!"

echo "===> Bước 8: Tạo group docker"
sudo groupadd docker 2>/dev/null || true

echo "===> Bước 9: Thêm user hiện tại vào group docker"
sudo usermod -aG docker $USER

echo "===> Bước 10: Đảm bảo Docker daemon đang chạy và bật khởi động cùng hệ thống"
sudo systemctl enable --now docker

echo "===> Bước 11: Đặt quyền đúng cho socket (thường tự đúng, nhưng đặt lại để chắc)"
sudo chown root:docker /var/run/docker.sock || true
sudo chmod 660 /var/run/docker.sock || true

echo "===> Bước 12: Áp dụng group mới cho phiên shell hiện tại (khỏi cần logout)"
newgrp docker

echo "===> Bước 13: Test"
docker psdocke

echo "=== Installation completed successfully! ==="

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo 'zsh' >> ~/.bashrc

echo 'ZSH_THEME_GIT_PROMPT_PREFIX="%B%{$fg[yellow]%}(" ZSH_THEME_GIT_PROMPT_SUFFIX=")%b%{$reset_color%} " ZSH_THEME_GIT_PROMPT_DIRTY="" ZSH_THEME_GIT_PROMPT_CLEAN=""' >> ~/.zshrc

source ~/.zshrc
