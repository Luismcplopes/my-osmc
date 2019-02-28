#!/bin/sh
#backup database and settings for couchpotato, sickchill and transmission
echo "creating backup..."
echo "stopping services..."
sudo service couchpotato stop
sudo service sickrage stop
sudo service sickchill stop
sudo service transmission stop
sudo service jackett stop
sudo service rpimonitor stop
cd /home/osmc/
sudo mkdir backup
cd /home/osmc/backup
#
echo "creating backup of sickrage"
sudo mkdir sickrage

sudo cp /opt/sickrage/config.ini /home/osmc/backup/sickrage/config.ini
sudo cp /opt/sickrage/sickbeard.db /home/osmc/backup/sickrage/sickbeard.db
echo "creating backup of sickrage is done"
#
echo "creating backup of sickchill"
sudo mkdir sickchill
sudo cp /opt/sickchill/config.ini /home/osmc/backup/sickchill/config.ini
sudo cp /opt/sickchill/sickbeard.db /home/osmc/backup/sickchill/sickbeard.db
echo "creating backup of sickchill is done"
#
echo "creating backup of couchpotato"
sudo cp -R /home/couchpotato/.couchpotato/ /home/osmc/backup/couchpotato/
echo "creating backup of couchpotato is done"
#
echo "creating backup of transmission"
sudo mkdir transmission
cd transmission
sudo cp /home/osmc/.config/transmission-daemon/*.* ./
cd /home/osmc/
echo "creating backup of transmission is done"
#
echo "creating backup of Jackett"
sudo cp -R /home/osmc/.config/Jackett/ /home/osmc/backup/Jackett/
echo "creating backup of Jackett is done"
#
cd /home/osmc/
#
echo "creating backup of kodi userdata and addons..."
echo "it may take a few minutes..."
sudo mkdir /home/osmc/backup/kodi
sudo cp -R /home/osmc/.kodi/addons /home/osmc/backup/kodi/addons
sudo cp -R /home/osmc/.kodi/userdata /home/osmc/backup/kodi/userdata
echo "creating settings backup of rpimonitor"
sudo mkdir /home/osmc/backup/rpimonitor
sudo cp -R /etc/rpimonitor/template /home/osmc/backup/rpimonitor/template 
echo "backup successfully created in folder /home/osmc/backup/rpimonitor"
#
echo "starting services..."
sudo service jackett start
sudo service couchpotato start
sudo service sickrage start
sudo service sickchill start
sudo service transmission start
sudo service rpimonitor start
echo "services started!"