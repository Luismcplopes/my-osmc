# My Media Center
RaspeberryPi with OSMC and SSH and Samba and Transmission and sickchill and CouchPotato and Jacket and headphones
 
## Download OSMC
 - https://osmc.tv/download/

## Install on SD card
 - https://computers.tutsplus.com/articles/how-to-flash-an-sd-card-for-raspberry-pi--mac-53600

## How to activate SSH, Samba, Transmissio inside the OSMC 
On OSMC go to "PROGRAMAS",  "MY OSMC" "APP STORE" and then install the services
My osmc => Updates => Manual Controls => Scan for updates now 
My osmc => App Store => install Transmition
My osmc => App Store => install Samba
My osmc => App Store => install SSH
My osmc => App Store => install Cron task

## Install all
Run this `sudo wget https://raw.githubusercontent.com/Luismcplopes/my-osmc/master/easyinstall-all.sh  -O /home/osmc/easyinstall-all.sh` or Copy file `install-couchpotato-sickrage.sh` to osmc home folder and run command:
```bash
sudo sh easyinstall-all.sh
```
## Slackhook
## cronJob



## Some Notes
### Samba - how to config extra shares
-Add custom shares in smb-shares.conf instead of editing smb.conf so they will not be overwritten by samba updates. You can only add new shares to smb-shares.conf, not change the default shares or global options. If you need full control see smb-local.conf above. `include = /etc/samba/smb-shares.conf` to /etc/samba/smb.conf
```bash
sudo cp smb-shares.conf /etc/samba/smb-shares.conf
```

### Transmission - change the default settings  

"rpc-whitelist": "192.168.*.* ",
If you want it to be more secure. However, if you want to be able to access transmission outside your local network then it should be *.*.*.* 

May as well disable the whitelist if you are allowing all IPs
"rpc-whitelist-enabled": false,

Change the remote access username and password to your liking
"rpc-password": "password",
"rpc-username": "username",

##### Make Transmission Automatically Stop Seeding 
"idle-seeding-limit: 0",
"idle-seeding-limit-enabled: true",








## How to Config 
### Config Sickrage
 - https://www.htpcguides.com/configure-sickrage-usenet-torrent-tv/

### ConfigCouchpotat
 - https://www.htpcguides.com/configure-couchpotato-torrent-movies/

### manage CouchPotato, rpimonitor and Sickchill from OSMC 
 - https://discourse.osmc.tv/t/sickrage-and-couchpotato-managed-from-osmc-services/36914
