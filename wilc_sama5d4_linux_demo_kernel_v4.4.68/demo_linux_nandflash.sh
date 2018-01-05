#!/bin/sh
/usr/bin/sam-ba_cdc_linux/sam-ba /dev/ttyACM0 at91sama5d4x-ek demo_linux_nandflash.tcl 2>&1 | tee logfile.log
