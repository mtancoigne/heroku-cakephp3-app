#!/bin/sh

sudo apt-get -y update
sudo apt-get -y install git apache2
sudo apt-get -y install php5 php5-intl php5-mysql php5-mcrypt php5-sqlite php5-apcu php5-cli
echo 'mysql-server mysql-server/root_password password root' | sudo debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password root' | sudo debconf-set-selections
sudo apt-get -y install mysql-server
sudo php5enmod mcrypt

cd /vagrant

if [ ! -e composer.phar ]; then
  curl -sS https://getcomposer.org/installer | sudo php
  export COMPOSER_PROCESS_TIMEOUT=600
  yes | php composer.phar install --prefer-dist
else
  php composer.phar self-update
  yes | php composer.phar update
fi

sudo cp vagrant/000-default.conf /etc/apache2/sites-available/000-default.conf
sudo service apache2 restart

mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS my_app DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci"
mysql -uroot -proot -e "GRANT ALL ON my_app.* TO 'my_app'@'localhost' IDENTIFIED BY 'secret'"
mysql -uroot -proot -e "GRANT ALL ON my_app.* TO 'my_app'@'%' IDENTIFIED BY 'secret'"
mysql -uroot -proot -e "FLUSH PRIVILEGES"

exit 0
