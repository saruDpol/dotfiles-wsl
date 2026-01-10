#!/usr/bin/env bash
set -euo pipefail

N="${1:-}"

# Validate N (1..30)
if ! [[ "$N" =~ ^[0-9]+$ ]] || [ "$N" -lt 1 ] || [ "$N" -gt 30 ]; then
  tmux display-message "ide: usage: ide <1..30>  (example: ide 12)"
  exit 1
fi

# Clean slate: keep only 1 pane
tmux kill-pane -a 2>/dev/null || true

# Special case: N=1, do nothing
if [ "$N" -eq 1 ]; then
  tmux display-message "ide: 1 pane (no splits needed)"
  exit 0
fi

# Compute cols, rows with VERTICAL BIAS
read -r cols rows < <(python3 - "$N" <<'PY'
import math, sys
n = int(sys.argv[1])

if n == 2:
    print(2, 1)
elif n == 3:
    print(3, 1)
else:
    # Find optimal layout with cols >= rows
    sqrt_n = math.sqrt(n)
    cols = math.ceil(sqrt_n)
    
    # Ensure cols >= rows
    while True:
        rows = math.ceil(n / cols)
        if cols >= rows:
            break
        cols += 1
    
    print(cols, rows)
PY
)

# Create N-1 panes total (we already have 1)
remaining=$((N - 1))

# Phase 1: Create columns (vertical splits)
for ((i=1; i<cols; i++)); do
  if [ "$remaining" -le 0 ]; then break; fi
  tmux split-window -h
  remaining=$((remaining - 1))
done

# Phase 2: Split each column into rows
# Get all current pane IDs in order
mapfile -t pane_ids < <(tmux list-panes -F '#{pane_id}' | sort)

# Calculate panes per column
base_panes_per_col=$((N / cols))
extra_panes=$((N % cols))

col_idx=0
for pane_id in "${pane_ids[@]}"; do
  # How many total panes should this column have?
  if [ "$col_idx" -lt "$extra_panes" ]; then
    target_panes=$((base_panes_per_col + 1))
  else
    target_panes=$base_panes_per_col
  fi
  
  # This column already has 1 pane, split it (target_panes - 1) times
  splits_needed=$((target_panes - 1))
  
  for ((s=0; s<splits_needed; s++)); do
    if [ "$remaining" -le 0 ]; then break 2; fi
    tmux split-window -v -t "$pane_id"
    remaining=$((remaining - 1))
  done
  
  col_idx=$((col_idx + 1))
done

# Final layout
tmux select-layout tiled
tmux select-pane -t 0

tmux display-message "ide: ${cols} cols × ${rows} rows = ${N} panes"
