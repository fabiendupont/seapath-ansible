# System Hardening Role

This role implements comprehensive system hardening based on the ANSSI BP-28 baseline security requirements. It consolidates the functionality of `debian_hardening` and `debian_hardening_physical_machine` roles using a unified OpenSCAP-based approach for all supported distributions.

## Features

### Unified OpenSCAP Approach
- **All Distributions**: Uses OpenSCAP SCAP Security Guide profiles for ANSSI BP-28 compliance
- **Debian/Ubuntu**: Uses `ssg-debian` packages with Debian-specific datastreams
- **RedHat/CentOS/OracleLinux**: Uses `scap-security-guide` packages with RHEL/CentOS/OracleLinux datastreams
- **Yocto**: Uses `meta-security-compliance` layer with OpenSCAP for build-time and runtime hardening

### Security Hardening Areas
- **Kernel Security**: Memory protection, stack randomization, SMEP/SMAP
- **Network Security**: Firewall configuration, network hardening
- **Authentication**: SSH hardening, sudo configuration, PAM settings
- **System Services**: Systemd service hardening, auditd configuration
- **Boot Security**: GRUB password protection, secure boot settings
- **Access Control**: Privileged group management, securetty configuration

## Requirements

### Ansible Galaxy Dependencies
- Install all dependencies: `./prepare.sh` (installs from `ansible-requirements.yaml`)
- Or install specific Red Hat ANSSI BP-28 roles:
  - RHEL8: `ansible-galaxy install RedHatOfficial.rhel8_anssi_bp28_high`
  - RHEL9: `ansible-galaxy install RedHatOfficial.rhel9_anssi_bp28_high`
  - RHEL10: `ansible-galaxy install RedHatOfficial.rhel10_anssi_bp28_high` (when available)

### Debian/Ubuntu
- `openscap-scanner` package
- `ssg-base`, `ssg-debderived`, `ssg-debian`, `ssg-nondebian`, `ssg-applications` packages

### RedHat Family (RHEL8 and earlier)
- `openscap-scanner` package
- `scap-security-guide` package
- `python3-lxml` package

### RHEL9
- Uses Red Hat's official role (no additional packages required)

### Yocto
- `openscap` package (from meta-security-compliance layer)
- `scap-security-guide` package (from meta-security-compliance layer)
- Requires `meta-security-compliance` layer integration in Yocto build

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

## Installation and Setup

### 1. Install Dependencies
```bash
# Install all required roles and collections
./prepare.sh

# Or install specific roles as needed
ansible-galaxy install RedHatOfficial.rhel9_anssi_bp28_high
```

### 2. Example Playbook
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

## OpenSCAP Integration

The role uses native Ansible tasks to orchestrate OpenSCAP ANSSI BP-28 hardening:

1. **Package Installation**: Installs distribution-specific OpenSCAP packages
2. **Datastream Validation**: Checks for available SCAP datastreams with fallback support
3. **Compliance Assessment**: Performs pre-hardening compliance scan
4. **Ansible Playbook Generation**: Creates native Ansible remediation playbook using `--fix-type ansible`
5. **Playbook Execution**: Runs the generated Ansible playbook for remediation
6. **Post-Verification**: Re-scans system to verify compliance
7. **Distribution-Specific Features**: Configures additional security features

### Hybrid Approach with Red Hat's ANSSI BP-28 Role

This role uses a **hybrid approach** that leverages the best of both worlds:

**For supported RHEL systems:**
- Uses Red Hat's official ANSSI BP-28 High roles declared as dependencies in `meta/main.yml`
- RHEL8: `RedHatOfficial.rhel8_anssi_bp28_high`
- RHEL9: `RedHatOfficial.rhel9_anssi_bp28_high`
- Pre-generated, well-tested, and officially supported
- Automatically installed via `./prepare.sh`
- **Always uses official Red Hat roles - no fallback to custom OpenSCAP**
- **Plus SEAPATH-specific hardening** (services, security features)

**For other distributions (Debian, Yocto):**
- Uses our custom OpenSCAP-based hardening
- **Plus SEAPATH-specific hardening** (services, security features)
- **Plus generic hardening** (password policies, auditd, PAM, sysctl)
- Dynamic generation at runtime
- Multi-distribution support
- Assessment-only mode available
- **Note:** Unsupported RHEL versions (RHEL7, RHEL10+) are caught by `detect_distribution` role and fail early

