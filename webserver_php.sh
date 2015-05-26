
#!/bin/bash
# Created by idem2lyon <idem@geekandmore.fr>
# DESCRIPTION	: The main part of Uris
#---------------------------------------------------------------------------
#    Copyright (C) idem2lyon 2015
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#----------------------------------------------------------------------------
# Run this script after your first boot with archlinux (as root)
# Variables
#----------------------------------------------------------------------------

install_php(){
  apt-get -y install php5 php5-fpm php-pear php5-common php5-mcrypt php5-mysql php5-cli php5-gd php-apc  
}

install_nginx(){
  apt-get -y install nginx
  usermod -a -G pirate www-data
  mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bac
  cp ./nginx/nginx.conf /etc/nginx/

  openssl req $@ -new -x509 -days 365 -nodes -out /etc/nginx/cert.pem -keyout /etc/nginx/cert.key
  chmod 600 /etc/nginx/cert.pem
  chmod 600 /etc/nginx/cert.key
}

install_apache(){

}
