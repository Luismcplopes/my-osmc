#!/bin/sh
# Installation script for sickchill, CouchPotato, Rpimonitor, apache2 and
#######################
##      Install      ##
#######################
#
# Some tools installation
echo "Begining updating and installation of GIT..."
sudo apt-get --yes --force-yes update && sudo apt-get --yes --force-yes install git
echo "finished updating and instlaltion of GIT"
echo "Begining upgrading osmc..."
sudo apt-get --yes --force-yes upgrade
echo "finished upgrading"
echo "begining installing p7zip..."
sudo apt-get --yes --force-yes install p7zip-full
echo "installed p7zip"
echo "begining installing unrar..."
sudo apt-get install unrar -y
sudo mkdir /home/osmc/TV\ Shows
sudo chmod -R 766 /home/osmc/TV\ Shows
#sudo wget http://sourceforge.net/projects/bananapi/files/unrar_5.2.6-1_armhf.deb
#sudo dpkg -i unrar_5.2.6-1_armhf.deb
#echo "successfully installed and removing temporary file of unrar"
#sudo rm  unrar_5.2.6-1_armhf.deb
#echo "removed temporary file of unrar"
#
# CouchPotato installation
echo "Begining installing CouchPotato..."
echo "adding couchpotato username and adding to group..."
sudo useradd couchpotato
sudo usermod -a -G osmc couchpotato
echo "creatint home folder in /home/couchpotato..."
sudo mkdir /home/couchpotato
echo "granting permissions..."
sudo chown -R couchpotato:couchpotato /home/couchpotato
echo "downloading couchpotato and installing..."
sudo git clone http://github.com/RuudBurger/CouchPotatoServer /opt/CouchPotatoServer
echo "granting permissions... "
sudo chown -R couchpotato:couchpotato /opt/CouchPotatoServer
echo "adding startup script...."
cd /opt/CouchPotatoServer
sudo cp /opt/CouchPotatoServer/init/couchpotato.service /etc/systemd/system/couchpotato.service
cd  /etc/systemd/system/
echo "fixing startup path..."
sudo sed -i 's@/var/lib/CouchPotatoServer/CouchPotato.py@/opt/CouchPotatoServer/CouchPotato.py@g' couchpotato.service
echo "enabling startup script..."
sudo systemctl enable couchpotato.service
echo "couchpotato service is starting..."
sudo systemctl start couchpotato.service
echo "couchpotato successfully installed, you can check at Raspberry_Pi_IP_Address:5050"
cd
#
# sickchill installation
echo "Begining to install sickchill"
echo "creating sickchill username and adding to group..."
sudo useradd sickchill
sudo usermod -a -G osmc sickchill
echo "downloading sickchill and installing..."
sudo git clone https://github.com/SickChill/SickChill.git /opt/sickchill
echo "creating startup script for sickchill..."
sudo cp /opt/sickchill/runscripts/init.systemd /etc/systemd/system/sickchill.service
echo "granting permissions to sickchill folder"
sudo chown -R sickchill:sickchill /opt/sickchill
sudo chmod +x /opt/sickchill
sudo chmod a-x /etc/systemd/system/sickchill.service
echo "fixing path at startup script..."
cd /etc/systemd/system
sudo sed -i 's@/usr/bin/python2.7 /opt/sickchill/SickBeard.py -q --daemon --nolaunch --datadir=/opt/sickchill@/opt/sickchill/SickBeard.py -q --daemon --nolaunch --datadir=/opt/sickchill@g' sickchill.service
echo "enabling startup script...."
sudo systemctl enable sickchill.service
echo "starting sickchill and waiting to create file config.ini ..."
sudo systemctl start sickchill.service
echo "created file config.ini and stopping sickchill..."
sudo service sickchill stop
cd /opt/sickchill/
echo "adding username and password to sickchill... this fixes freezing raspbeery pi when you try to login to sickchill..."
sudo sed -i 's@web_username = ""@web_username = "osmc"@g' config.ini
sudo sed -i 's@web_password = ""@web_password = "osmc"@g' config.ini
echo "sickchill succesfully installed..."
sudo service sickchill start
echo "sickchill service started!"
# Restore backup services on OSMC
echo "settings services on OSMC"
#sudo cp /home/osmc/backup/osmc-files/sickrage-app-osmc /etc/osmc/apps.d/sickchill-app-osmc
sudo bash -c 'cat << EOF > /etc/osmc/apps.d/sickchill-app-osmc
sickchill
sickchill.service
EOF'
#sudo cp /home/osmc/backup/osmc-files/couchpotato-app-osmc /etc/osmc/apps.d/couchpotato-app-osmc
sudo bash -c 'cat << EOF > /etc/osmc/apps.d/couchpotato-app-osmc
CouchPotato
couchpotato.service
EOF'
#sudo cp /home/osmc/backup/osmc-files/rpimonitor-app-osmc /etc/osmc/apps.d/rpimonitor-app-osmc
sudo bash -c 'cat << EOF > /etc/osmc/apps.d/rpimonitor-app-osmc
rpimonitor
rpimonitor.service
EOF'
echo "successfully settings services on OSMC"
#
#headphones installation
echo "updating and upgrading packages"
#sudo apt-get update
#sudo apt-get upgrade -y
#echo "installing git-core"
#sudo apt-get install -y git-core
echo "installing headphones"
sudo git clone https://github.com/rembo10/headphones.git /opt/headphones
echo "creating user headphones and adding to osmc group"
sudo useradd headphones
sudo usermod -a -G osmc headphones
echo "giving permission to headphones folder"
sudo chown -R headphones:headphones /opt/headphones
echo "fixing localhost from localhost to 0.0.0.0 in config.py "
sudo sed -i 's@localhost@0.0.0.0@g' /opt/headphones/headphones/config.py
echo "creating "config file""
sudo printf '%s\n' 'HP_USER=headphones' 'HP_HOME=/opt/headphones' 'HP_PORT=8181' > /home/osmc/headphones
sudo mv headphones /etc/default/headphones
echo "creating startup script"
sudo cp /opt/headphones/init-scripts/init.ubuntu /etc/init.d/headphones
sudo chmod +x /etc/init.d/headphones
sudo update-rc.d headphones defaults
echo "starting headphones"
sudo service headphones start
echo "headphones started"
#sudo cp /home/osmc/backup/osmc-files/rpimonitor-app-osmc /etc/osmc/apps.d/rpimonitor-app-osmc
sudo bash -c 'cat << EOF > /etc/osmc/apps.d/headphones-app-osmc
headphones
headphones.service
EOF'
echo "adding nzbToMedia (I finded in howto guide, not sure why is this together.."
sudo git clone https://github.com/clinton-hall/nzbToMedia.git /opt/nzbToMedia
echo "headphones started"
echo "try in web browser your-ip-address-of-rpi:8181"
echo "enjoy"
#
#files of samba
echo "settings of Samba"
#sudo cp -R /home/osmc/backup/samba/smb-shares.conf /etc/samba/smb-shares.conf
sudo bash -c 'cat << EOF > /etc/samba/smb-shares.conf
[osmc]
    path = /home/osmc
    available = yes
    valid users = osmc
    read only = no
    browseable = yes
    public = yes
    guest ok = yes
    create mask = 0777
    directory mask = 0777
    writable = yes
    comment = OSMC Home Directory
