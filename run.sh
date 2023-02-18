sudo apt update
sudo apt install git
echo "Install successfully : Git"
sudo apt install nodejs
echo "Install successfully : Node"
sudo apt install npm
echo "Install successfully : npm"
sudo npm install -g pm2
echo "Install successfully : PM2"
sudo npm install -g n
sudo n 18 && hash -r
node -v
echo "Install successfully : Nodejs 18"
sudo apt install make
echo "Install successfully : Makefile"
sudo apt install htop
sudo snap install docker
echo "Install successfully : Docker"
sudo chown ubuntu:docker /var/run/docker.sock
echo "Install successfully : Run docker without sudo"
sudo npm i -g yarn
echo "Install successfully : Yarn"
sudo apt install nginx
sudo ufw app list
sudo ufw allow 'Nginx HTTP'
sudo ufw enable
sudo ufw status
echo "Install successfully : Nginx"
