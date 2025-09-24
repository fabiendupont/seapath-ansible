# Cluster Pacemaker Role

This role configures Pacemaker resource manager and cluster management for SEAPATH high availability clusters.

## Features

- Installs Pacemaker packages
- Installs SEAPATH resource agents
- Configures Pacemaker service
- Applies patches to resource agents

## Resource Agents

- `ntpstatus`: NTP synchronization status
- `ptpstatus`: PTP synchronization status
- `VirtualDomain`: Virtual machine management
- `ethmonitor`: Network interface monitoring

## Variables

### Optional Variables

- `pacemaker_service_enabled`: Enable Pacemaker service (default: true)
- `pacemaker_service_state`: Pacemaker service state (default: "started")

## Example Playbook

```yaml
- name: Configure Pacemaker
  hosts: cluster_machines
  roles:
    - cluster_pacemaker
```

## Dependencies

- `cluster_corosync`

## License

Apache-2.0