**Benefits of this hybrid approach:**
- **RHEL8/9**: Leverages Red Hat's official, battle-tested implementation + SEAPATH hardening
- **Other distros**: Custom OpenSCAP + SEAPATH hardening + Generic hardening
- **Consistency**: Same ANSSI BP-28 High profile across all distributions
- **Maintenance**: Red Hat maintains RHEL hardening, we maintain others
- **Clean Dependencies**: No runtime role detection needed
- **Separation of Concerns**: OVS hardening moved to `openvswitch` role

### OpenSCAP Ansible Playbook Generation

OpenSCAP can generate native Ansible playbooks using:
```bash
oscap xccdf generate fix --fix-type ansible --profile anssi_bp28_enhanced --output remediation.yml datastream.xml
```

This generates a proper Ansible playbook with tasks like:
```yaml
- name: Set permissions on /etc/passwd
  ansible.builtin.file:
    path: /etc/passwd
    mode: '0644'
    state: file
```

## Yocto Integration with meta-security-compliance

For Yocto-based systems, the role supports both build-time and runtime hardening approaches:

### Build-Time Hardening (Recommended)
1. **Add meta-security-compliance layer** to your Yocto build:
   ```bash
   # In your bblayers.conf
   BBLAYERS += "${BSPDIR}/sources/meta-security-compliance"
   ```

2. **Include OpenSCAP packages** in your image:
   ```bash
   # In your local.conf
   IMAGE_INSTALL_append = " openscap scap-security-guide"
   ```

3. **Pre-harden during build** - The meta-security-compliance layer can apply ANSSI BP-28 remediations during the build process, resulting in a pre-hardened image.

### Runtime Hardening
- The role will detect if OpenSCAP is available and apply runtime remediations
- If meta-security-compliance wasn't used during build, the role provides guidance on adding it
- Basic security features (iptables firewall) are configured regardless

### Benefits of Build-Time Hardening
- **Security from first boot**: System is hardened before deployment
- **Reduced attack surface**: No need for post-deployment hardening
- **Compliance assurance**: ANSSI BP-28 compliance is built into the image
- **Performance**: No runtime overhead for hardening operations

## Files and Templates

### Task Files
- `tasks/main.yml`: Main orchestration logic
- `tasks/seapath_hardening.yml`: SEAPATH-specific hardening (always applied)
- `tasks/generic_hardening.yml`: Generic hardening (non-RedHat only)
- `tasks/openscap_hardening.yml`: Custom OpenSCAP hardening
- `tasks/assessment_only.yml`: Compliance assessment without remediation
- `tasks/apply_remediation.yml`: Apply generated OpenSCAP remediation

### Configuration Files
- `files/ceph-crash_hardening.conf`: Ceph crash service hardening
- `files/corosync_hardening.conf`: Corosync service hardening
- `files/pacemaker_hardening.conf`: Pacemaker service hardening
- `files/syslog-ng_hardening.conf`: Syslog-ng service hardening
- `files/random-root-passwd.service`: Random root password service
- `files/mktmpdir.sh`: Private TMPDIR configuration
- `files/terminal_idle.sh`: Terminal idle timeout configuration
- `files/sudoers/cockpit`: Cockpit sudo rules
- `files/auditd/`: Auditd configuration (non-RedHat only)
- `files/sysctl/`: Sysctl hardening (non-RedHat only)
- `files/default_pam_su*`: PAM configuration files (non-RedHat only)

### Note on OVS Hardening
- **OVS hardening moved to `openvswitch` role**: `ovs-vswitchd_hardening.conf` and `ovsdb-server_hardening.conf` are now handled by the `openvswitch` role for proper separation of concerns.

## Native Ansible Implementation

The role uses native Ansible tasks instead of shell scripts for better:
- **Idempotency**: Tasks are naturally idempotent
- **Error Handling**: Better error reporting and recovery
- **Debugging**: Clear task names and structured output
- **Maintainability**: Easier to modify and extend
- **Integration**: Better integration with Ansible's reporting and logging

## License

Apache-2.0
