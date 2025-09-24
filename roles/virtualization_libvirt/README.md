# Virtualization Libvirt Role

This role manages libvirt service, configuration, and virtualization infrastructure for all distributions.

## Requirements

No requirements.

## Role Variables

All variables are optional.

| Variable | Type | Default | Comments |
|----------|------|---------|----------|
| `sriov_network_pool_name` | String | "" | Name of the libvirt SR-IOV pool |
| `sriov_interface` | String | "" | Network interface to use for SR-IOV setup |
| `libvirt_rbd_pool` | String | "rbd" | The Ceph RBD pool used by libvirt |
| `libvirt_pool_name` | String | "ceph" | The name of the libvirt storage pool to create |

## Features

This role performs:
- Enables libvirtd service
- Configures libvirt-guests shutdown timeout (Debian only)
- Creates QEMU system alternatives (RedHat only)
- Manages libvirt configuration (`libvirtd.conf`)
- Creates Ceph RBD secrets for libvirt
- Manages libvirt services (virtsecretd, virtqemud, virtstoraged)
- Creates SR-IOV network pools

## Example Playbook

```yaml
- hosts: cluster_machines
  roles:
    - virtualization_libvirt
```

## Note

This role consolidates libvirt service management, configuration, and virtualization infrastructure from multiple roles:
- `centos_hypervisor` and `debian_hypervisor` (basic setup)
- `configure_libvirt` (Ceph integration, secrets, configuration)
- `network_sriovpool` (SR-IOV network pools)
