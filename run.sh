sudo apt update
sudo apt install -y git
echo "Install successfully : Git"
sudo apt install -y nodejs
echo "Install successfully : Node"
sudo apt install -y npm
echo "Install successfully : npm"
sudo npm install -y -g pm2
echo "Install successfully : PM2"
sudo npm install -y -g n
sudo n 18 && hash -r
node -v
echo "Install successfully : Nodejs 18"
sudo apt install -y make
echo "Install successfully : Makefile"
sudo apt install -y htop
sudo snap install -y docker
echo "Install successfully : Docker"
sudo chown ubuntu:ubuntu /var/run/docker.sock
echo "Install successfully : Run docker without sudo"
sudo npm i -g yarn
echo "Install successfully : Yarn"
