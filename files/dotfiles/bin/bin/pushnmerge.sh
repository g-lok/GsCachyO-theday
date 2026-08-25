#!/usr/bin/env zsh

BOOKMARK=$1

jj git push -b "$BOOKMARK"
DESCRIPTION=$(jj show | sed -n '7p' | xargs)
gh pr create -B main -H "$BOOKMARK" -t "$DESCRIPTION" -b "" | xargs -I {} gh pr merge "{}" -s -d
git push origin --delete "$BOOKMARK"
jj git fetch && jj new main
