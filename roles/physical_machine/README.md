# Physical Machine Role

This role applies the SEAPATH prerequisites for any physical machine (hypervisor, observer, or standalone) across all supported distributions.

## Requirements

- `detect_distribution` role must be run first to set `ansible_os_family`

## Role Variables

| Variable                       | Required  | Type        | Default | Comments                                                                                                                  |
|--------------------------------|-----------|-------------|---------|---------------------------------------------------------------------------------------------------------------------------|
| extra_sysctl_physical_machines | No        | String      |         | Custom systctl configuration separate by new spaces                                                                       |
| extra_kernel_modules           | No        | String list |         | List of Kernel modules to load when booting                                                                               |
| admin_user                     | Yes       | String      |         | Administrator Unix username                                                                                               |
| logstash_server_ip             | No        | String      |         | Address IP of the logstash server                                                                                         |
| pacemaker_shutdown_timeout     | No        | String      | 2min    | Custom timeout for stopping the systemd Pacemaker service. Time is in seconds, but support the min suffix to use minutes. |
| chrony_wait_timeout_sec        | No        | String      | 180     | Custom timeout for stopping the systemd Chrony service. Time is in seconds, but support the min suffix to use minutes.    |
| unbind_pci_address             | No        | String list |         | List of PCI addresses to "unbind".                                                                                        |

## Supported Distributions

- **RedHat**: CentOS, Red Hat Enterprise Linux, Oracle Linux, Fedora
- **Debian**: Debian, Ubuntu

## Example Playbook

```yaml
- hosts: cluster_machines
  roles:
    - detect_distribution
    - physical_machine
```

## Architecture

This role uses OS family-based task files for clean separation of distribution-specific logic:

- `common.yml`: Shared tasks across all distributions
- `RedHat.yml`: RedHat family specific tasks (CentOS + OracleLinux)
- `Debian.yml`: Debian family specific tasks

## Migration from Legacy Roles

This role consolidates the following legacy roles:
- `centos_physical_machine`
- `debian_physical_machine` 
- `oraclelinux_physical_machine`

The consolidation provides:
- **Reduced maintenance**: 3 roles → 1 role
- **Eliminated duplication**: ~80% of code was identical
- **Future-proof**: New RedHat distributions automatically supported
- **Consistent approach**: Uses `ansible_os_family` for distribution detection
