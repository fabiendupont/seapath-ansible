# SEAPATH Molecule Integration Tests

Molecule-based integration tests for validating SEAPATH deployments.

## Overview

These tests validate complete SEAPATH workflows using real playbooks and multi-node clusters. They complement role-level tests (like `roles/debian/molecule/default/`) by testing the integration of multiple roles and components together.

## Available Scenarios

### Ceph Deployment Tests

**ceph-ansible-2h1o** - ceph-ansible with 2 Hypervisors + 1 Observer
- Most common SEAPATH topology
- 3 monitors, 2 OSDs, pool size=2/min_size=1
- Validates current ceph-ansible deployment

**ceph-ansible-3nodes** - ceph-ansible with 3 Hypervisors
- Alternative topology with all nodes having OSDs
- 3 monitors, 3 OSDs, pool size=3/min_size=2
- Validates current ceph-ansible deployment

**Note**: cephadm scenarios will be added during migration (Phase 1+)

## Running Tests

### Full Test Cycle
```bash
# Test ceph-ansible baseline
molecule test -s ceph-ansible-2h1o
molecule test -s ceph-ansible-3nodes

# Test all scenarios
molecule test --all
```

### Development Workflow
```bash
# Create test VMs
molecule create -s ceph-ansible-2h1o

# Deploy and test (keep VMs running)
molecule converge -s ceph-ansible-2h1o

# Re-run verification only
molecule verify -s ceph-ansible-2h1o

# SSH into test VM
molecule login -s ceph-ansible-2h1o -h hypervisor1

# Clean up
molecule destroy -s ceph-ansible-2h1o
```

### Debug Mode
```bash
# Keep VMs after failure for inspection
molecule --debug converge -s ceph-ansible-2h1o

# View Ansible output verbosity
ANSIBLE_VERBOSITY=3 molecule converge -s ceph-ansible-2h1o
```

## Requirements

### Software
- Molecule >= 3.0
- Vagrant
- libvirt provider
- Ansible >= 2.10

### System Resources
Each scenario requires:
- **2H+1O scenarios**: ~10 GB RAM, 6 CPUs, 20 GB storage
- **3-node scenarios**: ~12 GB RAM, 6 CPUs, 30 GB storage

## Test Structure

```
molecule/
├── ceph-ansible-2h1o/         # ceph-ansible + 2H+1O topology
│   └── molecule.yml           # ceph_deployment_method: ceph-ansible
├── ceph-ansible-3nodes/       # ceph-ansible + 3-node topology
│   └── molecule.yml           # ceph_deployment_method: ceph-ansible
└── shared/
    ├── requirements.yml       # Galaxy dependencies
    ├── converge.yml           # Deployment playbook (uses ceph_deployment_method)
    └── verify.yml             # Verification playbook
```

**Future**: cephadm scenarios will be added as migration progresses.

## Adding New Tests

### Role-Level Tests
For testing individual roles in isolation:
```bash
# Create role with molecule
cd roles/my-role
molecule init scenario -d vagrant
```

### Integration Tests
For testing complete SEAPATH workflows:

1. Create new scenario directory: `molecule/my-scenario/`
2. Define platforms in `molecule.yml` (topology, inventory)
3. Write test playbook in `converge.yml`
4. Add assertions in `verify.yml`
5. Reuse verification tasks from `shared/tasks/` when possible

## Troubleshooting

### VMs Won't Start
- Check libvirt is running: `systemctl status libvirtd`
- Verify vagrant-libvirt plugin: `vagrant plugin list`
- Check available resources: `free -h`, `virsh list --all`

### Tests Timeout
- Increase retries in verification tasks
- Check VM resources (memory, CPU)
- Verify network connectivity: `molecule login -s <scenario> -h <host>`

### Cleanup Issues
```bash
# Force destroy VMs
molecule destroy -s <scenario> --force

# Clean up orphaned VMs
virsh list --all
virsh destroy <vm-name>
virsh undefine <vm-name>
```

## CI/CD Integration

Example GitHub Actions workflow:

```yaml
name: Integration Tests

on: [push, pull_request]

jobs:
  ceph-tests:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        scenario: [ceph-ansible-2h1o, ceph-ansible-3nodes]
    steps:
      - uses: actions/checkout@v3
      - name: Run Ceph integration tests
        run: molecule test -s ${{ matrix.scenario }}
```

## References

- [Molecule Documentation](https://molecule.readthedocs.io/)
- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [SEAPATH Documentation](https://wiki.lfenergy.org/display/SEAPATH)

## Scenario-Specific Documentation

For detailed information about specific test scenarios, see:
- **Ceph Migration**: See `../CEPH_MIGRATION_PLAN.md` for Ceph-specific test details and migration checklist
