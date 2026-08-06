# AGENTS.md — GsCachyO-theday

Public Ansible playbook for provisioning a fresh CachyOS install with Niri + Noctalia + the full personal desktop stack. Single-host (`connection: local`). No vault, no inventory beyond localhost, no Molecule, no bootstrap.

## Audience

User just installed CachyOS (with Niri + Noctalia DE choice) and wants their machine set up to match this dotfile + package baseline. No creative-stack, no secrets, no LUKS, no per-host roles.

## Hard Constraints (Do Not Edit Without User Green-Light)

- **`config.yml`** — user edits `username`, `git_name`, `git_email` before running. Don't add vault refs or per-host lists.
- **`tasks/dotfiles.yml`** — uses the **triple-pass stow pattern** (copy → stow --adopt → copy). Do NOT change to a single-pass stow. The third copy is required because `stow --adopt` clobbers playbook versions with target's existing files on first run. See LRN-20260802-002.
- **`files/dotfiles/mise/.config/mise/config.toml`** — pinned to `python = "3.12"` due to bugs with `python = "latest"` via mise. `node = "lts"`. No `minimum_release_age` (dropped to keep fresh).
- **`files/dotfiles/zsh/.zshrc`** — zellij auto-attach block intentionally NOT present. Don't re-add.
- **`files/dotfiles/noctalia/.config/noctalia/settings.json`** — `avatarImage` is intentionally `""`. Don't set a default.
- **`files/dotfiles/bin/fullupdate.sh`** — the single canonical update script (pacman + yay + mise, no opam). No `upgrade-all.sh`, no `exportpkgs.sh`. Don't add more.

## Architecture

### Filesystem layout
```
GsCachyO-theday/
├── config.yml              # user-editable config (packages, dotfiles list, git identity)
├── main.yml                # single playbook, hosts: localhost
├── ansible.cfg             # roles_path, callbacks, remote_tmp
├── inventory.yaml          # localhost stub
├── mise.toml               # mise tool versions for development
├── run.sh                  # convenience wrapper to invoke the playbook
├── requirements.yml        # ansible-galaxy collections
├── pyproject.toml          # dev poetry config
├── package-summary.md      # human-readable description of every package
├── tasks/                  # shared task includes
│   ├── dotfiles.yml        # triple-pass stow pattern (CRITICAL)
│   ├── oh-my-zsh.yml
│   ├── lazyvim.yml
│   ├── glitch-animation.yml
│   ├── slice-login.yml
│   └── opencode-skills.yml
├── templates/
│   ├── fail2ban/jail.d/
│   └── noctalia-settings.j2
└── files/
    ├── victorian-wallpaper.jpg
    ├── safe-skill-install.sh
    └── dotfiles/           # stow packages, deployed to ~/dotfiles/ then symlinked to ~/
        ├── dotfiles.sh     # the `stow --adopt */; stow --restow */` helper
        ├── alacritty/, bash/, bin/, btop/, cachyos/, fish/, fuzzel/, gh-dash/,
        ├── ghostty/, golangci/, jj/, kitty/, markdownlint/, mise/, neovim/,
        ├── niri/, noctalia/, npm/, nushell/, shellrc/, starship/, television/,
        ├── tmux/, VSCode/, wezterm/, yazi/, zellij/, zsh/
        └── bin/            # scripts that stow to ~/bin/
            ├── fullupdate.sh
            ├── refresh-cachyos.sh
            ├── newpproj.sh
            ├── newuvproj.sh
            ├── niri-scratch.sh
            └── safe-skill-install.sh
```

### `dotfiles/` package list
Every directory under `files/dotfiles/` (except top-level scripts like `dotfiles.sh`) is a stow package. The `config.yml` `dotfiles:` list enumerates all of them. Adding a new package = create the dir, add to `dotfiles:` list, populate with dotfiles. Stow handles the rest.

### `bin/` scripts
Scripts that should end up at `~/bin/` (on `$PATH`) live in `files/dotfiles/bin/`. They stow to `~/bin/<script>` when the `bin` package is in the `dotfiles:` list. Keep them simple and `chmod 755` after writing.

