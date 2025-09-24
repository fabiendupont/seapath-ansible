# System Hardening Role

This role implements comprehensive system hardening based on the ANSSI BP-28 baseline security requirements. It consolidates the functionality of `debian_hardening` and `debian_hardening_physical_machine` roles while extending support to RedHat family distributions using OpenSCAP profiles.

## Features

### Cross-Platform Support
- **Debian/Ubuntu**: Uses existing ANSSI BP-28 implementation with kernel parameters, sysctl settings, and PAM configuration
- **RedHat/CentOS/OracleLinux**: Uses OpenSCAP SCAP Security Guide profiles for ANSSI BP-28 compliance

### Security Hardening Areas
- **Kernel Security**: Memory protection, stack randomization, SMEP/SMAP
- **Network Security**: Firewall configuration, network hardening
- **Authentication**: SSH hardening, sudo configuration, PAM settings
- **System Services**: Systemd service hardening, auditd configuration
- **Boot Security**: GRUB password protection, secure boot settings
- **Access Control**: Privileged group management, securetty configuration

## Requirements

### Debian/Ubuntu
- Standard system packages
- `auditd` for audit logging

### RedHat Family
- `openscap-scanner` package
- `scap-security-guide` package
- `python3-lxml` package

## Role Variables

### Core Configuration
```yaml
# Hardening control
revert: false  # Set to true to revert hardening changes

# GRUB password protection
grub_password: "your_secure_password"  # Optional

# OpenSCAP profile (RedHat only)
openscap_profile: "anssi_bp28_high"
```

### Kernel Parameters (Debian/Ubuntu)
```yaml
hardening_kernel_params:
  - init_on_alloc=1
  - init_on_free=1
  - slab_nomerge
  - pti=on
  - slub_debug=ZF
  - randomize_kstack_offset=on
  - slab_common.usercopy_fallback=N
  - iommu=pt
  - security=yama
  - mce=0
  - rng_core.default_quality=500
  - lsm=apparmor,lockdown,capability,landlock,yama,bpf,integrity
```

### Systemd Services to Harden
```yaml
hardened_services:
  - syslog-ng
  - ovs-vswitchd
  - ovsdb-server
  - corosync
  - pacemaker
  - ceph-crash
```

### RedHat-Specific Options
```yaml
enable_selinux: true      # Enable SELinux hardening
enable_firewalld: true    # Configure firewalld
enable_auditd: true       # Configure auditd
```

## Dependencies

- `system_base` role (for basic system configuration)

## Example Playbook

```yaml
---
- hosts: all
  become: yes
  roles:
    - system_base
    - system_hardening
  vars:
    grub_password: "{{ vault_grub_password }}"
    hardened_services:
      - syslog-ng
      - corosync
      - pacemaker
```

## Reverting Hardening

To revert hardening changes:

```yaml
---
- hosts: all
  become: yes
  roles:
    - system_hardening
  vars:
    revert: true
```

## ANSSI BP-28 Compliance

This role implements the ANSSI BP-28 baseline security requirements:

- **R1**: System hardening and configuration
- **R2**: Network security
- **R3**: Authentication and access control
- **R4**: Audit and monitoring
- **R5**: System integrity

## OpenSCAP Integration (RedHat)

For RedHat family distributions, the role uses OpenSCAP to apply ANSSI BP-28 hardening:

1. Installs required OpenSCAP packages
2. Generates remediation script from SCAP Security Guide
3. Applies hardening rules automatically
4. Configures SELinux and firewalld if available

## Files and Templates

- `anssi_bp28_hardening.sh.j2`: OpenSCAP hardening script template
- `ssh-audit_hardening.conf.j2`: SSH hardening configuration
- `01_password.j2`: GRUB password configuration
- Various hardening configuration files in `files/` directory

## License

Apache-2.0
