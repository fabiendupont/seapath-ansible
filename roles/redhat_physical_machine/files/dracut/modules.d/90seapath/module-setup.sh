#!/bin/bash
# Copyright (C) 2025 Red Hat, Inc.
# SPDX-License-Identifier: Apache-2.0

# SEAPATH dracut module: LVM snapshot reboot handling and log collection

check() {
    return 0
}

depends() {
    echo lvm
}

install() {
    inst_hook pre-mount 99 "$moddir/lvm-snapshot-rebooter.sh"
    inst_hook cleanup 99 "$moddir/rebooter.sh"
    inst_hook cmdline 01 "$moddir/log-setup.sh"
    inst_simple /etc/dracut.conf.d/rebooter.conf /etc/rebooter.conf
}
