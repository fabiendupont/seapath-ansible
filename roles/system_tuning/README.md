# System Tuning Role

This role handles system performance tuning and optimization tasks, including CPU isolation, real-time tuning, and performance optimization extracted from the `physical_machine` and hypervisor roles.

## Requirements

No requirements.

## Role Variables

All variables are optional.

### Performance Tuning
| Variable | Type | Comments |
|----------|------|----------|
| `hugepages_count` | Integer | Number of 1GB hugepages to allocate (0 = disabled) |
| `extra_kernel_modules` | List | List of additional kernel modules to load |
| `extra_sysctl_physical_machines` | String | Custom sysctl configuration |

### CPU Isolation and Real-time Tuning
| Variable | Type | Comments |
|----------|------|----------|
| `isolcpus` | String | CPU cores to isolate (comma separated, ranges with dash: e.g. 4,6-7,10) |
| `cpusystem` | String | CPU cores reserved for system processes |
| `cpuuser` | String | CPU cores reserved for user processes |
| `cpumachines` | String | CPU cores reserved for VM processes |
| `cpumachinesrt` | String | CPU cores reserved for real-time VM processes |
| `cpumachinesnort` | String | CPU cores reserved for non-real-time VM processes |
| `cpuovs` | String | CPU cores reserved for OVS processes |

### Kernel Parameters (Yocto-specific)
| Variable | Type | Comments |
|----------|------|----------|
| `extra_kernel_parameters` | String | Extra kernel parameters to add |
| `kernel_parameters_restart` | Boolean | Whether to restart after kernel parameter update |

## Example Playbook

```yaml
- hosts: cluster_machines
  roles:
    - system_tuning
```
