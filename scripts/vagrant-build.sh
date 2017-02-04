#!/bin/bash

# Freeciv-web Vagrant Bootstrap Script - play.freeciv.org 
# 2014-02-17 - Andreas Røsdal
#
# Setup script for Freeciv-web to be used on a Vagrant local developer image.
# This script assumes that the source code in git has been checked out from
# https://github.com/freeciv/freeciv-web to /vagrant 

if [ -d "/vagrant/" ]; then
  # script is run to install Freeciv-web under vagrant
  basedir="/vagrant"
  logfile="/vagrant/freeciv-web-vagrant.log"
else
  # script is run to install Freeciv-web on current system without vagrant
  echo "Installing Freeciv-web on current system. Please run this script as root user."
  basedir=$(pwd)"/.."
  logfile="${basedir}/freeciv-web-vagrant.log"
fi


# Redirect copy of output to a log file.
exec > >(tee ${logfile})
exec 2>&1
set -e

echo "================================="
echo "Running Freeciv-web setup script."
echo "================================="

# if Freeciv-web already built with Vagrant, then start it instead.
if [ -f "/vagrant/freeciv-web/target/freeciv-web.war" ]; then
  printf "\n\nFreeciv-web already built, starting it.\n\n-----";
  cd ${basedir}/scripts/ && sudo -H -u vagrant ./start-freeciv-web.sh
  printf "Freeciv-web started. Now login with 'vagrant ssh' and point your browser to http://localhost";
  exit 0;
fi

uname -a
echo basedir  $basedir
echo logfile $logfile

# User will need permissions to create a database
mysql_user="root"
mysql_pass="vagrant"

tornado_url="https://github.com/tornadoweb/tornado/archive/v4.4.1.tar.gz"
casperjs_url="https://github.com/casperjs/casperjs/zipball/1.1.3"

# Based on fresh install of Ubuntu 16.04
dependencies="maven mysql-server openjdk-8-jdk-headless libcurl4-openssl-dev nginx libjansson-dev subversion pngcrush python3-pillow libtool automake autoconf autotools-dev language-pack-en python-minimal python3.5-dev python3-setuptools libbz2-dev imagemagick python3-pip dos2unix liblzma-dev xvfb libicu-dev pkg-config zlib1g-dev libsdl1.2-dev tomcat8 tomcat8-admin php7.0-common php7.0-cli php7.0-fpm php7.0-mysql unzip phantomjs zip"

## Setup
mkdir -p ${basedir}
cd ${basedir}

if [[ ! -f /etc/vagrant_installing_updates_and_dependencies ]]; then
  
## dependencies
echo "==== Installing Updates and Dependencies ===="
export DEBIAN_FRONTEND=noninteractive
apt-mark hold firefox
echo "apt-get update"
apt-get -y update
echo "apt-get upgrade"
apt-get -y upgrade
echo "mysql setup..."
debconf-set-selections <<< "mysql-server mysql-server/root_password password ${mysql_pass}"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${mysql_pass}"
echo "apt-get install dependencies"
apt-get -y install ${dependencies}

date > /etc/vagrant_installing_updates_and_dependencies
fi


if [[ ! -f /etc/fetching_installing_tornado_web_server ]]; then
echo "==== Fetching/Installing Tornado Web Server ===="
cd /tmp
wget ${tornado_url}
tar xvfz v4.4.1.tar.gz
cd tornado-4.4.1
python3 setup.py install

pip3 install wikipedia

date > /etc/fetching_installing_tornado_web_server
fi

if [[ ! -f /etc/build_and_install_mysql-connector-python ]]; then
## build and install mysql-connector-python
cd /tmp
wget https://github.com/mysql/mysql-connector-python/archive/2.1.3.zip
unzip 2.1.3.zip
cd mysql-connector-python-2.1.3
python3 setup.py install

date > /etc/build_and_install_mysql-connector-python
fi

if [[ ! -f /etc/mysql_setup ]]; then
## mysql setup
echo "==== Setting up MySQL ===="
mysqladmin -u ${mysql_user} -p${mysql_pass} create freeciv_web
mysql -u ${mysql_user} -p${mysql_pass} freeciv_web < ${basedir}/freeciv-web/src/main/webapp/meta/private/metaserver.sql
date > /etc/mysql_setup
fi

