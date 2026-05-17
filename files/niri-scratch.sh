#!/usr/bin/env bash

TMPFILE=$(mktemp --suffix=.txt)

# Clean up tmp file on exit
cleanup() { rm -f "$TMPFILE"; }
trap cleanup EXIT

nvim -c "autocmd BufWritePost <buffer> :silent !wl-copy < % && notify-send 'Copied to clipboard'" "$TMPFILE"
