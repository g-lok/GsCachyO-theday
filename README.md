# GsCachyO-theday

Quick and dirty scripts and dotfiles to glam up a new CachyOS Niri environment to be like mine.

**NOTE: This Ansible playbook ASSUMES you are running this on CachyOS (preferably with the `Erase` default `btrfs` partitioning and `luks2` disk encryption enabled), the `Limine` bootloader, and the `Niri` desktop!**

I attempt to handle the possibility you are on a different desktop/multiplexer in the `run.sh` script, but it hasn't been tested and I can't guarantee anything.

## Install

Change your git name and email in `config.yml`

Run:

```bash
./run.sh
```

Make sure you auth the gh cli tool, and be sure to use SSH (generate and upload key if you don't have one already).

If you were using some other desktop already, make sure you accept the pacman overrides and choose `Niri` desktop on login after a restart (use arrow keys to move around in the `Slice` login ssdm).

If you don't want to enable all system services, comment out the relevant lines in `run.sh`.

## Usage

I'll write up more comprehensive docs at some point, but for now:

1. There are descriptions of every tool being installed by `pacman`, `yay`, and `mise` in the `package-summary.md` document. There are a ton of modern, awesome replacements for the old guard cli tools, plus a whole bunch of new ones. `eza` instead of `ls`. `btop` instead of `top`, `ripgrep (rg)` instead of `grep`, `zoxide` instead of `cd`, etc. Note that I have set up aliases for `ls` and `cd` to use their `eza` and `zoxide` counterparts. Also, learn how `zoxide` actually works to index every filepath you've been to so you can shortcut your way there. Otherwise, there are just WAY too many tools and apps to cover here.
1. Dotfiles are now symlinked to `~/dotfiles/`.
1. Check `niri`, `kitty`, `zellij`, `shellrc`, `neovim` for the most important dotfile configs and keymappings/aliases.
1. As far as `lazyvim(neovim)` goes, I also used a script (included in the `bin` dotfiles) to generate the full keymappings as best as I could (it is certainly not complete), and threw the output in `lazyvim-keymaps.md`. Use the `nvim-keys` alias to run the script yourself. Not comprehensive, but good enough. The included `which-key.nvim` plugin will help a lot, and you can pull up a `telescope` fuzzy search for all the `which-key` bindings with `<leader>sk`. There's also the [Lazyvim official website](https://www.lazyvim.org/keymaps), and I also highly recommend the **EXCELLENT** [Lazyvim for Ambitious Developers](https://lazyvim-ambitious-devs.phillips.codes/) ebook to **really** learn how to do this right. Also check out the [base neovim keymaps](https://neovim.io/doc/user/vimindex/) for the basic stuff not listed in these other sources, but beware that many of these might have been overridden, re-assigned, or removed in the final lazyvim configs.
1. Learn how the vastly superior `jujutsu (jj)` works, and get off that old `git` shit train. Note that I set up a TON of `jj` aliases for quick and handy shortcuts for just about anything, plus threw some nice things in the jj global config. I have also include `lazyjj` if you want a TUI.
1. You can also modify Niri using `NiriMod` (will be in your fuzzel app popup w/ `super+space`). This _may_ overwrite the symlinked config location `stow`-ed to the `~/dotfiles/` niri location, and if so be sure to copy your updated config back to the `dotfiles` `niri` config, then run `~/dotfiles/dotfiles.sh` from the `~/dotfiles/` dir to re-stow everything.
1. Run `fullupdate.sh` to update `pacman, yay, mise`, and whatever other package managers you use. Run `refresh-cachyos.sh` if `pacman` is giving you problems and you need to refresh the `CachyOS` linux repositories and keys.
1. You can change your boot animation and login manager via `plymouth` and `sddm` themes.
1. If changing the kitty theme with `kitty +kitten themes`, **make sure** you export the theme as a **theme file**, and just source it at the bottom of the kitty config yourself (check current config and dir to see how it is supposed to look), so it doesn't clobber and bork the rest of the kitty config I painstakingly put together (it **will break**, I promise).
1. You can disable the console prompt **vim mode** in zsh by removing the oh-my-zsh plugin loaded in `~/.zshrc`. I don't recommend it though, vim mode is awesome. Note that I re-enabled the regular zsh `<Esc>.` "cycle last argument" functionality with `<Ctrl>+x, .`. Also, you can bring up a zsh history fuzzy search with `<Ctrl>+r`.
1. You can change the cli prompt by editing the `~/dotfiles/starship/.config/starship.toml`.
1. There's a variable in `config.yml` containing the contents of a modified sudoers that will make your local env available when using sudo. Run `sudo visudo` to put those changes in there, if you want. You may also have to symlink some files/dirs from your home to `/root/` for everything to work, I dunno. Dangerous, but trust me, you'll want all your paths, aliases, most env vars, your full `neovim` setup, etc. available with `sudo`.
1. To create a new poetry/python/mise project, use the helper `newpproj.sh` script with the name of your new project as the first argument. If you rock with `uv` instead, use `newuvproj.sh`.
1. For fancy terminal multiplexing, I use `zellij`. Entering the standard `zellij` command will load my custom 3-pane layout, but if you want a vanilla default window, use the `zd` alias. [Learn](https://zellij.dev/) all the cool things it can do and review the keymaps in the config file. Resizing panes keymaps might be broken, just use your mouse to drag them around for now.
1. Use `sesh` to manage `zellij/tmux` sessions.
1. Use `bat` wherever you used to use `cat` before, if you want to use its pager. Use my alias `bpp` if you don't want the pager.
1. Use `fzf/television (tv)` fuzzy finders for all kinds of everything. You can pipe `|` anything into either. Update your `television` channels with `tv update-channels`. I also highly encourage you to [make your own](https://alexpasmantier.github.io/television/user-guide/channels#creating-your-own-channels).
1. There are two different keybinds for clipboard history paste depending on whether you are using a typical gui app or something in kitty. make sure you set the keymaps in your _niri config_ to something that works for you.
1. There is also a **kickass** custom niri keybind/helper script that opens a floating `lazyvim(neovim)` window, which allows you to write text in the best text editor EVER, and upon save/quit (`:wq`), it will copy the text into the clipboard, then it will paste that text ANYWHERE your cursor was. Any Desktop/GUI app text field, any terminal or cli app, **ANYTHING**. Just hit `Shift+Mod+I` wherever, whenever.

## Post-Install

There's probably things I set up that I forgot about, but this should cover MOST things. I also recommend:

- Setting battery charge limit if on a laptop. Method will depend on your laptop, I don't remember exactly what I did for mine.
- Setting up ssh and gpg keys.
- Setting hostname and avahi mDNS service.
- Enabling opensssh if you want remote access to your machine, and configuring firewall for whatever ports that need to be opened (I have already automated opening ports for `localsend`). CachyOS uses `ufw` to manage the firewall (`sudo ufw --help`).
- Change localsend to launch with niri instead of the in-app setting, doesn't seem to work.
- Changing `/boot/limine.conf` to something you like. I set a custom theme on mine by copying my wallpaper and the `AIXOID8.F12` font into `/boot/`, then putting this at the top of `/boot/limine.conf`:

  ```
  timeout: 5
  default_entry: 2
  remember_last_entry: yes

  # CachyOS Limine theme
  # Author: diegons490 (https://github.com/diegons490/cachyos-limine-theme)
  term_palette: 1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4
  term_palette_bright: 585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4
  term_background: ffffffff
  term_foreground: cdd6f4
  term_background_bright: ffffffff
  term_foreground_bright: cdd6f4
  term_font: boot():/AIXOID8.F12
  term_font_scale: 2x2
  interface_branding:
  wallpaper: boot():/victorian-wallpaper.jpg
  ```

- Enabling system services. [EDIT: I enabled all system services in `run.sh`, comment or delete those bits if you want finer grain control].
- PM me to learn the tooling, workflows, keybinds, all the fun junk, etc.
