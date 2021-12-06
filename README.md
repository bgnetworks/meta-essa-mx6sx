<!--
# File: README.md
# Author: Daniel Selvan, Jasmin Infotech
# Copyright (c) 2021 BG Networks, Inc.
#
# See LICENSE file for license details.
-->

# meta-bgn-essa

[BG Network's](https://bgnet.works/) [Embedded Security Software Architecture](https://bgnet.works/embedded-security-software-architecture/) (ESSA), a collection of scripts, recipes, configurations, and documentation for Linux, enhances cybersecurity for IoT devices, including secure boot, encryption, authentication, and secure software updates. The ESSA enables engineers to extend a hardware root of trust to secure U-Boot, the Linux kernel, and applications in the root file system.

This repository is based on [imx-manifest](https://source.codeaurora.org/external/imx/imx-manifest/tree/?h=imx-linux-hardknott) (_5.10.52 release_) and enables NXP's HAB features on NXP's [i.MX 6 SoloX SABRE](https://www.nxp.com/document/guide/getting-started-with-i-mx-6-solox-sabre:GS-RD-IMX6SX-SABRE) hardware.

## Supported Board

The following board is the only board tested in this release.

- NXP's i.<d/>MX 6 SoloX SABRE (imx6sxsabresd) - [i.MX 6 SoloX SABRE](https://www.nxp.com/design/development-boards/i-mx-evaluation-and-development-boards/sabre-board-for-smart-devices-based-on-the-i-mx-6solox-applications-processors:RD-IMX6SX-SABRE)

## Quick Start Guide

See the Quick Start Guide for instructions on installing repo.

#### 1. Install the WinSystems Linux BSP & BGN-ESSA repo

```bash
repo init -u git://source.codeaurora.org/external/imx/imx-manifest.git -b imx-linux-hardknott -m imx-5.10.52-2.1.0.xml
wget --directory-prefix .repo/manifests https://raw.githubusercontent.com/danie007/meta-essa-mx6sx/hardknott/scripts/imx-5.10.52-2.1.0-bgn-essa.xml
repo init -m imx-5.10.52-2.1.0-bgn-essa.xml
repo sync -j$(nproc)
```

**NOTE**: _Use_ `mx6sx-setup-essa.sh` _script for initialization._

#### 2. Build

_NOTE_: This integration is tested for `imx-image-multimedia` and `core-image-base`

```bash
MACHINE=imx6sxsabresd DISTRO=fsl-imx-fb source mx6sx-setup-essa.sh -b build
bitbake imx-image-multimedia
```

**imx-image-multimedia**: "Builds an i.<d/>MX image with a GUI without any Qt content."

- Use the **core-image-base** (_A console-only image that fully supports the target device hardware._) for testing purpose. It'll take minimal space and faster to build.

## Detailed Guide

To download a detailed guide to BG Networks ESSA click [here](https://bgnet.works/download-essa-user-guide/).

## Contributing

To contribute to the development of this BSP and/or submit patches for new boards please feel free to [create pull requests](https://github.com/bgnetworks/meta-bgn-essa/pulls).

## Maintainer(s)

The author(s) and maintainer(s) of this layer is(are):

- Daniel Selvan D - <daniel.selvan@jasmin-infotech.com> - [danie007](https://github.com/danie007)
