---
name: ansible
description: >
  Comprehensive Ansible automation entry point. Orchestrates specialized skills for
  playbooks, roles, and script conversion. Enforces continuous quality and systematic
  debugging via the ansible-troubleshooter skill. Supports specialized Molecule
  testing scenarios (Docker/Vagrant) for high-fidelity verification.
version: 1.2.0
keywords: [ansible, automation, playbook, role, collection, redhat, cop, devops, infrastructure, configuration-management, troubleshooting, code-review, scaffolding, molecule, ansible-lint]
---

# Ansible Master Skill

Central hub for all Ansible automation tasks. This skill manages specialized sub-capabilities while enforcing a high-standard testing engine and a "Chaos-Friendly" development philosophy.

## The Homelab Philosophy: Consistency > Rigidity

Ignore Red Hat CoP **Type-Function Pattern Architecture** constraints (e.g., "one host = one type"). In a homelab, hosts are multi-purpose.

- **Aesthetic Chaos**: Servers will run many unrelated services. Strive for clarity and organization within the project, even if the overall network is complex.
- **Project-Level Consistency**: Patterns (variable structures, task organization) must be consistent within a single project.
- **Roles vs. Playbooks**: Maintain strict separation. Roles = "How" (implementation); Playbooks = "What" (intent/orchestration).
- **Standards are Mandatory**: Technical standards (naming, prefixes, idempotency) are non-negotiable for reliability.

## Specialized Skill Referral Map

| Task | Skill | Primary Keywords |
| :--- | :--- | :--- |
| **Troubleshooting & Debugging** | `ansible-troubleshooter` | `debug`, `error`, `verbosity`, `lint`, `molecule`, `verify` |
| **New Playbooks** | `playbook-creator` | `create playbook`, `new playbook`, `orchestration` |
| **New Roles** | `role-developer` | `create role`, `role skeleton`, `argument_specs` |
| **Test Scenarios** | `gthink-molecule` | `docker scenario`, `vagrant scenario`, `libvirt proxy` |
| **Script Conversion** | `shell-to-ansible` | `convert shell`, `bash to ansible`, `declarative` |
| **Code Quality Review** | `ansible-cop-review` | `review ansible`, `cop compliance` |

## Foundation: Continuous Troubleshooting & Validation

The **`ansible-troubleshooter`** skill is the most frequently used tool (90% of dev time). It must be used **continuously** throughout the development lifecycle for both fixing errors and ensuring ongoing quality. It provides the framework for:

- **Debugging**: Systematic use of verbosity (`-vvv`), the `debug` module, and `register` patterns.
- **Linting**: Static analysis via `ansible-lint` to catch issues before execution.
- **Unit Testing**: Role-level testing with Molecule scenarios.
- **Idempotency**: Ensuring repeated runs are safe and silent.
- **Validation**: Verifying desired state via assertions and check mode (`--check`).

### Testing Scenarios (`gthink-molecule`)

For projects with specific environment needs, refer to **`gthink-molecule`**. It provides:

- **Docker Scenario**: Primary, high-speed driver for role/config logic.
- **Vagrant Scenario**: Specialized proxy-based driver for low-level system tasks (disks, kernels).
- **Baseline Caching**: Using `prepare.yml` to optimize test runs.

## Technical Standards Checklist

- [ ] **Naming**: `snake_case` only. **No dashes** in role names (breaks collections).
- [ ] **Variables**: Prefix all variables with `role_name_`.
- [ ] **Internal Vars**: Use double-underscore prefix (`__role_name_`) for implementation details.
- [ ] **Validation**: `meta/argument_specs.yml` is mandatory for all roles to fail-fast.
- [ ] **Idempotency**: Use declarative modules or `changed_when: false` / `creates` / `removes` guards.
- [ ] **Templates**: Always include the `{{ ansible_managed }}` header.
- [ ] **Secrets**: Never hardcode credentials. Use environment variables (e.g., `ANSIBLE_VAULT_PASS`) for Vault access.
- [ ] **Formatting**: `.yml` extension only. 2-space indentation. No tabs.
- [ ] **Facts**: STOP using old `ansible_` prefixed facts (deprecated). Always use the dict standard: `{{ ansible_facts['variable_name'] }}`.
- [ ] **Complexity**: Move complex logic to roles. Keep playbooks simple.
