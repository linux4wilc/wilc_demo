import SAMBA 3.2
import SAMBA.Connection.Serial 3.2
import SAMBA.Device.SAMA5D4 3.2

SerialConnection {

	device: SAMA5D4Xplained {
		config {
			nandflash {
				header: 0xc1e04e07
			}
		}
	}

	function initNand() {
		/* Placeholder: Nothing to do */
	}

	function getEraseSize(size) {
		/* get smallest erase block size supported by applet */
		var eraseSize
		for (var i = 0; i <= 32; i++) {
			eraseSize = 1 << i
			if ((applet.eraseSupport & eraseSize) !== 0)
				break;
		}
		eraseSize *= applet.pageSize

		/* round up file size to erase block size */
		return (size + eraseSize - 1) & ~(eraseSize - 1)
	}

	function eraseWrite(offset, filename, bootfile) {
		/* get file size */
		var file = File.open(filename, false)
		var size = file.size()
		file.close()

		applet.erase(offset, getEraseSize(size))
		applet.write(offset, filename, bootfile)
	}

	onConnectionOpened: {

		var itbFileName = "sama5d4_xplained.itb"
		var ubootEnvFileName = "uboot-env.bin"

		// initialize Low-Level applet
		print("-I- === Initilize low level (system clocks) ===")
		initializeApplet("lowlevel")

		// intialize extram applet (needed for sam9)
		print("-I- === Initialize extram ===")
		initializeApplet("extram")

		print("-I- === Initialize nandflash access ===")
		initializeApplet("nandflash")

		// erase then write files
		print("-I- === Load AT91Bootstrap ===")
		eraseWrite(0x00000000, "sama5d4_xplained-nandflashboot-uboot-3.8.8.bin", true)

		print("-I- === Load u-boot environment ===")
		//erase redundant env to be in a clean and known state
		applet.erase(0x00100000, getEraseSize(0x20000))
		eraseWrite(0x00140000, ubootEnvFileName)

		print("-I- === Load u-boot ===")
		eraseWrite(0x00040000, "u-boot.bin")

		print("-I- === Load ITB image ===")
		eraseWrite(0x00180000, itbFileName)

		print("-I- === Load root file-system image ===")
		applet.erase(0x00800000, applet.memorySize - 0x00800000)
		applet.write(0x00800000, "rootfs.ubi")

		print("-I- === Done. ===")
	}
}
