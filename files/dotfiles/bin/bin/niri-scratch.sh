#!/usr/bin/env bash

TMPFILE=$(mktemp --suffix=.txt)
cleanup() { rm -f "$TMPFILE"; }
trap cleanup EXIT

# Run Neovim with an autocmd that handles everything on exit
# We use a background shell inside nvim to trigger the paste AFTER nvim exits
nvim -c "autocmd VimLeave * silent ! (wl-copy < '$TMPFILE' && sleep 0.3 && TARGET_APP=\$(niri msg -j windows | jq -r '.[] | select(.is_focused == true) | .app_id') && if [ \"\$TARGET_APP\" = \"kitty\" ]; then wtype -M logo v; else wtype -M ctrl v; fi) &" "$TMPFILE"

exit 0
