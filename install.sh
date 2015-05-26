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
# Defaults
uris=/opt/Raspberry_install
defsleep=0;
uisleep=2;
r='\033[91m'; g='\033[92m'; w='\033[0m' # Colours


#----------------------------------------------------------------------------
# Functions
#----------------------------------------------------------------------------
function checkr() { # Check if user is running as root
  [[ "$UID" != 0 ]] && { echo "Please run as root!"; exit 1; }
  echo "User running as root!!"
  sleep $defsleep
}

#function ask() { # ask -> $rpi_aui/./yn.sh "Is this what you want? [Y/n]"
#  read ch
#  if [ "$ch" == 'y' ] || [ "ch" == "Y" ] ; then
#  	echo ""
#  else
#  	thank
#  fi
#}

function yesorno() {
  while : ; do  # ask again when there's no default preference
  # Usage: $ main.sh yn "Question: [Y/n]"   Note: [Y/n] -> default Y
  echo -en "$1 "; read -n 1 ans; echo # echo with 1 space & read 1 character
  [[ $ans == [Yy] ]] && { exit 0; } # return success if ans = y or Y
  [[ $ans == [Nn] ]] && { exit 1; } # return failure if ans = n or N
  [[ $(grep -o '\[./.\]' <<< $1) == *'Y'* ]] && exit 0 # [Y/n] -> default Y
  [[ $(grep -o '\[./.\]' <<< $1) == *'N'* ]] && exit 1 # [y/N] -> default N
done
}

function install() { # Default Installation
  $rpi_aui/main.sh title
  echo "Updating $(grep "^ID=" /etc/*-release|cut -d= -f2)..."
  $rpi_aui/main.sh pkg_up   # Update distribution
  $rpi_aui/main.sh pkg_de   # Package management initialization
  sleep $defsleep; echo "Installing base and base-devel packages..."
  $rpi_aui/main.sh pkg_in base base-devel
}

function partm() {
  $rpi_aui/./main.sh title
  echo " Lets Utilize full size of the Memory Card "
  echo "Partition Manager"
  echo " "
  echo " Commands "
  echo " "
  echo "d - delete a partition"
  echo "l - list known partition types"
  echo "n - add a new partition"
  echo "p - print the partition table"
  echo "t - change a partition type"
  echo "v - verify the partition table"
  echo " "
  #fdisk /dev/mmcblk0
}

function hname() {  # Change hostname the systemd way
  read -p "Enter the new hostname: " hn && hostnamectl set-hostname $hn
  echo "Your new hostname is:" $(hostname)
}

function set_locale() {	# Set the locale
  echo "Still in progress"
}

function menu() { # User Interface
  $rpi_aui/./main.sh title
  W="$r**$w"; echo -e "Press$r q$w to quit
  $W --> To do (Be Cautious)

########################################################
1. Ping Check                  c. Command Pi v1.0 $W
2. Arch Linux Update           d. Display Pi v1.5
3. Partition Manager $W        o. OverClocking Pi v2.0
4. User Management             u. Utility Pi v2.0
5. Change Root Password        l. LXDE on LAN v1.0
6. Change Locale $W            p. Install pi4j v1.0
7. Hostname                    r. Resize Pi v1.1
8. Resize root file system $W  m. User Pi v2.0
9. Default Installation        t. Change timezone
10.Update AUI $W               l. Change locale
99.Changelog $W                v. View Credits
########################################################"
  read -p "Select an option: " opt
  case $opt in
    1) $rpi_aui/main.sh net; sleep 1 ;;

    2) $rpi_aui/./yn.sh "Do you want to update Arch? [Y/n]" || ui # Else
      echo "Updating Arch Linux to its Latest Release..."
      pacman -Syu --noconfirm && echo " You have the latest Arch ;) "
      ;;

    3) $rpi_aui/./yn.sh "You are $rWARNED$w not to manage Partitions. Are you sure? [y/N]" || ui # Too long! -> Need to shorten
      partm
      read s
      ui
      ;;

    4) echo "User Management"; echo
    $rpi_aui/./userm.sh; ui    # Return to user interface
    ;;

    5) $rpi_aui/./yn.sh "Do you want to change $r\Root$w Password? [y/N]" && passwd;;  # Too long! -> Need to shorten

    6) $rpi_aui/./yn.sh "Do you want to change the Locale? [y/N]" || ui
    echo -n "Default Locale: "
    sleep $defsleep
    grep -v ^# /etc/locale.gen
    read s
    ui
    ;;

    7) echo "Your current hostname is:" $(hostname)
      $rpi_aui/./yn.sh "Do you wish to change the hostname? [y/N]" || ui
      hname
      ;;

    8) $rpi_aui/./resize.sh;;

    9) echo "Default Installation: "; $rpi_aui/main.sh net; defins
      $rpi_aui/oc.sh
      $rpi_aui/yn.sh "Do you want to change $r\Root$w Password? [y/N]" &&
        passwd
      $rpi_aui/util.sh
      hname
      read s
      ui
      ;;

    10) echo "Checking for AUI Updates . . "; update
    echo "Update Complete!"
    sleep 1
    ui
    ;;

    c) echo "You have selected Command Pi"
    sleep $uisleep
    $rpi_aui/./command.sh
    ;;

    d) echo " You have selected Display Pi "
    sleep $uisleep
    $rpi_aui/./disp.sh
    ui
    ;;

    o) $rpi_aui/yn.sh "Do you want to OverClock PI? [y/N]" || ui
      sleep $uisleep && $rpi_aui/./oc.sh
      ;;

    u) echo "You have selected Utility Pi "
    sleep $uisleep
    $rpi_aui/./util.sh
    ;;

    l) echo "You have selected LXDE on LAN "
    sleep $uisleep
    $rpi_aui/./lan_lxde.sh
    ui
    ;;

    p) echo "You have selected pi4j "
    sleep $uisleep
    $rpi_aui/./pi4j.sh
    ui
    ;;

    r) echo "You have selected Resize Pi "
      sleep $uisleep
      $rpi_aui/./resize.sh
      ui
      ;;

    m) echo "You have selected User Pi "
      sleep $uisleep
      $rpi_aui/./userm.sh
      ui
      ;;

    t) [[ ! -f /etc/localtime ]] && echo "You have not set your timezone." ||
    echo "Your current localtime:" $(basename `realpath /etc/localtime`)
    $rpi_aui/./yn.sh "Do you wish to set your localtime? [y/N]" || ui
    if hash python2 2>/dev/null; then
      echo "Python2 is installed."
    elif hash python3 2>/dev/null; then
      # Translate to python3 if python3 is installed
      echo "Python3 in installed."
      sed -i 's/python2/python3/g; s/raw_input/input/g' $rpi_aui/timezone.py
    else echo "Python is not installed... installing python2."
      pacman -S --needed --noconfirm python2
    fi
    $rpi_aui/./timezone.py # Run timezone.py
    ;;

    v) less $aui_doc/AUTHORS ;;

    q) $rpi_aui/./main.sh title thank; exit ;;
  esac
}


#----------------------------------------------------------------------------
# Main - forever in ui loop
#----------------------------------------------------------------------------
chmod +x $rpi_aui/*; $rpi_aui/main.sh root && while : ; do ui; done || exit 1
