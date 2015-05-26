#!/bin/bash
# Ultimate Rapsberry Installation scripts
# Description:  Install or uninstall Uris
# Usage:        ./install.sh --help
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
#----------------------------------------------------------------------------
# Default Variables
aui_path=/opt
defsleep=1


#---------------------------------------------------------------------------
# Functions
#---------------------------------------------------------------------------
function thank() {
  echo ""
  echo "Thank You"
  echo "By idem2lyon"
  sleep 1.5
  clear
  exit 0
}

function do_uninstall() {
  echo "Uninstall is still in progress."
  exit 0
}

function do_help() {
  echo "Usage: $0 [uninstall|help]
Run without any argument will default to installation."
  exit 0
}


function net() { 
  echo -en "Checking for internet connection"; sleep 0.2
  for i in $(seq 3); do echo -n '.'; sleep 0.8; done  # waiting time
  ping -c 3 8.8.8.8 &>/dev/null && { echo -e "${G}Success!\n$W"; return \
    0; } || { echo -e "${R}Failure! Please connect to the Internet!\n$W" >&2;
    return 1; }
}

function title() { echo -e "\033[92m\
      ____  ____  _       ___   __  ______
     / __ \/ __ \(_)     /   | / / / /  _/   The Raspberry PI
    / /_/ / /_/ / ______/ /| |/ / / // /    Arch Linux ARM
   / _, _/ ____/ /_____/ ___ / /_/ _/ /    [ Ultimate ]
  /_/ |_/_/   /_/     /_/  |_\____/___/   Installer\n\033[m"; return 0
}

#---------------------------------------------------------------------------
# Main
#---------------------------------------------------------------------------
# Help and uninstallation
[[ $# -gt 1 || $1 == *h* ]] && do_help  # Help if 'h' is specified
[[ $1 == *uninstall ]] && do_uninstall  # Uninstall if specified
[[ $# -gt 0 && -n $1 ]] && do_help      # Help for those enter nonsense

# Root privilege
[[ $UID -ne 0 ]] && { echo -e "\e[31mPlease run as root!\e[m"; exit 1; }

net

# Print the title
title
echo ""
echo "##############################################################"
echo "##   Welcome to Setup Pi v1.0                               ##"
echo "##   -- By kingspp                                          ##"
echo "##############################################################"
echo "  "
sleep 1

# Confirmation for installation
read -p "Do you want to install Ultimate Raspberry Installation scripts? " -e -n 1 ch
[[ $ch != [Yy] ]] && thank

# Install dependencies
hash git 2>/dev/null || { echo "Installing Git..."; pacman -S --noconfirm git; }

# Clone the repository and setup
cd /opt && git clone https://github.com/idem2lyon/Raspberry_install && cd Raspberry_install
chmod +x archi.sh
/opt/Raspberry_install/archi.sh 
/opt/Raspberry_install/disp.sh
/opt/Raspberry_install/oc.sh 
/opt/Raspberry_install/userm.sh
/opt/Raspberry_install/util.sh
echo "Installation is complete."
sleep 2

