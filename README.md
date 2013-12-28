# HiLink HLK-RM04
Build guide for a firmware based on OpenWrt for HiLink HLK-RM04

## Introduction
HLK-RM04 is a small wifi module which is produced by HiLink.
It is based on the Ralink RT5350 with some GPIOs raised out.  
HLK-RM04 has 4M flash and 16M SDRAM on-package, 1 USB port, 2 UART ports (lite and full), 1 I2C, 2 GPIO (GPIO0, RIN), and 2 Ethernet ports (LAN and WAN). In different configurations, you can get different numbers of GPIO pins (for example 8 GPIOs + 1 serial port).

Even though the module can be upgraded to have twice as much flash and RAM, our purpose is to use it without hardware modifications. Everything here is compatible with the standard 16M RAM module.

### Scope

The main purpose is to have the module connected to a WiFi network and somehow access the serial port and GPIOs over TCP/IP.
Eventually it should be nice to hook it up to some rellays and/or use it as a remote serial console.

### Features

There are 3 prebuild images with different features but the recommended one is **mini-serial** which has the following features:
- Output the console on the serial interface by default.
- Connects to a WiFi router and automatically goes online both with IPv4 and IPv6 if available.
- When the module goes online it automatically sets it's clock via NTP.
- Listen for SSH connections and accepts authentication via SSH keys. By default no password is set so you either rebuild the image with your own ssh key or set a password via the serial console.
- Automatically start ser2net configure it to listen on ports 2001, 3001 and 3003 with various settings.
- Preconfigured the lan interface with the 192.168.11.1 IP address and /24 network if setting the wifi router is not convenient.
- The WAN interface will automatically configure an IP address via DHCP.
- AccessPoint mode support
- Bridge and VLAN support

### Limitations

**16M of RAM** really isn't that much and because of that the image includes bare minimum software.
- With hostapd and dnsmasq running it uses almost all the memory and it works slow so using it as an AccessPoint is possible but unpractical. Since this is not our scope anyways, dnsmasq and iptables were removed from our mini firmware image.
- Running a web interface will be a tall order and it will probably have to be something custom that uses very little memory.

## Files

- In the **[files](./files)** directory there are the custom OpenWRT config files available in the image which will be built automatically
- The **[.config](./.config)** file contains build options for our latest image. Almost nothing :)
- The **[images](./images)** directory contains 3 prebuild images and a uboot image for allowing reflasing the module over TFTP and serial.

## Build

    git clone git@github.com:bogdanr/HLK-RM04.git
    make menuconfig
    make

After it compiles successfully, you'll find images in `bin/ramips/` which are named `openwrt-ramips-rt305x-hlk-rm04-*.bin`.
openwrt-ramips-rt305x-hlk-rm04-squashfs-sysupgrade.bin will be used for when upgrading from another OpenWRT image.
openwrt-ramips-rt305x-hlk-rm04-initramfs-factory.bin will be used only once, when upgrading the HLK-RM04 module for the first time.

## Instalation

### WARNING:

The most important thing is to flash the uboot128.img bootloader image. This one will then allow you to flash system images over and over again.
Accessing the device via the serial interface will also be absolutely necessary.

### Flash bootloader

The standard UBoot is silent so we can't see any messages from it that would allow us to easily flash the module.
At the <http://192.168.16.254/adm/hlk_update_www_hlktech_com.asp> address we are allowed to flash a new bootloader. Obviously this is just the standard IP address of the module. You should know what to use if you changed it.
After you flash it, check if it still boots :)

With the serial cable connected and configured as 57600,8,n,1 you shouls start seeing stuff when the module boots. If this doesn't happend STOP here!

### Flashing the image

- Run a TFTP server and make sure you can GET the image from it. From the CLI you can just do something like `in.tftpd -L /tmp` if your image is in /tmp
- Connect HLK-RM04 LAN port to your PC, power up HLK-RM04
- Push `2` quickly and only once to enter in TFTP flash mode. Then push `Y` to proceed.
- Set device IP to `192.168.16.1`. Set server IP to `192.168.16.100`.
- Set the IP address on your computer from the connected interface to `192.168.16.100`.
- Input the file name to something like `/tmp/openwrt-ramips-rt305x-hlk-rm04-squashfs-sysupgrade.bin`.
- Hope it boots :)
