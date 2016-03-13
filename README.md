# Pi3_Access_Point
Raspberry Pi 3 Access Point (using Pi3 buitin wifi)
Check Ethernet & Wifi by lady ada
Before continuing make sure the Ethernet cable is connected in and you can ping out from the Pi
raspberry_pi_ifconfigtestether.gif
You will also want to set up your WiFi dongle. run sudo shutdown -h now and then plug in the WiFi module when the Pi is off so you don't cause a power surge.

When it comes back up check with ifconfig -a that you see wlan0 - the WiFi module.
raspberry_pi_ifconfiga.gif
Install software by lady ada
Next up we install the software onto the Pi that will act as the 'hostap' (host access point) You need internet access for this step so make sure that Ethernet connection is up!

 sudo apt-get update
sudo apt-get install hostapd isc-dhcp-server

(You may need to sudo apt-get update if the Pi can't seem to get to the apt-get repositories)
raspberry_pi_aptgethostapd.gif
(text above shows udhcpd but that doesnt work as well as isc-dhcp-server, still, the output should look similar)
Set up DHCP server

Next we will edit /etc/dhcp/dhcpd.conf, a file that sets up our DHCP server - this allows wifi connections to automatically get IP addresses, DNS, etc.

Run this command to edit the file
 sudo nano /etc/dhcp/dhcpd.conf
Find the lines that say
Copy Code
option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;
and change them to add a # in the beginning so they say
Copy Code
#option domain-name "example.org";
#option domain-name-servers ns1.example.org, ns2.example.org;
Find the lines that say
Copy Code
# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
#authoritative;
and remove the # so it says
Copy Code
# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
authoritative;
raspberry_pi_authoritatinve.gif
Then scroll down to the bottom and add the following lines
Copy Code
subnet 192.168.42.0 netmask 255.255.255.0 {
	range 192.168.42.10 192.168.42.50;
	option broadcast-address 192.168.42.255;
	option routers 192.168.42.1;
	default-lease-time 600;
	max-lease-time 7200;
	option domain-name "local";
	option domain-name-servers 8.8.8.8, 8.8.4.4;
}
raspberry_pi_iscdhcpconf.gif
Save the file by typing in Control-X then Y then return

Run
 sudo nano /etc/default/isc-dhcp-server
and scroll down to INTERFACES="" and update it to say INTERFACES="wlan0" 
raspberry_pi_dhcpwlan0.gif
close and save the file
Set up wlan0 for static IP

If you happen to have wlan0 active because you set it up, run sudo ifdown wlan0
There's no harm in running it if you're not sure
raspberry_pi_ifdownwlan0.gif
Next we will set up the wlan0 connection to be static and incoming. run sudo nano /etc/network/interfaces to edit the file

Find the line auto wlan0 and add a # in front of the line, and in front of every line afterwards. If you don't have that line, just make sure it looks like the screenshot below in the end! Basically just remove any old wlan0 configuration settings, we'll be changing them up

Depending on your existing setup/distribution there might be more or less text and it may vary a little bit

Add the lines
Copy Code
iface wlan0 inet static
  address 192.168.42.1
  netmask 255.255.255.0
After allow-hotplug wlan0 - see below for an example of what it should look like.  Any other lines afterwards should have a # in front to disable them
raspberry_pi_staticip.gif
Save the file (Control-X Y <return>) 

Assign a static IP address to the wifi adapter by running 
sudo ifconfig wlan0 192.168.42.1
raspberry_pi_ifconfigwlan0.gif
Configure Access Point

Now we can configure the access point details. We will set up a password-protected network so only people with the password can connect.

Create a new file by running sudo nano /etc/hostapd/hostapd.conf

Paste the following in, you can change the text after ssid= to another name, that will be the network broadcast name. The password can be changed with the text after wpa_passphrase=
Copy Code
interface=wlan0
driver=rtl871xdrv
ssid=Pi_AP
hw_mode=g
channel=6
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=Raspberry
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
If you are not using the Adafruit wifi adapters, you may have to change the driver=rtl871xdrv to say driver=nl80211 or something, we don't have tutorial support for that tho, YMMV!
raspberry_pi_edithostapdconf.gif
Save as usual. Make sure each line has no extra spaces or tabs at the end or beginning - this file is pretty picky!

Now we will tell the Pi where to find this configuration file. Run sudo nano /etc/default/hostapd

Find the line #DAEMON_CONF="" and edit it so it says DAEMON_CONF="/etc/hostapd/hostapd.conf"
Don't forget to remove the # in front to activate it!

Then save the file
