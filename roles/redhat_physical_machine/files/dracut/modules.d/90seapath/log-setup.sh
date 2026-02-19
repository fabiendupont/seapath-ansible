#!/bin/sh
# Copyright (C) 2025 Red Hat, Inc.
# SPDX-License-Identifier: Apache-2.0

# Enable kernel message logging for SEAPATH initramfs diagnostics.
# Dracut handles init output logging natively via the console and kmsg.
# This hook ensures /run/initramfs exists for the rebooter flag file.

mkdir -p /run/initramfs

exit 0
