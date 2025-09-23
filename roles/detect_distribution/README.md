# Detect Distribution Role

This role detects the distribution using Ansible's built-in `ansible_os_family` fact.

## Supported Distributions

- **RedHat**: CentOS, Red Hat Enterprise Linux, Oracle Linux, Fedora
- **Debian**: Debian, Ubuntu
- **Yocto**: OpenEmbedded-based systems (detected via CPE_NAME in /etc/os-release)

## Requirements

No requirements.

## Role Variables

No variables.

## Example Playbook

```yaml
- hosts: cluster_machines
  roles:
    - detect_distribution
```

## Facts Set

- `ansible_os_family`: Standard Ansible fact (RedHat, Debian, Yocto)
- `is_using_cephadm`: Boolean indicating if cephadm should be used

## Migration from Legacy Detection

This role replaces the legacy distribution detection with a more modern approach:

1. Uses standard Ansible facts instead of custom detection
2. Groups RedHat-based distributions (CentOS, OracleLinux, RHEL) together
3. Simplified Yocto detection using direct `/etc/os-release` reading
4. Uses standard Ansible facts throughout the codebase
