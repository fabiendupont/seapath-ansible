#!/bin/sh
# Copyright (C) 2025 Red Hat, Inc.
# SPDX-License-Identifier: Apache-2.0

type info > /dev/null 2>&1 || . /lib/dracut-lib.sh

# Get REBOOTER_LOG_DEVICE and REBOOTER_LOG_PATH from config
# Default to SEAPATH default (a dedicated LV called vg1-varlog)
REBOOTER_LOG_DEVICE=/dev/mapper/vg1-varlog
REBOOTER_LOG_PATH=.
if [ -e /etc/rebooter.conf ]; then
    . /etc/rebooter.conf
fi

info "Rebooter starting"
if [ -e /run/initramfs/do_reboot ]; then
    info "Rebooting..."
    MOUNT_POINT="/run/mnt"
    mkdir -p $MOUNT_POINT
    mount -o sync,rw $REBOOTER_LOG_DEVICE $MOUNT_POINT
    LOG_PATH="$MOUNT_POINT/$REBOOTER_LOG_PATH/initramfs.log"
    echo "== $(date) ==" >> $LOG_PATH
    dmesg >> $LOG_PATH
    echo >> $LOG_PATH
    umount $MOUNT_POINT
    reboot -f
else
    info "No reboot needed"
fi

exit 0
