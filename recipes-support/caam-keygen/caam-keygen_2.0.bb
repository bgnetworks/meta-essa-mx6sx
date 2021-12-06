# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# Created by Daniel Selvan, Jasmin Infotech
#

SUMMARY = "User space application used to generate black keys and blobs and copy it to the device"
DESCRIPTION = "Create Random AES key (CAAM-TK) and encrypts that with OTPMK (blob). \
			   It can also be used to decrypt the CAAM-TK blob. \
			   "
HOMEPAGE = "https://source.codeaurora.org/external/imx/keyctl_caam/tree/?h=lf-5.10.y_2.0.0"

LICENSE = "CLOSED"
LIC_FILES_CHKSUM = "file://COPYING;md5=8636bd68fc00cc6a3809b7b58b45f982"

SRC_BRANCH = "lf-5.10.y_2.0.0"
LOCALVERSION = "-2.0.0"
PACKAGE_SRC = "git://source.codeaurora.org/external/imx/keyctl_caam.git;protocol=https"
SRC_URI = "${PACKAGE_SRC};branch=${SRC_BRANCH}"

# As on Oct 22 21
SRCREV = "6b80882e3d5bc986a1f2f9512845170658ba9ea2"

S = "${WORKDIR}/git"

TARGET_CC_ARCH += "${LDFLAGS}"

do_compile () {
	oe_runmake
}

do_install () {
	oe_runmake DESTDIR=${D} install
}