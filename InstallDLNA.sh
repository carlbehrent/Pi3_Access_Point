#Install Mini DLNA
sudo apt-get install minidlna

#Discover USB Drives
sudo fdisk -l


sudo mkdir /media/HDD
sudo chmod 777 /media/HDD

sudo nano /etc/fstab
#Enter this at the bottom of the file
/dev/sda1    /media/HDD   vfat    defaults     0        2

sudo reboot
sudo nano /etc/minidlna.conf

#Once you have that file open we are going to need to change that part that looks like this:

# * "A" for audio (eg. media_dir=A,/var/lib/minidlna/music)
# * "P" for pictures (eg. media_dir=P,/var/lib/minidlna/pictures)
# * "V" for video (eg. media_dir=V,/var/lib/minidlna/videos)
to this:

media_dir=A,/media/HDD/Music
media_dir=P,/media/HDD/Pictures
media_dir=V,/media/HDD/Movies

and this:

# Name that the DLNA server presents to clients.
#friendly_name=
to this:

# Name that the DLNA server presents to clients.
friendly_name=RASPI MINIDLNA


sudo service minidlna restart
sudo service minidlna force-reload
