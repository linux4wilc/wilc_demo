# MiWi to WiFi Bridge Demo with AWS

Create a Wi-Fi/ MiWi (15.4) / LoRa wireless sensor network to monitor the temperatures covering a wide area like a hotel or a plant.

## Introduction
This application notes describe the MiWi to WiFi bridge demo application with its test setup information. The MiWi to WiFi bridge application helps to monitor and control the MiWi network through Wi-Fi bridge and AWS EC2 instance provided Amazon Machine Image (AMI)  as an infrastructure service. WSN monitor tool will be used to monitor and control the network, connected through AWS cloud.

For MiWi network SAMR30 Xplained pro boards are used. In the MiWi network, only one PAN coordinator and N number of routers or coordinator and end-devices are used.
For WiFi bridge, SAMA5D2 Xplained pro board connected WILC1000 SD board in SDIO interfaces used to access the network connectivity.
AWS EC2 instance service is used to run the TCP server to connect with both WiFi bridge and WSN monitor tool through TCP clients.
The python script is used to develop the TCP server and client to connect and communicate with the MiWi network and WSN monitor tool. 
MiWi applications are used from ASF release and Linux kernel is used for WiFi connectivity

## Features
- Monitors sensor data (temperature, battery level and RSSI)
- Covers 34-35 locations over a vast area of approx. 1 km2
- Secure communication with AWS IoT for Wi-Fi and MiWi
- WSN Monitor tool will display the MiWi network with connections 
- More than one WSN Monitor tool could be connected remotely.
- Battery operated devices
- Showcase different technologies tackling the same task

## Hardware Platform
- ATSAMR34-XPRO – 3 Nos minimum (one PAN, one Router, one End-Device)
- ATSAMA5D2-Xplained Ultra board
- ATWILC1000 SD board
- Internet Gateway connectivity

## Software Platform
- Linux machine - Ubuntu 
- Windows machine
- BuildRoot image
- Linux Kernel 4.14.73 used from Linux4sam_6.0
- WILC1000 Driver and firmware 15.02 release
- Python 2.7
- AWS Cloud Server account 
- WSN monitor Tool 2.2.1
- ASF 3.46 MiWi Applications

   **Smart Secure Connected**
