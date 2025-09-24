# Cluster Setup Role

This role handles cluster initialization and configuration for SEAPATH high availability clusters.

## Features

- Waits for Pacemaker to be ready
- Configures STONITH devices
- Runs additional CRM configuration commands
- Applies cluster resource configuration

## Variables

### Optional Variables

- `cluster_disable_stonith`: Disable STONITH for unconfigured machines (default: true)
- `cluster_stonith_commands`: List of STONITH configuration commands
- `cluster_extra_crm_commands`: List of extra CRM commands
- `cluster_resource_commands`: List of resource configuration commands

## Example Playbook

```yaml
- name: Setup Cluster
  hosts: cluster_machines
  vars:
    cluster_stonith_commands:
      - "primitive st-1 stonith:external/rackpdu params hostlist=h1 pduip=192.168.3.127"
      - "location l-st-h1 st-1 -inf: h1"
    cluster_extra_crm_commands:
      - "property stonith-enabled=true"
  roles:
    - cluster_setup
```

## Dependencies

- `cluster_pacemaker`

## License

Apache-2.0