EOF'
sudo service smbd start
echo " successfully folder Samba"
#
# rpimonitor installation
echo "Begining to install rpimonitor"
sudo apt-get -y install dirmngr
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2C0D3C0F
sudo wget http://goo.gl/vewCLL -O /etc/apt/sources.list.d/rpimonitor.list
sudo apt-get update && sudo apt-get -y install rpimonitor
sudo /etc/init.d/rpimonitor start
sudo /etc/init.d/rpimonitor update
sudo /etc/init.d/rpimonitor restart
echo "rpimonitor service started!"
#
#install slack
echo "Install settings of Slack"
sudo wget https://git.io/fhdBZ -O /usr/bin/notify_slack
sudo chmod +x /usr/bin/notify_slack
echo "Successfully Install settings of Slack"
echo " "
#
#install slack hook
echo "Install slack hook"
sudo bash -c 'cat << EOF > /usr/bin/slack_url
https://hooks.slack.com/services/Your-hook-here
EOF'
sudo chmod +x /usr/bin/slack_url
echo "Successfully Install slack hook"
echo " "
#
# install scrip to remove ation
echo "Install script removecompletedtorrents"
sudo wget https://git.io/fhd4N -O /usr/bin/removecompletedtorrents.sh
sudo chmod +x /usr/bin/removecompletedtorrents.sh
echo "Successfully Install script removecompletedtorrents"
echo " "
#
# JAckett installation
# mono installation(https://www.mono-project.com/download/stable/#download-lin-raspbian)
echo "install mono - required for jackett"
sudo apt install apt-transport-https dirmngr gnupg ca-certificates -y
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/debian stable-raspbianstretch main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt update
sudo apt-get install mono-devel -y
#echo "install p7zip for extraction zip files"
#sudo apt-get install p7zip-full -y
#echo "install unrar"
#sudo apt-get install unrar -y
echo "install some other dependencies"
sudo apt-get install python-cheetah git-core libcurl4-openssl-dev jq nodejs -y
echo "install sickrage specific dependencies"
sudo apt-get install python-setuptools build-essential python-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev -y
#
# JAckett installation
sudo apt-get install libcurl4-openssl-dev bzip2 ca-certificates-mono -y
release=`wget -q https://github.com/Jackett/Jackett/releases/latest -O - | grep "title>Release" | cut -d " " -f 4`
echo $release
cd /opt
sudo wget -c https://github.com/Jackett/Jackett/releases/download/$release/Jackett.Binaries.Mono.tar.gz
sudo tar zxvf Jackett*
sudo chown -R osmc:osmc /opt/Jackett
sudo bash -c 'cat << EOF > /lib/systemd/system/jackett.service
[Unit]
Description=Jackett Daemon
After=network.target

