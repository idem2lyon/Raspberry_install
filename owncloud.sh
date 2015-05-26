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

install_owncloud(){
  mkdir -p /var/www
  wget -P /var/www http://download.owncloud.org/community/owncloud-6.0.1.tar.bz2
  tar -C /var/www -xvf /var/www/owncloud-6.0.1.tar.bz2
  rm /var/www/owncloud-6.0.1.tar.bz2
  chown -R www-data:www-data /var/www

  mv /etc/php5/php.ini /etc/php5/php.ini.bac
  cp ./php/php.ini /etc/php5/

  mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bac
  cp ./nginx/sites-available/default /etc/nginx/sites-available
  ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default  

  mkdir -p /media/hd/tmp
  chown www-data:www-data /media/hd/tmp

  /etc/init.d/nginx restart
  /etc/init.d/php5-fpm restart
}
