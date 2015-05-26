# install git
sudo apt-get  install git
git clone https://github.com/andreafabrizi/Dropbox-Uploader.git 

#run dropbox and configure App sreality tokens
./dropbox_uploader.sh

#install crontab jobs
24 * * * * /home/pi/sreality/rss_parser.pl > /tmp/sreality.rss
25 * * * * /home/pi/Dropbox-Uploader/dropbox_uploader.sh upload /tmp/sreality.rss /Public/feed.rss
