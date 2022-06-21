FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Fix for CAAM RNG (based on lore.kernel.org/lkml/YSy%2FPFrem+a7npBy@gmail.com)
SRC_URI += "file://0001-Fix-CAAM-RNG.patch"

# Dm-crypt fragment for 5.10 kernel
SRC_URI += "file://0001-device-mapper-and-crypt-target.cfg"
SRC_URI += "file://0002-caam-black-key-driver.cfg"
SRC_URI += "file://0003-cryptographic-API-functions.cfg"

do_configure:append() {
    cat ../*.cfg >>${B}/.config
}
