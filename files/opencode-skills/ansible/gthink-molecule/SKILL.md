---
name: gthink-molecule
description: >
  THE Molecule testing foundation. Orchestrates mandatory test "scenarios":
  Docker for speed/standard tasks and Vagrant-Libvirt for low-level system
  operations. Mandatory for all Ansible projects. Optimized for GLoco Homelab.
version: 2.1.0
---

# GThink Molecule: The Unified Testing Framework

This skill provides a battle-tested, high-efficiency Molecule framework for Ansible. It balances high-speed Docker validation with high-fidelity Vagrant/Libvirt system simulation.

## 1. Core Architecture: The Triple-Tier System

### Tier 1: High-Speed Clean Room (Docker)
**Purpose**: Isolated, rapid development of roles (K3s, dotfiles, app stacks) without monolith overhead.
- **Dynamic Cartridges**: Use `molecule_run_roles` variable in `converge.yml` to run any role sequence.
- **Mise Command**: `mise run m:arch:k3s` (Single-role isolation).
- **Parity**: One base scenario per target OS (`base-arch`, `base-debian`).

### Tier 2: Unit/E2E Integration (Docker)
**Purpose**: Validating full host provisioning (Role logic, configuration templates, package lists).
- **Images**: Use `jrei/systemd-<distro>` (e.g., `jrei/systemd-debian:12`, `jrei/systemd-archlinux`).
- **Security**: Force `ansible_user: root` and `ansible_become: false` inside containers.

### Tier 3: High-Fidelity (Vagrant/Libvirt)
**Purpose**: Testing LUKS encryption, disk partitioning, kernels, bootloaders, and cross-architecture chroots.
- **Shim**: Uses a containerized Vagrant proxy (`~/bin/vagrant`) to route commands to host `libvirtd`.
- **Hardware Simulation**: Uses secondary virtual disks to simulate NVMe/SSD targets.

---

## 2. Efficiency Patterns

### The "Clean Room Cartridge"
Transform your base scenarios into modular labs:
```yaml
# converge.yml
- name: Run Dynamic Role Sequence
  ansible.builtin.include_role:
    name: "{{ item }}"
  loop: "{{ molecule_run_roles | default(['k3s']) }}"
```

### The "Warp Speed" Sideload
Avoid network delays for heavy binaries (K3s, etc.):
1. **Sideload**: Check for `files/k3s-bin/k3s` on localhost.
2. **Logic**: Use `ansible.builtin.copy` to move the binary to `/usr/local/bin/` if it exists, skipping the `curl` installer.
3. **Ignore**: Always add sideload paths to `.gitignore`.

### The "Molecule Guard"
Protect hardware/kernel tasks from failing in Docker:
- **Variable**: Define `molecule_testing: true` in Molecule inventory.
- **Task Guard**: `when: not molecule_testing | default(false)`.
