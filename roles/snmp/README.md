# SNMP Role

This role configure the SNMP feature

## Requirements

No requirement.

## Role Variables

| Variable               | Required | Type         | Comments                                                                                                             |
|------------------------|----------|--------------|----------------------------------------------------------------------------------------------------------------------|
| ansible_os_family      | yes      | String       | Distribution family. RedHat, Debian or Yocto. The variable is set automatically using the detect_distribution role |
| snmp_accounts          | no       | List of dict | List of snmp_accounts. See bellow.                                                                                   |
| snmp_admin_ip_addr     | yes      | string       | SNMP agent IP address                                                                                                |
| extra_snmpd_directives | no       | string       | Extra snmpd.conf configuration                                                                                       |

The *snmp_accounts* is a dictionary with the following members:

| *snmp_accounts* member | Required | Type   | Comments                     |
|------------------------|----------|--------|------------------------------|
| name                   | yes      | string | Name of the SNMP account     |
| password               | yes      | string | Password of the SNMP account |


## Example Playbook

```yaml
- hosts: cluster_machines
  roles:
    - { role: seapath_ansible.snmp }
```
