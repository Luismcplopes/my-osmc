#!/bin/sh
# Script for Restore from backup sickchill, CouchPotato, Rpimonitor, 
#
#######################
##Restore from backup##
#######################
#
#
# Restore backup files of sickchill
echo "restoring settings of Sickchill"
sudo service sickchill stop
sudo cp /home/osmc/backup/sickchill/*.* /opt/sickchill/
sudo chmod 775 -R /opt/sickchill
sudo chown sickchill:sickchill -R /opt/sickchill
sudo service sickchill start
echo "backup successfully restored in folder Sickchill"
#
# Restore backup files of couchpotato
echo "restoring settings of CouchPotato"
sudo service couchpotato stop
sudo cp /home/osmc/backup/couchpotato/settings.conf /home/couchpotato/.couchpotato/settings.conf
sudo cp -R /home/osmc/backup/couchpotato/  /home/couchpotato/.couchpotato/
sudo chmod 775 -R /home/couchpotato/.couchpotato
# db in /home/couchpotato/.couchpotato
sudo chown couchpotato:couchpotato -R /home/couchpotato/.couchpotato
sudo service couchpotato start
echo "backup successfully restored in folder CouchPotato"
#
# Restore backup files of transmission
echo "restoring settings of transmission"
mkdir /home/osmc/Donwload
sudo chown -R osmc:osmc /home/osmc/Donwload
#sudo chmod +x /home/osmc/Donwload
sudo chmod 775 -R /home/osmc/Donwload
sudo service transmission stop
sudo cp -R /home/osmc/backup/transmission/*.* /home/osmc/.config/transmission-daemon/
sudo chmod 775 -R /home/osmc/.config/transmission-daemon
sudo chown osmc:osmc -R /home/osmc/.config/transmission-daemon
sudo service transmission start
echo "backup successfully restored in folder transmission"
#
# Restore backup files of RPiMonitor
echo "restoring settings of rpimonitor"
sudo service rpimonitor stop
sudo cp -R /home/osmc/backup/rpimonitor/*.* /etc/rpimonitor/
sudo service rpimonitor start
echo "backup successfully restored in folder rpimonitor"
#
# Restore backup files of kodi addons and kodi userdata
echo "restoring data of kodi userdata and addons from backup..."
echo "it may take a few minutes..."
sudo cp -R /home/osmc/backup/kodi/addons /home/osmc/.kodi/
sudo cp -R /home/osmc/backup/kodi/userdata /home/osmc/.kodi/
sudo chmod -775 -R /home/osmc/.kodi
sudo chmod osmc:osmc -R /home/osmc/.kodi
echo "restored successfully from /backup/kodi/"
#
# Restore backup files of Jackett
echo "restoring settings of Jackett"
sudo service jackett stop
sudo cp -R /home/osmc/backup/Jackett/ /home/osmc/.config/Jackett/ 
sudo service jackett start
echo "backup successfully restored in folder Jackett"
#
# Restore backup files of mono
# backup ~/.config/.mono/keypairs/ or ~/.config/.mono
echo "backup successfully restored"