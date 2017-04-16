#!/bin/bash
set -eux

# Freeciv-web Vagrant Bootstrap Script - play.freeciv.org 
# 2014-02-17 - Andreas Røsdal
#
# Setup script for Freeciv-web to be used on a Vagrant local developer image.
# This script assumes that the source code in git has been checked out from
# https://github.com/freeciv/freeciv-web to /vagrant 

user="vagrant"

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
  cd ${basedir}/scripts/ && sudo -H -u $user ./start-freeciv-web.sh
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

echo "==== Setting up MySQL ===="
#cd -

echo "==== Building freeciv-web ===="
cd ${basedir}/scripts && ./sync-js-hand.sh
cd ${basedir}/freeciv-web && sudo -u $user ./setup.sh

echo "=============================="

cp ${basedir}/pbem/settings.ini.dist ${basedir}/pbem/settings.ini

# add Freeciv-web scripts to path
export PATH=$PATH:/vagrant/scripts
echo 'export PATH=$PATH:/vagrant/scripts' >> /home/$user/.bashrc

if [ -d "/vagrant/" ]; then
  echo "Starting Freeciv-web..."
  service nginx start
  cd ${basedir}/scripts/ && sudo -Hu $user ./start-freeciv-web.sh
else
  echo "Freeciv-web installed. Please start it manually."
fi

echo "============================================"
echo "Installing CasperJS for testing"
cd ${basedir}/tests/

echo "Start testing of Freeciv-web using CasperJS:"
cd ${basedir}/tests/
export PATH=$PATH:/usr/local/bin
xvfb-run casperjs --engine=phantomjs test freeciv-web-tests.js || (>&2 echo "Freeciv-web CasperJS tests failed!" && exit 1)

echo "Freeciv-web started! Now try http://localhost/ on your host operating system."
