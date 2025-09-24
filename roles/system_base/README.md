# system_base Role

This role applies the basic SEAPATH prerequisites for any Linux machine, consolidating the functionality previously provided by the separate `centos`, `debian`, and `oraclelinux` roles.

## Requirements

- `detect_distribution` role must be run first to set `ansible_os_family`

## Role Variables

| Variable             | Required | Type        | Comments                                                           |
|----------------------|----------|-------------|--------------------------------------------------------------------|
| syslog_tls_ca        | No       | String      | Syslog TLS public key                                              |
| syslog_tls_key       | No       | String      | Syslog TLS private key                                             |
| syslog_tls_server_ca | No       | String      | Syslog TLS CA                                                      |
| admin_user           | Yes      | String      | User to use for administration                                     |
| admin_passwd         | No       | String      | Optional user password                                             |
| admin_ssh_keys       | No       | String list | List of SSH public keys used to connect to the administration user |
| grub_append          | No       | String list | List of extra kernel parameters                                    |
| syslog_server_ip     | No       | String      | IP address of the Syslog server to send logs                       |
| apt_repo             | No       | String list | List of apt repositories (Debian only)                             |

## Supported Distributions

- **RedHat**: CentOS, Red Hat Enterprise Linux, Oracle Linux, Fedora
- **Debian**: Debian, Ubuntu

## Example Playbook

```yaml
- hosts: cluster_machines
  roles:
    - detect_distribution
    - system_base
```

## What This Role Does

### Common Tasks (All Distributions)
- Creates admin user with sudo privileges
- Configures syslog-ng with TLS support
- Sets up journald configuration
- Configures environment variables
- Sets up sysctl parameters

### RedHat-Specific Tasks
- Configures vim settings
- Sets up GRUB with specific kernel parameters
- Manages NetworkManager/systemd-networkd
- Disables firewalld on OracleLinux

### Debian-Specific Tasks
- Configures vim settings (Debian path)
- Manages APT repositories
- Handles GRUB configuration with quiet parameter removal
- Configures SSH settings for specific releases

## Migration from Legacy Roles

This role consolidates the following legacy roles:
- `centos`
- `debian`
- `oraclelinux`

The consolidation provides:
- **Reduced maintenance**: 3 roles → 1 role
- **Eliminated duplication**: ~80% of code was identical
- **Future-proof**: New distributions automatically supported
- **Consistent approach**: Uses `ansible_os_family` for distribution detection
