# GsCachyO-theday

Quick and dirty scripts and dotfiles to glam up a new CachyOS Niri environment to be like mine

## Install

Run:

```bash
./run.sh
```

## Usage

I'll write up more comprehensive docs, but for now check:

1. Look at the pacman and yay packages being installed. There's a description for everything I have installed on MY system (not necessarily everything being installed here) in `package-summary.md`
1. Dotfiles are now symlinked to `~/dotfiles/`.
1. Check `niri`, `kitty`, `zellij`, `shellrc`, `neovim` for most important configs and the keymappings/aliases
1. You can change your login animation and manager via plymouth and sddm themes.
1. If changing kitty theme, make sure you export the theme as a theme file and just source it at the bottom of the kitty config file so it doesn't bork the rest of the kitty config.
1. You can disable vim mode in zsh by removing the plugin in `~/.zshrc`
1. There's a variable in `config.yml` containing the contents of a modified sudoers that will make your local env available when using sudo. Run `sudo visudo` to put those changes in there. You may also have to symlink some files/dirs from your home to `/root/` for everything to work, I dunno.
1. To create a new poetry/python/mise project, use the helper `~/bin/newpproj.sh` script with the name of your new project as the first argument
1. Use sesh to manage zellij/tmux sessions
1. Use fzf/television for fuzzy finding
1. There are two different keybinds for clipboard history paste depending on whether you are using a typical gui app or something in kitty. make sure you set theme in your niri config to something that works for you.
1. There is also a custom niri keybind/helper script that allows you to use a temp neovim buffer to write text and copy it into the system clipboard for input anywhere. Might need some fiddling depending on how you want things.
