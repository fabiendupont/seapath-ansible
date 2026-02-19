#!/bin/sh
# Copyright (C) 2025 Red Hat, Inc.
# SPDX-License-Identifier: Apache-2.0

# LVM snapshot rebooter: wait for any merging LV and reboot once done
# Use this to workaround GRUB limitation: it does not handle LV with merging snapshot

type info > /dev/null 2>&1 || . /lib/dracut-lib.sh

if [ ! -x "/sbin/lvm" ]; then
    warn "lvs executable not found"
    exit 1
fi

get_lv_snapshot_merging() {
    # This will print a list of "vg/lv" marked for merging
    /sbin/lvm lvs --select 'lv_merging!=0' --noheadings --separator '/' -o vg_name,lv_name
}

info "Starting LVM Snapshot rebooter"

# Wait for LVM elements to appear and be activated by udev
udevadm settle --timeout=10

lv_merging=$(get_lv_snapshot_merging)
if [ -n "$lv_merging" ] ; then
    for lv in $lv_merging; do
        info "  Merging $lv"
        /sbin/lvm lvchange --sysinit -ay "$lv"
        /sbin/lvm lvpoll --polloperation merge --interval 1 --config activation/monitoring=0 "$lv"
    done
    info "Snapshot merging complete, will reboot..."
    touch /run/initramfs/do_reboot
else
    info "No LVM snapshot need merging"
fi

exit 0
