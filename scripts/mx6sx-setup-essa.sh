#!/bin/bash
# BGN-ESSA Setup Script
#
# Authored-by:  Daniel Selvan (daniel.selvan@jasmin-infotech.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# Copyright (c) 2021 BG Networks, Inc.

. imx-setup-release.sh $@

if [ $? -ne 0 ]; then
    echo "imx setup script failed."
else
    echo "" >>conf/bblayers.conf

    # Adding extra layer (meta-essa-mx6sx)
    echo "# Custom layer to add HAB & DM-Crypt features" >>conf/bblayers.conf
    echo "BBLAYERS += \" \${BSPDIR}/sources/meta-essa-mx6sx \"" >>conf/bblayers.conf
    echo "" >>conf/bblayers.conf

    # Adding personalized configuration
    cat ../sources/meta-essa-mx6sx/templates/local.conf.append >>conf/local.conf

    if [ $? -ne 0 ]; then
        echo "Failed to append layers, try manually editing local.conf & bblayers.conf"
    else
        echo "BGN-ESSA Setup completed successfully"
    fi
fi
