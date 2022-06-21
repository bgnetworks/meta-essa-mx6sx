<!--
# File: README.md
# Author: [Saravanan, Daniel Selvan], Jasmin Infotech
# Copyright (c) 2022 BG Networks, Inc.
#
# See LICENSE file for license details.
-->

<p align="center">
    <img src="docs/assets/BGN_logo.png" alt="BGN_logo" />
</p>

# meta-essa-mx6sx

[BG Network's](https://bgnet.works/) [Embedded Security Software Architecture](https://bgnet.works/bgn-essa/) (ESSA), a collection of scripts, recipes, configurations, and documentation for Linux, enhances cybersecurity for IoT devices, including secure boot, encryption and/or authentication. The ESSA enables engineers to extend a hardware root of trust to secure U-Boot, the Linux kernel, and applications in the root file system.

To provide strong cybersecurity without compromising performance or functionality, this architecture leverages:

- In-silicon cryptographic accelerators and secure memory
- Linux security features

The ESSA is Linux based and when used in conjunction with the SAT will support:

- Hardware root of trust extended to the rootfs and software application layer Configuration of Linux Device Mapper (DM) cryptographic functions.
- Use of AES-XTS and HMAC-SHA256 cryptographic algorithms.
- Root of trust extended to Linux userspace.

## Supported Board

The following board is the only board tested in this release.

- NXP's i.<d/>MX 6 SoloX SABRE (imx6sxsabresd) - [i.MX 6 SoloX SABRE](https://www.nxp.com/design/development-boards/i-mx-evaluation-and-development-boards/sabre-board-for-smart-devices-based-on-the-i-mx-6solox-applications-processors:RD-IMX6SX-SABRE)

## Quick Start Guide

See the [Quick Start Guide](docs/Quick_Start_Guide.md) for instructions of building core image and for a quick demo of **DM-Crypt with CAAM's black key**.

## Detailed Guide

To know more about the [BG Networks ESSA](https://bgnet.works/bgn-essa) and its potential capabilities, [contact BG Networks](https://bgnet.works/contact-us).

## Contributing

To contribute to the development of this BSP and/or submit patches for new boards please feel free to [create pull requests](https://github.com/bgnetworks/meta-essa-mx6sx/pulls).

## Maintainer(s)

The author(s) and maintainer(s) of this layer is(are):

- Daniel Selvan D - <daniel.selvan@jasmin-infotech.com> - [danie007](https://github.com/danie007)