if [[ ! -f /etc/mysql_configuration_files ]]; then
# configuration files
dos2unix ${basedir}/scripts/configuration.sh.dist
sed -e "s/MYSQL_USER=root/MYSQL_USER=${mysql_user}/" -e "s/MYSQL_PASSWORD=changeme/MYSQL_PASSWORD=${mysql_pass}/" ${basedir}/scripts/configuration.sh.dist > ${basedir}/scripts/configuration.sh
cp ${basedir}/publite2/settings.ini.dist ${basedir}/publite2/settings.ini
cp ${basedir}/freeciv-web/src/main/webapp/meta/php_code/local.php.dist ${basedir}/freeciv-web/src/main/webapp/meta/php_code/local.php
cp ${basedir}/freeciv-web/src/main/webapp/META-INF/context.xml.dist ${basedir}/freeciv-web/src/main/webapp/META-INF/context.xml

dos2unix ${basedir}/scripts/configuration.sh.dist
sed -e "s/MYSQL_USER=root/MYSQL_USER=${mysql_user}/" -e "s/MYSQL_PASSWORD=changeme/MYSQL_PASSWORD=/" ${basedir}/scripts/configuration.sh.dist > ${basedir}/scripts/configuration.sh
  
date > /etc/mysql_configuration_files
fi

if [[ ! -f /etc/building_freeciv ]]; then
echo "==== Building freeciv ===="
dos2unix ${basedir}/freeciv/freeciv-web.project
cd ${basedir}/freeciv && sudo -Hu vagrant ./prepare_freeciv.sh
cd freeciv && sudo -u vagrant make install
date > /etc/building_freeciv
fi

if [[ ! -f /etc/building_freeciv-web ]]; then
echo "==== Building freeciv-web ===="
cd ${basedir}/scripts/freeciv-img-extract/ && ./setup_links.sh && ./sync.sh
cd /var/lib/tomcat8 && chmod -R 777 webapps logs && setfacl -d -m g::rwx webapps && chown -R www-data:www-data webapps/
cp ${basedir}/freeciv-web/src/main/webapp/WEB-INF/config.properties.dist ${basedir}/freeciv-web/src/main/webapp/WEB-INF/config.properties
cd ${basedir}/scripts && ./sync-js-hand.sh
cd ${basedir}/freeciv-web && sudo -u vagrant ./setup.sh
cp flyway.properties.dist flyway.properties
sudo -u vagrant mvn compile flyway:migrate
date > /etc/building_freeciv-web
fi

echo "=============================="


if [[ ! -f /etc/service_settings ]]; then

cp ${basedir}/pbem/settings.ini.dist ${basedir}/pbem/settings.ini

service nginx stop
rm /etc/nginx/sites-enabled/default
sed -i.bak -e "s/php7/php\/php7.0/" ${basedir}/publite2/nginx.conf 
cp ${basedir}/publite2/nginx.conf /etc/nginx/
date > /etc/service_settings
fi

if [[ ! -f /etc/add_freeciv-web_scripts_to_path ]]; then
# add Freeciv-web scripts to path
export PATH=$PATH:/vagrant/scripts
echo 'export PATH=$PATH:/vagrant/scripts' >> /home/vagrant/.bashrc

if [ -d "/vagrant/" ]; then
  echo "Starting Freeciv-web..."
  service nginx start
  cd ${basedir}/scripts/ && sudo -Hu vagrant ./start-freeciv-web.sh
else
  echo "Freeciv-web installed. Please start it manually."
fi
date > /etc/add_freeciv-web_scripts_to_path
fi

if [[ ! -f /etc/installing_casperjs_for_testing ]]; then
echo "============================================"
echo "Installing CasperJS for testing"
cd ${basedir}/tests/
wget ${casperjs_url}
unzip -qo 1.1.3
cd casperjs-casperjs-cd78443
ln -sf `pwd`/bin/casperjs /usr/local/bin/casperjs
date > /etc/installing_casperjs_for_testing
fi

echo "Start testing of Freeciv-web using CasperJS:"
cd ${basedir}/tests/
xvfb-run casperjs --engine=phantomjs test freeciv-web-tests.js || (>&2 echo "Freeciv-web CasperJS tests failed!" && exit 1)

echo "Freeciv-web started! Now try http://localhost/ on your host operating system."
