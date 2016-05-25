#!/bin/sh
sudo apt-get update
sudo apt-get -y install libemail-sender-perl libemail-sender-transport-smtps-perl
sudo apt-get -y install libemail-mime-creator-perl libmime-encwords-perl
sudo apt-get -y install libclass-dbi-mysql-perl mysql-server
