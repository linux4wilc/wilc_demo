sudo ../../../sam-ba -p usb -b sama5d2-xplained -a bootconfig -c writecfg:bscr:valid,bureg0

sleep 2

sudo ../../../sam-ba -p usb -b sama5d2-xplained -a bootconfig -c writecfg:bureg0:ext_mem_boot,sdmmc1_disabled,sdmmc0,spi1_disabled,spi0_disabled,qspi1_disabled,qspi0_disabled
