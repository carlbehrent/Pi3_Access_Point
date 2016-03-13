# Pi3_Access_Point
Raspberry Pi 3 Access Point (using Pi3 buitin wifi)

For this instructable you will need:

Raspberry pi (I'm using a model B)
Another computer if you want to SSH into your pi
Hard drive with your media
SD card for the raspberry pi operating system
Raspberry pi wifi dongle (you can also use Ethernet)\
A power supply for the raspberry pi (a minimum of 1 AMP and 5 Volts for the Raspberry Pi model B)
A powered USB hub


Step 2: Updating and Installing

 Picture of Updating and Installing
 install minidlna.PNG
To begin we can SSH into our raspberry pi by using a program like putty. After we have done this I recommend updating and upgrading your raspberry pi. You can do this by using the following commands.

sudo apt-get update

sudo apt-get upgrade
Once this is finished we can install the media server software. Use the next command to do this.

sudo apt-get install minidlna
After you enter this command you will probably be asking if you want to continue. Just press y and then enter. Once that has finished installing it is time for the next step.





Step 3: Connecting the hard drive

 Picture of Connecting the hard drive
Before we can start our media server we need some media of course. So what we are going to do is make it so that our media hard drive is mounted on start-up.

To do this the first thing we need to do is plug in our media drive. Make sure you plug it into the powered USB hub and not directly into the raspberry pi because sometimes that can cause problems. Once you have done this we need to go back to putty or whatever SSH client you are using and type in:

sudo fdisk -l
What this does is it shows use important information about the drives that are connected to our raspberry pi. In the picture I have circled the name of my drive in white. In my case it was /dev/sda1. I know this because where I have circled in green says that the drive /dev/sda has 1000 GB which is the size of my drive. In red I have circled the format of the drive which we will need in the next step. You are going to need to know the name of your drive and the format of your drive in the following steps so it is probably a good idea to write them down somewhere.

Step 4: Mounting the drive on startup

 Picture of Mounting the drive on startup
We need to have our media drive to be mounted on startup so that we can access its contents. To do this we are going to need to make a folder to mount it to. You can do that by using this command:

sudo mkdir /media/HDD
What this command does is makes a folder called HDD in the media directory. So once we have made this folder we need to give it read write permissions. We can do this by using this command:

sudo chmod 777 /media/HDD
This command command tells the folder HDD that it has all permission. This means that it has read and write permissions which is what we wanted.

Now we need to edit the fstab file. This is the file that the raspberry pi operating system refers to when it is looking to see which dives to mount at startup so we need to put our media drive in that file. We can do that by using the command:

sudo nano /etc/fstab
Once in this file you will notice that it is not the same as Microsoft Word which you might be familiar to. You need to use the arrow keys to navigate around. So go to the bottom of this file and you are going to add this line:

/dev/sda1    /media/HDD   vfat    defaults     0        2
Ok so the line that you just added might be a bit confusing so I will try to explain it. The first part where is says /dev/sda1 is the is the name of the hard drive that you want to add. Remember from the previous step. The next part is the place where you are going to mount it to. Then we have the format of the hard drive. In this case it is fat32. And finally the 0 and 2 at the end are permissions.

Now it you reboot the raspberry pi:

sudo reboot
and move into the directory /media/HDD

cd /media/HDD
And run this command:

ls
You should be able to see all the files on your hard drive.

Step 5: Configuring MiniDLNA

 Picture of Configuring MiniDLNA
 friendly name.PNG minidlna restart.PNG minidlna force reload.PNG
To start configuring MiniDLNA we need to edit the config file. This can be done by using this command:

sudo nano /etc/minidlna.conf
Once you have that file open we are going to need to change that part that looks like this:

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
In the line above where I have put RASPI MINIDLNA can be whatever you want.

Then press control x to exit and press y if it asks if you want to "save modified buffers" then press enter to confirm.

Now that we have configured MiniDLNA we have to refresh it. To do this you can run the following commands:

sudo service minidlna restart
sudo service minidlna force-reload
Now if you hop back onto a windows computer or any Upnp compatible device you should be able to see your server. On window if you click on start then computer then on the left hand side click on network you should be able to see your raspberry pi Minidlna server called RASPI MINIDLNA under the media devices section.
