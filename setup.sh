#!/bin/bash
# Ultimate Rapsberry Installation Scripts
# Description:  Install or uninstall Uris
# Usage:        ./setup.sh --help
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
uris_path=/opt
defsleep=1


#---------------------------------------------------------------------------
# Functions
#---------------------------------------------------------------------------
thank() {
  echo ""
  echo "Thank You"
  echo "By idem2lyon"
  echo "Please, visit http://geekandmore.fr"
  sleep 1.5
  clear
  exit 0
}

do_uninstall() {
  echo "Uninstall is still in progress."
  exit 0
}

do_help() {
  echo "Usage: $0 [uninstall|help]
Run without any argument will default to installation."
  exit 0
}


net() { 
  echo -en "Checking for internet connection"; sleep 0.2
  for i in $(seq 3); do echo -n '.'; sleep 0.8; done  # waiting time
  ping -c 3 8.8.8.8 &>/dev/null && { echo -e "${G}Success!\n$W"; return \
    0; } || { echo -e "${R}Failure! Please connect to the Internet first!\n$W" >&2;
    return 1; }
}

title() { echo -e "\033[92m\
 _   _      _                                                                                                                 
| | | |_ __(_)___     The Ultimate                                                                                                        
| | | | '__| / __|        Raspberry                                                                                                    
| |_| | |  | \__ \            Installation                                                                                                
 \___/|_|  |_|___/                Scripts\n\033[m"; return 0

echo ""
echo "##############################################################"
echo "##   Welcome to the ...                                     ##"
echo "##   Ultimate Rpi Installation Scripts v1.0                 ##"
echo "##   -- By idem2lyon                                        ##"
echo "##   Please, visit http://geekandmore.fr                    ##"
echo "##############################################################"
echo "  "
sleep 1  
}

yesorno() {                                                                                                                   
        while [ 1 -eq 1 ]                                                                                                     
        do                                                                                                                    
                echo  "$1 "                                                                                                   
                read answer                                                                                                   
                answer=$(echo $answer | tr '[a-z]' '[A-Z]')                                                                   
                [[ $answer == [Y] ]] && { return 0; }                                                                         
                [[ $answer == [N] ]] && { return 1; }                                                                         
        done                                                                                                                  
}                                                                                                                             

root() {
  [[ $UID -eq 0 ]] && return 0 || { echo -e "\033[91mPlease run as root! \
Try '\033[32msudo su\033[31m'\033[0m" >&2; exit 1; }
}

#---------------------------------------------------------------------------
# Main
#---------------------------------------------------------------------------
# Help and uninstallation
[[ $# -gt 1 || $1 == *h* ]] && do_help  # Help if 'h' is specified
[[ $1 == *uninstall ]] && do_uninstall  # Uninstall if specified
[[ $# -gt 0 && -n $1 ]] && do_help      # Help for those enter nonsense

# Root privilege
root

# Check Internet connection
net

# Print the title
title

# Confirmation for installation
yesorno "Do you want to execute Ultimate Raspberry Installation Scripts? [y/N]" && echo "Ok, let's go"  && thank

# Install dependencies
hash git 2>/dev/null || { echo "Installing Git..."; aptitude install git; }

# Clone the repository and setup
cd /opt && git clone https://github.com/idem2lyon/Raspberry_install && cd Raspberry_install
chmod +x setup.sh
./setup.sh
echo "Installation is complete."
sleep 2