## Patterns

### Triple-pass stow (see LRN-20260802-002)
`tasks/dotfiles.yml` does:
1. Copy `files/dotfiles/<pkg>/` → `~/dotfiles/<pkg>/` (first round, sets intended versions)
2. `stow --adopt -d ~/dotfiles -t ~ <pkg>` (symlinks, but may clobber intended with target's existing files)
3. Copy `files/dotfiles/<pkg>/` → `~/dotfiles/<pkg>/` (second round, restores intended versions)

If you change this to a single-pass stow, the playbook will silently corrupt configs on first run. Don't.

### Templatized paths
All hardcoded user paths use `{{ ansible_facts['user_dir'] }}` (Jinja2), not literal `/home/<user>/`. Example: noctalia `wallpaper.directory` is `"{{ ansible_facts['user_dir'] }}/Pictures/Wallpapers"`. See LRN-20260802-003.

### CachyOS package decisions
**Default to INCLUDING** a package in `pacman_pkgs` unless strong evidence it's in CachyOS base. The archived `CachyOS/calamares-config` `netinstall.yaml` is 2+ years out of date — `fuzzel` is in the live install but missing from the archive. Cross-reference with `pacman -Qqe` on a current install. See LRN-20260802-001, ERR-20260802-001.

### Single update script
`files/dotfiles/bin/fullupdate.sh` is the only update script. Contents: `pacman -Syu && yay -Syu && mise upgrade`. No apt/brew/snap/flatpak (wrong OS). No opam. Drop `upgrade-all.sh`, `exportpkgs.sh`, `release` if added by mistake.

### Pinned vs latest in mise
- `python = "3.12"` — pinned. `latest` has bugs.
- `node = "lts"` — pinned to current LTS.
- `mise = "latest"` — fine to track.
- `poetry = "latest"` — fine.
- No `minimum_release_age` — keeps fresh on first run; user can opt in.

## What This Repo Is NOT

- **NOT** a multi-host provisioner. If you need multiple machines with different roles, fork this and add role structure (or use `gloco-ansible` for the multi-host pattern).
- **NOT** a bootstrap/LUKS/initramfs playbook. Fresh CachyOS install only.
- **NOT** a secrets manager. No `vault.yml`, no API tokens, no SSH keys committed. The `gh` extension install expects the user to have already authed (`gh auth login`).
- **NOT** a testing harness. No Molecule, no CI, no verify.yml. User runs `run.sh` on a real machine and verifies manually.

## Common Modifications

| Goal | Where to edit |
|---|---|
| Add/remove pacman packages | `config.yml` `pacman_pkgs:` |
| Add/remove AUR packages | `config.yml` `yay_pkgs:` |
| Add/remove stow package | create dir under `files/dotfiles/`, add to `config.yml` `dotfiles:` |
| Add/remove `~/bin/` script | create/remove in `files/dotfiles/bin/`, ensure `bin` in `dotfiles:` list |
| Change terminal | `config.yml` `pacman_pkgs: kitty/kitty-terminfo` + `files/dotfiles/noctalia/.config/noctalia/settings.json` `appLauncher.terminalCommand` |
| Change bar position | `files/dotfiles/noctalia/.config/noctalia/settings.json` `bar.position` |
| Change wallpaper | `files/dotfiles/noctalia/.config/noctalia/settings.json` `wallpaper.directory` (templatized) |
| Change default editor | `config.yml` `pacman_pkgs: neovim` (vim is also in base) |

## Lessons (Cross-Reference)

- `LRN-20260802-001` — CachyOS base install reality (trust `pacman -Qqe`, not archived yaml)
- `LRN-20260802-002` — stow `--adopt` triple-pass requirement
- `LRN-20260802-003` — templatize hardcoded user paths
- `ERR-20260802-001` — dropped fuzzel based on stale yaml (resolved by re-adding)

## VCS

User handles all `jj` / `git` operations. Don't run `jj commit`, `jj push`, `git add`, `git commit`, `git push`, or `gh` from this repo's working directory unless explicitly told to. Read + comment OK; writes only when explicitly asked.
