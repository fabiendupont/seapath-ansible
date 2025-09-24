# Cluster Corosync Role

This role configures Corosync cluster communication for SEAPATH high availability clusters.

## Features

- Installs Corosync packages
- Generates Corosync configuration
- Creates authentication keys
- Starts and enables Corosync service

## Variables

### Required Variables

- `corosync_node_list`: List of cluster node IP addresses

### Optional Variables

- `corosync_cluster_name`: Cluster name (default: "seapath")
- `corosync_transport`: Transport protocol (default: "udpu")
- `corosync_token`: Token timeout (default: 1000)
- `corosync_netmtu`: Network MTU (default: 1500)
- `corosync_vsftype`: Virtual synchrony fault tolerance type (default: "ykb")
- `corosync_ip_version`: IP version (default: "ipv4")

## Example Playbook

```yaml
- name: Configure Corosync
  hosts: cluster_machines
  vars:
    corosync_node_list: "{{ groups['cluster_machines'] | list }}"
  roles:
    - cluster_corosync
```

## Dependencies

None.

## License

Apache-2.0
