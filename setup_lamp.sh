#!/bin/bash

sudo apt update

sudo apt install php7.2-mbstring php7.2-xml python-pip inotify-tools php7.2 php7.2-mysql php7.2-zip zip unzip openssl build-essential python lsb-release
mkdir .nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

nvm install v10
sudo dpkg -i mysql-apt-config*.deb
sudo add-apt-repository ppa:ondrej/apache2
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
