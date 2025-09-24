# Virtualization Libvirt Role

This role manages libvirt service and basic hypervisor configuration for all distributions.

## Requirements

No requirements.

## Role Variables

This role currently has no configurable variables. It performs:
- Enables libvirtd service
- Configures libvirt-guests shutdown timeout (Debian only)
- Creates QEMU system alternatives (RedHat only)

## Example Playbook

```yaml
- hosts: cluster_machines
  roles:
    - virtualization_libvirt
```

## Note

This role consolidates libvirt service management and basic hypervisor configuration from the distribution-specific hypervisor roles.
