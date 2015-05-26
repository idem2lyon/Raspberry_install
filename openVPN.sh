
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


# Default values
hostname=$(hostname)
country="FR"
province="Midi-Pyrénées"
city="Toulouse"
email="root@$hostname"
uniqId=$(ifconfig | grep "192.168.[0-9]*.251" | sed 's/.*192\.168\.\([0-9]*\).*/\1/g')
install_dhcpd=0

# Unique identifier check
if [ "$uniqId" != "0" ]
then
	if [ -z "$uniqId" -o "$(expr $uniqId + 0 &> /dev/null; echo $?)" != "0" ]
	then
		echo "Your local IP address is not well configured."
		echo "It shall be 192.168.N.251, where N is your unique identifier."
		exit 1
	fi
fi

# Hostname check
if [ "$(hostname -a &> /dev/null; echo $?)" != "0" ]
then
	echo "Your hostname is not resolvable."
	echo "Please check your /etc/hosts file."
	exit 1
fi


	# OpenVPN
	echo "OpenVPN installation..."
	apt-get install -y openvpn
	
	if [ $? -eq 0 ]
	then
		# Copy easy-rsa 2.0 files
		cp -R /usr/share/doc/openvpn/examples/easy-rsa/2.0 /etc/openvpn/easy-rsa

		# Patch scripts
		sed -i 's/--interact //g' /etc/openvpn/easy-rsa/build-key
		sed -i 's/--interact //g' /etc/openvpn/easy-rsa/build-key-server

		# Update default values with ours
		sed -i "s/^\(export KEY_COUNTRY\).*/\1=\"$country\"/g" /etc/openvpn/easy-rsa/vars
		sed -i "s/^\(export KEY_PROVINCE\).*/\1=\"$province\"/g" /etc/openvpn/easy-rsa/vars
		sed -i "s/^\(export KEY_CITY\).*/\1=\"$city\"/g" /etc/openvpn/easy-rsa/vars
		sed -i "s/^\(export KEY_ORG\).*/\1=\"$hostname\"/g" /etc/openvpn/easy-rsa/vars
		sed -i "s/^\(export KEY_EMAIL\).*/\1=\"$email\"/g" /etc/openvpn/easy-rsa/vars
		sed -i "s/^\(export KEY_OU\).*/\1=\"$hostname\"/g" /etc/openvpn/easy-rsa/vars

		# Generate Certificate Authority & Server certificate
		cd /etc/openvpn/easy-rsa
		source vars
		export KEY_NAME="$hostname"
		export KEY_CN="$hostname"
		./clean-all
		echo -e "\n\n\n\n\n\n\n\n" | ./build-ca
		echo
		./build-key-server $hostname
		./build-dh
		cd $basedir

		# Generate OpenVPN Server configuration
		cp $basedir/openvpn-server.conf /etc/openvpn/$hostname.conf
		sed -i "s/\\[ID\\]/$uniqId/g" /etc/openvpn/$hostname.conf
		sed -i "s/\\[HOSTNAME\\]/$hostname/g" /etc/openvpn/$hostname.conf
		service openvpn restart
	else
		echo "An error has occured."
		exit 3
	fi
