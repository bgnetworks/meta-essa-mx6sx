#!/bin/bash
#
# sys_setup.sh
# Configure system for the first time
#
# 15.07.2021
# Daniel Selvan, Jasmin Infotech

###################################################################################################

#           Configuring Crypt block

###################################################################################################

s_utility="/usr/sbin/cryptsetup"
PASSPHRASE="This isn't a very secure passphrase."
s_block="/dev/mmcblk1p3" # Update as needed
d_key="/data/decrypt.key"
mpoint="/dmblk"
cipher="aes-xts-plain64"
# cipher="aes-cbc-essiv:sha256"

[ -e $s_block ] && {

    # (Optional) unmounting & closing the encrypted block
    umount $mpoint
    $s_utility close crypt_target

    # not format the device, but sets up the LUKS device header and
    # encrypts the master-key with the desired cryptographic options
    # Passing another argument to read the passphrase from standard input (using -)
    echo -n "$PASSPHRASE" | $s_utility luksFormat $s_block -c $cipher -

    # Entering existing password to open enc partition
    # Open encrypted partition for writing
    echo -n "$PASSPHRASE" | $s_utility luksOpen $s_block crypt_target -
    mkfs.ext4 -b 4096 /dev/mapper/crypt_target # Creating ext4 filesystem in encrypted block
    mkdir -p $mpoint                           # Make sure mount point exists
    mount /dev/mapper/crypt_target $mpoint     # Mounting encrypted home dir

    rm -f $d_key 2>/dev/null # Deleting old key, if present

    CAAM_RNG="/dev/hwrng"
    # Creating a key file, use CAAM TRNG if present
    dd bs=512 count=4 if=$([ -f "$CAAM_RNG" ] && echo "$CAAM_RNG" || echo "/dev/urandom") of=$d_key iflag=fullblock

    # Deny any access for other users than root(read only)
    chmod 400 $d_key

    # Adding luks Key file to the block
    echo -n "$PASSPHRASE" | $s_utility luksAddKey $s_block $d_key -

    # Removing luks passphrase used to create the block
    echo -n "$PASSPHRASE" | $s_utility luksRemoveKey $s_block -

    # decrypting with key file
    $s_utility luksOpen -d $d_key $s_block crypt_target

    echo Creating auto mount service

    cat >/usr/crypt_target.sh <<EOF
#!/bin/bash
# mounting encrypted home dir
$s_utility luksOpen -d $d_key $s_block crypt_target
mkdir -p $mpoint
/bin/mount /dev/mapper/crypt_target $mpoint
EOF

    # Deny access for others
    chmod 500 /usr/crypt_target.sh

    cat >/etc/systemd/system/crypt-target.service <<EOF
[Unit]
Description=Encrypted directory mount script
DefaultDependencies=no
Conflicts=shutdown.target
After=local-fs.target
OnFailure=emergency.target
OnFailureJobMode=replace-irreversibly
Before=rc-local.service
[Service]
Type=oneshot
ExecStart=/usr/crypt_target.sh
TimeoutStartSec=90
[Install]
WantedBy=default.target
RequiredBy=rc-local.service systemd-logind.service
EOF

    # Deny access for others (Read Only)
    chmod 644 /etc/systemd/system/crypt-target.service

    echo Enabling auto mount service
    systemctl daemon-reload
    systemctl enable crypt-target.service

    # Service status check
    # systemctl status crypt-target
    ###################################################################################################
} || echo Proceeding without creating authenticated home

shutdown -r +1 "System will restart in 1 minute, save your work ASAP"
