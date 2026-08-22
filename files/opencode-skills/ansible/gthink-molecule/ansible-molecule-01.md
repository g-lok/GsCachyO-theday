## ---

**Deep-Dive: Executing and Orchestrating Playbooks with Molecule**

## **1\. Core Lifecycle Commands (The Absolute Basics)**

Molecule orchestrates your testing environments using discrete steps. You rarely want to run the global molecule test command during development because it deletes everything on failure. Instead, use these surgical commands:

* **poetry run molecule create**  
  Spins up the blank Arch Linux container or Vagrant VM. It does not run your playbooks yet.  
* **poetry run molecule converge**  
  The most important command. It copies your latest playbook code, injects it into the running container/VM, and executes the tasks. You can run this command 50 times in a row as you fix typos.  
* **poetry run molecule login**  
  Drops your active terminal directly into the container/VM shell. Essential for checking if files were actually copied correctly or why a systemd service is failing. Type exit to leave.  
* **poetry run molecule destroy**  
  Obliterates the container/VM and wipes out all changes, returning your host system to a completely clean state.

## ---

**2\. Running Specific Portions of Your Playbooks**

You don't want to run a massive 2-hour server playbook every time you test a single configuration change. You can isolate tasks using standard Ansible **Tags** or by breaking your playbooks into **Modular Roles**.

## **Pattern A: Isolating Tasks via Ansible Tags**

Inside your main playbook or roles, assign a tags block to your tasks:

\- name: Synchronize my dotfiles  
  ansible.builtin.git:  
    repo: 'https://github.com'  
    dest: /home/user/.dotfiles  
  tags: \[ 'dotfiles', 'apps' \]

\- name: Install monitoring tools  
  ansible.builtin.pacman:  
    name: prometheus  
    state: present  
  tags: \[ 'monitoring' \]

To tell Molecule to **only** run your dotfiles configuration step during a converge, pass the tag through the Molecule provisioner environment variable:

MOLECULE\_ANSIBLE\_ARGS="--tags dotfiles" poetry run molecule converge

To run everything *except* the heavy monitoring tools:

MOLECULE\_ANSIBLE\_ARGS="--skip-tags monitoring" poetry run molecule converge

## **Pattern B: Surgical Execution inside converge.yml**

Your molecule/default/converge.yml file is the master controller for your test run. You can comment out or explicitly include specific role targets directly inside it:

\---  
\- name: Converge Target Sandbox Environment  
  hosts: all  
  gather\_facts: true  
  tasks:  
    *\# Comment out what you aren't testing right now:*  
    *\# \- name: Run Heavy Storage Bootstrapping*  
    *\#   ansible.builtin.include\_role:*  
    *\#     name: "../../roles/storage\_setup"*

    \- name: Run Fast Application Configurations  
      ansible.builtin.include\_role:  
        name: "../../roles/app\_configs"

## ---

**3\. Creating a Custom "Baseline" State (Caching Your Apps)**

If your playbook takes 20 minutes to install basic CLI tools, docker engines, and heavy system packages, running molecule destroy and starting over from a blank Arch image is painful.

To create a **pre-baked baseline image** that includes all your heavy apps but leaves the configurations clean for rapid testing, use Molecule's **Prepare** phase.

## **Step 1: Create a prepare.yml File**

Inside your molecule/default/ folder, create a new file named prepare.yml. Molecule automatically runs this file **exactly once** immediately after molecule create finishes, but *before* molecule converge happens. \[3, 4\]

Put all your heavy, slow, unchanging installation tasks inside it:

\---  
*\# molecule/default/prepare.yml*  
\- name: Pre-bake the Testing Baseline  
  hosts: all  
  gather\_facts: true  
  tasks:  
    \- name: Ensure baseline system packages are installed  
      ansible.builtin.pacman:  
        name: \[ 'git', 'tmux', 'neovim', 'docker', 'zsh' \]  
        state: present  
        update\_cache: true

## **Step 2: Enable the Prepare Step in molecule.yml**

Ensure Molecule knows to look for the prepare step by explicitly verifying your execution sequence in molecule/default/molecule.yml:

\---  
*\# Inside your molecule.yml sheet*  
scenario:  
  test\_sequence:  
    \- destroy  
    \- create  
    \- prepare *\# \<-- This locks in your package baseline*  
    \- converge

## **The Workflow:**

1. Run poetry run molecule create. Molecule boots the blank Arch container, then immediately executes prepare.yml to install your tools.  
2. Run poetry run molecule converge. This applies your configurations and dotfiles.  
3. If you mess up your configuration files and want to reset, do **not** run destroy. Simply use your molecule login terminal to delete the broken config directory, then run poetry run molecule converge again. It will re-apply your code in seconds because the base packages are already installed\!

## ---

**4\. Handling Real-World Variables and Mocks**

Because you are running playbooks locally on a container that thinks its hostname is arch-provisioned-container, you need to pass it mock parameters so it tricks your playbooks into thinking it is a real production server.

## **Passing Inventory Variables**

You can inject custom host variables directly into the provisioner section of your molecule/default/molecule.yml file:

provisioner:  
  name: ansible  
  inventory:  
    host\_vars:  
      arch-provisioned-container:  
        *\# Override production variables with safe local testing paths*  
        target\_drive: "/dev/loop0"  
        is\_headless\_server: true  
        ansible\_user: "root"

## **Handling Secrets/Passwords Safely**

If your playbook uses an Ansible Vault file to decrypt server passwords, you can tell Molecule to look for a local vault password file on your host machine so it can decrypt things automatically during a converge run:

provisioner:  
  name: ansible  
  config\_options:  
    defaults:  
      host\_key\_checking: false  
      *\# Point to a local text file containing your vault password*  
      vault\_password\_file: "../../.ansible-vault-pass"

---

Let your local AI agent chew on this layout\! It explicitly defines the daily developer commands, the syntax to run tiny subsets of code via tags, and how to decouple your slow package installations from your fast configuration updates using prepare.yml.

\[1\] [https://www.redhat.com](https://www.redhat.com/en/blog/developing-and-testing-ansible-roles-with-molecule-and-podman-part-1)  
\[2\] [https://github.com](https://github.com/jonashackt/molecule-ansible-docker-aws)  
\[3\] [https://dbren.uk](https://dbren.uk/blog/testing-ansible-content/)  
\[4\] [https://www.codecentric.de](https://www.codecentric.de/en/knowledge-hub/blog/continuous-infrastructure-ansible-molecule-travisci)