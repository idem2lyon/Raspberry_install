raspberry

How to create a backup image of your SD card while your Raspberry PI is running?

You can create a backup (.img) of your SD card to a network / USB drive while the card is inserted in your Raspberry PI!

    make sure you have access to your network drive / usb drive;
    to see the devices type:
    sudo cat /etc/fstab

    create an img of the card currently in the PI to your network drive / USB drive using the dd command:
    sudo dd if=/dev/mmcblk0p2 of=/home/pi/networkdrive/my.img bs=1M
    (replace /dev/mmcblk0p2 with your own SD card and /home/pi/networkdrive/my.img with your own network drive / USB drive + image file name)



First script to run after setting up SD for Raspberry Pi

This assumes AT LEAST a 16G SD card

This script can take upwards of 4 hours to run depending on if you have an A or B.
Usage

From your home directory (/home/pi/)

curl -Lo- http://raw.com/idem2lyon/Raspberry_install/master/raspberry-bootstrap | bash
