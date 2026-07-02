#!/usr/bin/env bash

# Function to get status symbols from jj status
get_status_symbols() {
  local symbols=""
  # Skip the first line with 'Working copy changes:'
  while IFS= read -r line; do
    case "${line:0:1}" in
    "M") symbols+="✏️" ;;
    "A") symbols+="✚" ;;
    "R") symbols+="»" ;;
    "D") symbols+="✘" ;;
    "?") symbols+="?" ;;
    "C") symbols+="💥" ;;
    esac
  done < <(jj status 2>/dev/null | tail -n +2)

  echo "$symbols"
}

# Function to get change-level symbols from jj log
get_change_symbols() {
  local log_output
  log_output=$(jj log --revisions @ --no-graph --ignore-working-copy --limit 1 --template '
        concat(
            if(conflict, "💥"),
            if(divergent, "🚧"),
            if(hidden, "👻"),
            if(immutable, "🔒"),
            if(empty, "⛔"),
        )
    ' 2>/dev/null | tr -d "\n")

  echo "$log_output"
}

# Function to get ahead/behind counts
get_ahead_behind() {
  local output
  output=$(jj log --revisions @ --template '
        concat(
            "ahead:", .tracking_ahead_count,
            ",behind:", .tracking_behind_count,
        )
    ' 2>/dev/null)

  local ahead=$(echo "$output" | grep -oP 'ahead:\K\d+')
  local behind=$(echo "$output" | grep -oP 'behind:\K\d+')

  local symbols=""
  ((ahead > 0)) && symbols+="⇡$ahead"
  ((behind > 0)) && symbols+="⇣$behind"
  echo "$symbols"
}

# Main
status_syms=$(get_status_symbols)
change_syms=$(get_change_symbols)
ahead_behind=$(get_ahead_behind)

# Combine and truncate to first 10 symbols
all_symbols="$change_syms$status_syms$ahead_behind"
if [ -n "$all_symbols" ]; then
  echo "${all_symbols:0:10}"
fi