![](https://www.microchip.com/ResourcePackages/Microchip/assets/dist/images/logo.png)

## Demo Building Blocks & Flow

![GitHub Logo](https://github.com/linux4wilc/wilc_demo/blob/master/wilc_sama5d2_xpro_miwi_bridge/Images/Block-Daigram.png)

## MiWi Network
- MiWi Network consist of PAN-Coordinator, Router or coordinator, End-device.
- PAN-Coordinator Node directly connected with SAMAD2 XPRO board USB port and enumerated as COM port.
-	MiWi applications are taken from ASF3.45 release. No major change in the existing application apart from the Naming and channel.

## AT91SAMA5D27 on Linux
- Limux4Sam_6.0 package with kernel 4.14.73 used to generate the zImage, device tree file by compiled on GCC compiler 7.3.0.
- BuildRoot is built with required python2.7 modules, which will be used in TCP application.

## ATWILC1000 Modules & Firmware
- WILC driver 15.02 version compiled against Kernel 4.14.73 and added in the `$ /root` of the Buildroot package. Firmware is added in `$ /lib/firmware/mchp`.
- After the SAMA5D2 device kernel boot up, in root files system "mchp" folder will be available.

## AWS Cloud EC2 Instance Services
-	Using AWS account we can create the EC2 service with AMI free-tier instance.
-	This EC2 instance will provide the public and private IP’s to communicate with VPC Linux machine.
-	In this AMI required applications are already installed to run our python based application.
-	Using SSH application with private key provide by AWS cloud we open the VPC Linux terminal.
-	This Linux terminal will be used to run any application developed on python or C, etc…

## WSN Monitor Tool
- The tool used to monitor and control the MiWi network. Tool is having two options to connect with network such as Serial port or TCP client.
- In this demo, TCP client option is used to connect with AWS Cloud TCP server.

# SAMA5D2 Linux Setup
## Install the Demo Image on the SAMA5D2 Xplained eMMC

1. Download the SAM-BA® 3.2.1 demo package and unzip or untar the package.
  ```
  For Linux machine -> sam-ba_3.2.1_Linux.tar
  For Windows machine -> sam-ba_3.2.1_Windows.zip
  ```
2. Demo package contains the `$ sdcard.img` and `$ emmc-usb.qml` scripts.
3. Connect the FTDI cable to the Debug connector (J1).
    - Note: Do not use J14 connector to receive debug messages.
4. Connect a USB cable to J23 port to flash the image.
5. Close the jumper JP9, press the reset button and open the jumper.
6. Navigate to folder path from the demo image package 
  ```
  /wilc_demo/wilc_sama5d2_xpro_miwi_bridge/sama5d2_binary/
  ``` 
7. Run the `$ emmc-usb.qml` script available in the demo package, using the following command.
    ```bash
    For Windows machine -> ..\..\..\sam-ba -x emmc-usb.qml
    For Linux machine -> ../../../sam-ba -x emmc-usb.qml
   ```   
8. Image downloading will be completed in one or two minitus in to SAMA5D2 Xplained eMMC flash.
9. Insert the WILC1000 SD board in connector SDMMC J19.
9. Once Flashing completed, reboot the board and to initialize the kernel and mount root files system.

## Bring up WiFi interface and WiFi Connection
1. After the target board boot up, root file system will be mounted.
2. Login in to target system using `$ root` as user name.
3. Target board root files system path `$/root/mchp/` folder contain the WILC1000 driver module.
2. In this `$/root/mchp` folder contains the WILC1000 driver module and tcp clinet python scripts.
4. WILC1000 firmware is loaded in file path, `$ /lib/firmwae/mchp/wilc1000_wifi_firmware.bin`
5. WILC1000 15.02 driver and firmware release version is used.
8. Shell script is loaded in the `$ /root/mchp/miwidemo.sh` folder.
9. Using the `$ vi` editor modify script for Router credentials.
10. Modify the SSID and router password psk as the router configuration.
11. Configure Router in WPA2-PSK security settings
     ```bash
      insmod /root/mchp/wilc-sdio.ko
      sleep 3
      wpa_supplicant -i wlan0 -D nl80211 -c /etc/wilc_wpa_supplicant.conf &
      sleep 2

      wpa_cli add_network 0
      wpa_cli -p /var/run/wpa_supplicant ap_scan 1
      wpa_cli set_network 0 ssid '"miwiwsn"'
      wpa_cli set_network 0 key_mgmt WPA-PSK
      wpa_cli set_network 0 psk '"12345678"'
      wpa_cli select_network 0 &
      sleep 5
      udhcpc -i wlan0 &
      sleep 5
      dmesg -n 1
      wpa_cli status      
     ```   
11. Run the `$ miwidemo.sh` script to connect with AccessPoint and obtain the IP address.
12. At the end of the script, WILC1000 will be connected to Router and show the status of the WiFi connection.

# AWS Cloud EC2 Instance Setup
We utilize EC2 (Amazon Elastic Compute Cloud) services for this demo. EC2 instance host the two TCP servers for MiWi network bridge and WSN monitor tool.

## AWS EC2 Instance
To host the python server, requires AMI Linux virtual machine. Amazon EC2 instance will provide the virtual Linux machine. The process is easy and straight forward once you have your AWS account ready.

- For a step by step guide please follow the amazon guide.
     - https://docs.aws.amazon.com/efs/latest/ug/gs-step-one-create-ec2-resources.html
- To run the python based TCP server, chose the "Amazon Linux AMI - 64-bit(x86)" free tier version for this demo.
- To access the server follow the Amazon user guide.
     - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html
  
 ## AWS EC2 Connection
 Once EC2 instace ready and running, modify the EC2 instance name as required like "miwi_wsn_demo". 
 
 - To connect with EC2 instance Virtual Linux machine, select connect.
    ![GitHub Logo](https://github.com/linux4wilc/wilc_demo/blob/master/wilc_sama5d2_xpro_miwi_bridge/Images/Connect_EC2.JPG)
 
 - EC2 instance connection credentials for Windows and Linux machine. 
     ![GitHub Logo](https://github.com/linux4wilc/wilc_demo/blob/master/wilc_sama5d2_xpro_miwi_bridge/Images/EC2_Connect_Procedure.png)
 
 - EC2 instance connection from Windows machine using PuTTY, procedures are mentioned AWS user guide. 
       - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html?icmpid=docs_ec2_console
  - EC2 instance connection from Linux machine using SSH follow the steps mentioned.
      - Private key file generated in the respective EC2 instance permission to be modified.
         ```bash
          chmod 400 miwi_wifi_demo.pem
         ```
      - Using SSH inLinux machine with private key file path and its Public DNS, connect to your instance.
         ```bash
          ssh -i "miwi_wifi_demo.pem" ec2-user@ec2-52-231-142-228.us-west-2.compute.amazonaws.com
         ```      
  - When connected to your EC2 instance login using `$ ec2-user` name.
  - After the login in EC2 console, copy the `$ miwi_wsn_server.py` python scripts file.
## Running TCP Server
When the EC2 instance console copied with `$ miwi_wsn_server.py` python scripts file run the python server scripts as mentioend.
         ```python
         python miwi_wsn_server.py &
         ```
 In this demo, only one MiWi bridge allowed to connect and multiple WSN monitor Tool allowed to connect remotely.
   ![GitHub Logo](https://github.com/linux4wilc/wilc_demo/blob/master/wilc_sama5d2_xpro_miwi_bridge/Images/TCP_Server_Start.png)
 
# MiWi Setup
For MiWi WSN Demo, minimum required Nos of SAMR30 XPRO boards are 5 for validating demo. As part of the demo package, MiWi demo images are loaded in `$ miwi_demo_images` folder. Flash the image in SAMR30 Xplained Pro boards and tag them with respective configuration.

## MiWi Network Configuration
- One board to be programmed with PAN-Coordinator image `$ SAMR30_MiWI_PAN_COORDINATOR.elf`.
- Two boards to be programmed as a router which is Router-1 `$ SAMR30_ROUTER_COORDINATOR_1.elf`and Router-2 `$ SAMR30_ROUTER_COORDINATOR_2.elf`.
- Two boards to be programmed as a enddevice which is EndDevice-1 `$SAMR30_WSN_ENDDEVICE_1.elf` and EndDevice-2 `$SAMR30_WSN_ENDDEVICE_2.elf`.
- Power up the Router and EndDevice boards by USB hub or directly connecting in to PC USB ports.
- PAN-Coordinator forms the MiWi network with Routers and EndDevices in the same channel.
- Connect the PAN-Coordinator device in to `$ SAMA5D2 A5-USB-B J13` connector.
- SAMR30 XPlained Pro board enumerates as `$ /dev/ttyACM0` COM port in SAMA5D2 Linux target board. 

# MiWi Clinet to Connection to EC2 Server
Before running the MiWi TCP clinet python script, EC2 instance TCP python server to be started as mentioned.
In the MiWi TCP clinet script file, `$ SERVER_IP` address to be modified  based on the EC2 instance public IP adddress.
EC2 instane public IP address available in the corresponding EC2 instance Description page.

  ![GitHub Logo](https://github.com/linux4wilc/wilc_demo/blob/master/wilc_sama5d2_xpro_miwi_bridge/Images/EC2_Instance_Public_IP_Address.JPG)

TCP port number `$ SERVER_MIWI_NW_CLIENT_PORT = 6666` is used in MiWi TCP clinet script. Using other than this port number is possible. In this case same port number to be modified in the `$ miwi_wsn_server.py` as well.

When the required modification is done in the MiWi clinet script, run the clinet script to connect with EC2 TCP server.
MiWi clinet will receive the MiWi WSN data from `$ /dev/ttyACM0` UART port and transfer to server.

## Running TCP Client
When SAMA5D2 target board with WILC1000 WiFi module connected with Accesspoint with internet gateway access, run the `$ miwi_wsn_clinet.py` script in target board console.
       ```python
       python miwi_wsn_client.py &
       ```
If EC2 TCP server stated already and running, TCP clinet connects sucessfully. MiWi WSN data from the MiWi PAN-Coordinator received in `$ /dev/ttyACM0` UART port and same will be transferred to EC2 TCP server. 

   ![GitHub Logo](https://github.com/linux4wilc/wilc_demo/blob/master/wilc_sama5d2_xpro_miwi_bridge/Images/TCP_Client_Start.png)

# WSN Monitor Tool
WSN Monitor tool is Microchip proprietary tool for 802.15.4 network monitor and contorl. In this tool, MiWi network connection with respective nodes will be displayed.
WSN Monitor toll also displayes the temperature, RSSI vlaue of the network nodes, and battery power notification.
To connect with EC2 server, EC2 instance public IP address is required. EC2 instance public IP address is available in EC2 instance page as mentioned above.
Port number for WSN monitor tool connection is `$ 8080` 
Once WSN Monitor tool connected, EC2 server will forward the packet which is received from MiWi clinet network.

  ![GitHub Logo](https://github.com/linux4wilc/wilc_demo/blob/master/wilc_sama5d2_xpro_miwi_bridge/Images/WSN_Monitor_Connection.JPG)

After the successful connection with EC2 server, WSN monitor starts receiving the MiWi network data's and displays.

  ![GitHub Logo](https://github.com/linux4wilc/wilc_demo/blob/master/wilc_sama5d2_xpro_miwi_bridge/Images/WSN_Network.png)

Using WSN Monitor tool, MiWi network LED's can be controlled. 

# Over All Demo Execution Procedure

1. Create the EC2 Instance in AWS Cloud using AWS account as mentioned.
2. Add the access to port numbers 6666 & 8080 for client connectivity.
3. Public IP address will provided by AWS IP pool.
4. Run the python script `$ python miwi_wsn_server.py`
5. Setup the SAMA5D2 + WILC1000 WiFi network and connect with router as mentioned.
6. Setup the MiWi network as much device required using SAMR30 XPlained Pro.
7. Connect the PAN-Coordinator to SAMA5D2 USB port.
8. Power up the other SAMR30 Router and EndDevices in same channel.
9. Run the `$ python miwi_network_client.py` with server parameters `$ 53:211:142:228:6666`
10. Start the WSN monitor tool with `$ 53:211:142:228:8080` connection parameters.
11. Now MiWi network topology will be displayed in WSN Monitor tool.
12. MiWi network device LEDs can be controlled from WSN monitor tool.





