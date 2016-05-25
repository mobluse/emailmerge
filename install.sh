#!/bin/sh
sudo apt-get update
sudo apt-get -y install libio-all-perl \
  libemail-sender-perl libemail-sender-transport-smtps-perl \
  libemail-mime-creator-perl libmime-encwords-perl \
  libclass-dbi-mysql-perl mysql-server
