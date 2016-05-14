#!/bin/sh
sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get -y install libemail-send-perl libemail-mime-creator-perl
sudo apt-get -y install libmime-encwords-perl libclass-dbi-mysql-perl
sudo apt-get -y install mysql-server
sudo apt-get -y autoremove
