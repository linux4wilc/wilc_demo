## Files to load
set bootstrapFile       "sama5d4_xplained-nandflashboot-uboot-3.7.bin"
set ubootFile           "u-boot-sama5d4_xplained_nandflash.bin"
set kernelFile          "zImage"
set rootfsFile          "rootfs.ubi"

## board variant
set boardFamily "at91-sama5d4"
set board_suffix "_xplained"

## dtb option
set use_dtb "yes"

## uboot env option
set build_uboot_env "yes"

## now call common script
source demo_script_linux_nandflash.tcl
