# Cluster Conntrackd Role

This role configures the connection tracking daemon for cluster synchronization in SEAPATH high availability clusters.

## Features

- Installs conntrackd packages
- Configures conntrackd service
- Sets up connection state synchronization
- Configures multicast communication

## Variables

### Optional Variables

- `conntrackd_interface`: Network interface for synchronization (default: ansible_default_ipv4.interface)
- `conntrackd_multicast_address`: Multicast address (default: "225.0.0.50")
- `conntrackd_multicast_group`: Multicast group (default: 3780)
- `conntrackd_cluster_ip`: Cluster IP address
- `conntrackd_ignore_ip_list`: List of IPs to ignore

## Example Playbook

```yaml
- name: Configure Conntrackd
  hosts: cluster_machines
  vars:
    conntrackd_ignore_ip_list: "{{ conntrackd_ignore_ip_list }}"
  roles:
    - cluster_conntrackd
```

## Dependencies

- `cluster_pacemaker`

## License

Apache-2.0
