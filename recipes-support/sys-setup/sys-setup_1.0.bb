SUMMARY = "system initial setup script"
LICENSE = "CLOSED"

SRC_URI = "file://sys_setup.sh"
SRC_URI += "file://zsend.sh"
SRC_URI += "file://disk_benchmark.sh"

RDEPENDS_${PN} += "bash"

do_install() {
    # Installing the setup script in /data
    install -d ${D}/data
    install -d ${D}/dmblk
    install -d ${D}/home/root

    install -m 0755 ${WORKDIR}/sys_setup.sh ${D}/data/
    install -m 0755 ${WORKDIR}/zsend.sh ${D}/home/root/
    install -m 0755 ${WORKDIR}/disk_benchmark.sh ${D}/home/root/
}

FILES_${PN} += "/data/sys_setup.sh"
FILES_${PN} += "/home/root/zsend.sh"
FILES_${PN} += "/home/root/disk_benchmark.sh"
FILES_${PN} += "/dmblk/"
