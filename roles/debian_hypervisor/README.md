# Debian Hypervisor Role

This role applies hypervisor-specific virtualization configurations for Debian machines. CPU isolation and real-time tuning have been moved to the `system_tuning` role.

## Requirements

No requirement.

## Role Variables

This role currently has no configurable variables. It performs basic virtualization setup:
- Configures libvirt-guests shutdown timeout

## Example Playbook

```yaml
- hosts: cluster_machines
  roles:
    - { role: seapath_ansible.debian_hypervisor }
```

## Note

CPU isolation, real-time tuning, and performance optimization tasks have been moved to the `system_tuning` role for better organization and reusability across distributions.
