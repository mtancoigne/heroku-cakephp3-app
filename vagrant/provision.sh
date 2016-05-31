#!/usr/bin/env bash

#-------------------------------------------------------------------------------
# Vagrant configuration file, highly based on
#   https://github.com/tektoh/heroku-cakephp3-app
#   https://github.com/alayek/zeus
#   and some strings found on puphpet boxes (http://puphpet.com)
#
# Author: Manuel Tancoigne
# Original authors:
#   - Shinichi Segawa (https://github.com/tektoh/),
#   - Arijit Layek (https://github.com/alayek/)
#
# This box will create a minimal virtual box (ubuntu trusty-x64) with minimal
# packages required to run an apache2 webserver with php5 and postgreSQL.
#
# CakePHP is a slightly modified version of the official cakePHP 3.2, with minor
# changes to make Heroku deployment a piece of cake.
#
# All credit goes to Shinichi Segawa (tektoh) for his implementation, I only
# updated his work to CakePHP 3.2.
#-------------------------------------------------------------------------------

# Installation settings for a PHP box with CakePHP installed
PROJECT="my_project" # we would want a name passed to it via te first argument, $1
DB="my_app" # the name of postgreSQL DB we need to provision, maybe $2

# This file is executed by root user - sudo not needed
# But do not create any directory
# which vagrant user might need access to later in su mode
# use su - vagrant -c "" syntax
export DEBIAN_FRONTEND=noninteractive
echo "---------------------------------------------"
echo "Running vagrant provisioning"
echo "---------------------------------------------"

# Install heroku toolbelt
echo "- Adding heroku toolbelt to packages sources "
# These shell script snippets are directly taken from heroku installation script
echo "deb http://toolbelt.heroku.com/ubuntu ./" > /etc/apt/sources.list.d/heroku.list
# install heroku's release key for package verification
wget -O- https://toolbelt.heroku.com/apt/release.key 2>&1 | apt-key add -

echo "---------------------------------------------"
echo "------- Updating package dependencies -------"
echo "---------------------------------------------"
apt-get update -y # no need for sudo, and -y is needed to bypass the yes-no

echo "---------------------------------------------"
echo "-------- Installing packages ----------------"
echo "---------------------------------------------"

# Additionnal packages :
#  - man : for documentation
#  - dos2unix : to avoid CR-LF issues on windows (and that would prevent ~/.bashrc to work properly because \r would be unrecognized)
#  - heroku-toolbelt : CLI for Heroku
#  - ruby : needed for heroku toolbelt
#  - curl : needed to download things
apt-get install -y --no-install-recommends heroku-toolbelt ruby dos2unix man curl

# Installing the PHP dev stack
apt-get install -y --no-install-recommends git apache2 postgresql postgresql-contrib phpunit php5 php5-intl php5-pgsql php5-mcrypt php5-sqlite php5-apcu php5-cli

# Install Heroku CLI
su - vagrant -c "heroku --version > /dev/null 2>&1"

# Enabling PHP mcrypt
php5enmod mcrypt

# Install postgresql and setup user
echo "---------------------------------------------"
echo "------- Setting up postgresql ---------------"
echo "---------------------------------------------"
su - postgres -c "createuser -s vagrant"
su - vagrant -c "createdb ${DB}"

# Creating "my_app" DB
echo "---------------------------------------------"
echo "------- Creating empty 'my_app' DB ----------"
echo "---------------------------------------------"
#mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS my_app DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci"
#mysql -uroot -proot -e "GRANT ALL ON my_app.* TO 'my_app'@'localhost' IDENTIFIED BY 'secret'"
#mysql -uroot -proot -e "GRANT ALL ON my_app.* TO 'my_app'@'%' IDENTIFIED BY 'secret'"
#mysql -uroot -proot -e "FLUSH PRIVILEGES"

# Installing composer system-wide
echo "---------------------------------------------"
echo "------- Setting up Composer -----------------"
echo "---------------------------------------------"
cd /vagrant
if [ ! -e composer.phar ]; then
  curl -sS https://getcomposer.org/installer | sudo php
  export COMPOSER_PROCESS_TIMEOUT=600
  yes | php composer.phar install --prefer-dist
else
  php composer.phar self-update
  yes | php composer.phar update
fi

# Copying apache config
echo "---------------------------------------------"
echo "------- Configuring Apache2 -----------------"
echo "---------------------------------------------"
cp vagrant/000-default.conf /etc/apache2/sites-available/000-default.conf
service apache2 restart

exit 0
