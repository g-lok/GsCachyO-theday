#!/usr/bin/env bash
# G's aliases
alias bpp="bat -pp"
alias nv="nvim"
alias yz="yazi"
alias nvim-keys="nvim --headless -c 'luafile $HOME/bin/dump_keymaps.lua' -c 'qa'"
alias oc="opencode"
alias zdtab="zellij action new-tab --layout default"
alias zd="zellij --layout default"
alias zlg="zellij --layout gs-splitright"
alias calc="qalc"
alias calct="qalc -t"
alias quote="qalc -s 'maxdeci 2'"
alias quotet="qalc -t -s 'maxdeci 2' | wl-copy"

# Git aliases
alias gpum='git pull upstream master -v'
alias gfum='git fetch upstream master -v'
alias gpom='git pull origin master -v'
alias gfom='git fetch origin master -v'

### Omakub aliases
# File system
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
# alias fd='fdfind'
alias cd='z'

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
n() { if [ "$#" -eq 0 ]; then nvim .; else nvim "$@"; fi; }
alias g='git'
alias d='docker'
alias r='rails'
alias lzg='lazygit'
alias lzd='lazydocker'
alias lzj='lazyjj'

# Git
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

## Unalias oh-my-zsh git aliases that conflic with gnu cli tools
if [ -n "$ZSH_VERSION" ]; then
  unalias gcp
  alias gitcp='git cherry-pick'
  unalias gpr
  alias gitpr='git pull --rebase'
  unalias grm
  alias gitrm='git rm'
fi

# Jujutsu aliases
alias jja="jj abandon"
alias jjauth="jj metaedit --update-author"
alias jjauthfix="jj metaedit --update-author -r 'remote_bookmarks().. & ~immutable()'"
alias jjb="jj bookmark"
alias jjba="jj bookmark advance"
alias jjbc="jj bookmark create"
alias jjbd="jj bookmark delete"
alias jjbf="jj bookmark forget"
alias jjbl="jj bookmark list"
alias jjbm="jj bookmark move"
alias jjbrn="jj bookmark rename"
alias jjbs="jj bookmark set"
alias jjbt="jj bookmark track"
alias jjbut="jj bookmark untrack"
alias jjc="jj commit"
alias jjd="jj describe -m"
alias jjdi="jj diff"
alias jjdu="jj duplicate"
alias jje="jj edit"
alias jjevl="jj evolog"
alias jjf="jj file"
alias jjfixdiv="jj metaedit --update-change-id"
alias jjft="jj file track"
alias jjfu="jj file untrack"
alias jjg="jj git"
alias jjgcl="jj git clone"
alias jjgco="jj git colocation"
alias jjgex="jj git export"
alias jjgf="jj git fetch"
alias jjgi="jj git init"
alias jjgim="jj git import"
alias jjgp="jj git push --change @"
alias jjgpb="jj git push --bookmark"
alias jjgpt="jj git push --tracked"
alias jjgr="jj git remote"
alias jjgrt="jj gr"
alias jjid="jj interdiff"
alias jjl="jj log -r 'all()'"
alias jjld="jj log -r 'all()' -T builtin_log_detailed"
alias jjm="jj new"
alias jjno="jj new 'root()'"
alias jjo="jj obslog"
alias jjp="jj parallelize"
alias jjq="jj squash"
alias jjqf="jj squash --from"
alias jjqt="jj squash --into"
alias jjr="jj rebase"
alias jjrb="jj rebase -b"
alias jjrd="jj rebase -d"
alias jjrdm="jj rebase -d main"
alias jjrs="jj restore"
alias jjrsc="jj restore --from"
alias jjs="jj status"
alias jjsh="jj show"
alias jjsq="jj squash"
alias jjsqf="jj squash --from"
alias jjsqt="jj squash --into"
alias jjt="jj tag"
alias jjtd="jj tag delete"
alias jjtl="jj tag list"
alias jju="jj undo"