[Service]
User=osmc
Restart=always
RestartSec=5
Type=simple
ExecStart=/usr/bin/mono --debug /opt/Jackett/JackettConsole.exe --NoRestart
TimeoutStopSec=20

[Install]
WantedBy=multi-user.target
EOF'
# mono --debug /opt/Jackett/JackettConsole.exe 
sudo systemctl enable jackett
sudo systemctl start jackett

#sudo cp /home/osmc/backup/osmc-files/jackett-app-osmc /etc/osmc/apps.d/jackett-app-osmc
sudo bash -c 'cat << EOF > /etc/osmc/apps.d/jackett-app-osmc
jackett
jackett.service
EOF'
#
#
#apache2 installation
#echo "Begining to install apache"
#sudo apt-get -y install apache2 php libapache2-mod-php php7.0-mbstring
#sudo systemctl stop apache2.service
#sudo sed -i 's@Listen 80""@Listen 8080@g' /etc/apache2/ports.conf #FIXME:
#sudo rm -rf /var/www/html/index.html
#sudo chown osmc: /var/www/html
#sudo mkdir /var/www/html/admin
#sudo mkdir /var/www/html/guest
#cd /var/www/html/guest/
#sudo ln -s -r /home/osmc/Movies
#sudo ln -s -r /home/osmc/TV\ Shows/
##sudo cp /home/osmc/backup/html/index.php /var/www/html/admin/index.php
#sudo curl -fsSL  https://raw.githubusercontent.com/dulldusk/phpfm/master/index.php  > /var/www/html/admin/index.php
#sudo cp /home/osmc/backup/html/000-default.conf /etc/apache2/sites-enabled/000-default.conf #FIXME:
#sudo htpasswd -c -b /etc/apache2/.htpasswd2 osmc osmc
#sudo htpasswd -c -b /etc/apache2/.htpasswd osmc osmc
#sudo htpasswd  -b /etc/apache2/.htpasswd guest guest
#systemctl restart  apache2.service
#echo "apache service started!"


echo "Successfully installed! more info bellow..."
echo " "
echo " "
#echo "Apache info:"
#echo "http://"$(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":8080/"
#echo "http://"$(ip addr show wlan0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":8080/"
echo " "
echo " "
echo "RPIMonitor info:"
echo "http://"$(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":8888/"
echo "http://"$(ip addr show wlan0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":8888/"
echo " "
echo " "
echo "osmc info:"
echo "http://"$(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":80/"
echo "http://"$(ip addr show wlan0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":80/"
echo " "
echo " "
echo "Couchpotato info:"
echo "http://"$(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":5050/"
echo "http://"$(ip addr show wlan0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":5050/"
echo " "
echo " "
echo "Transmission info:"
echo "http://"$(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":9091/"
echo "http://"$(ip addr show wlan0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":9091/"
echo " "
echo " "
echo "Jackett info:"
echo "http://"$(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":9117/"
echo "http://"$(ip addr show wlan0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":9117/"
echo " "
echo " "
echo "Headphones info:"
echo "http://"$(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":8181"
echo "http://"$(ip addr show wlan0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":8181/"
echo " "
echo " "
echo "sickchill info:"
echo "http://"$(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":8081/"
echo "http://"$(ip addr show wlan0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)":8081/"
echo " "
echo "sickchill login info:"
echo "username: osmc"
echo "password: osmc"
echo " "
echo " "
echo "Test Slack notication by typing :"
echo "notify_slack"
echo "bash removecompletedtorrents.sh"
echo "vi /etc/rc.local and add the line  /usr/bin/notify_slack before exit 0 "
echo "enjoy"
