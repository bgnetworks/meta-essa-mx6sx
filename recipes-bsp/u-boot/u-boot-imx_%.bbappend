FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# HAB Features
SRC_URI += "file://0001-Enable-secure-boot-support.patch"
SRC_URI += "file://0003-Enable-encrypted-boot-support.patch"

# Added to automate encryption with UUU tool
SRC_URI += "file://0004-Add-fastboot-commands.patch"

# Boot from QSPI controlled by "ESSA_BOOT_MEDIUM" env variable
# NOTE: This U-Boot won't work other than QSPI
SRC_URI += "${@bb.utils.contains('ESSA_BOOT_MEDIUM', 'QSPI', 'file://0002-Enable-QSPI-boot-support.patch', '', d)}"
