export COLORTERM=truecolor
export TERM="xterm-256color"
# ───────────────────────────────
# PATH
# ───────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

if [[ -d "/mnt/c/Users/ptorn/.config" ]]; then
  THEME_MODE_FILE="/mnt/c/Users/ptorn/.config/theme-mode"
else
  THEME_MODE_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/theme-mode"
fi
export THEME_MODE_FILE
[[ -f "$THEME_MODE_FILE" ]] || {
  mkdir -p "${THEME_MODE_FILE:h}"
  printf "dark\n" >| "$THEME_MODE_FILE"
}

if [[ -n $TMUX ]]; then
  export TERM="xterm-256color"
fi
export COLORTERM=truecolor

# ───────────────────────────────
# Oh My Zsh
# ───────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # disable Oh My Zsh themes to avoid overriding colors
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
unset LS_COLORS
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# ───────────────────────────────
# Starship prompt
# ───────────────────────────────
eval "$(starship init zsh)"

# ───────────────────────────────
# Aliases
# ───────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias projects="cd ~/projects"
alias windows="cd ~/../../mnt/c/Users/ptorn/"
alias ebash="nvim ~/.zshrc"
alias ubash="source ~/.zshrc"
alias root="cd ~"
alias cl="clear && ll"
alias biosfer="cd ~/../../mnt/c/Users/ptorn/POL/Biosfer/"

# Eza aliases
alias ls='eza --group-directories-first --icons --color=always'
alias ll='eza -la --git --time-style=long-iso --group-directories-first --icons --color=always --git'
unalias lt 2>/dev/null
lt() {
  local depth=2
  local dir="."

  # If first argument is a number, use it as depth
  if [[ "${1:-}" =~ ^[0-9]+$ ]]; then
    depth="$1"
    shift
  fi

  # If another argument exists, treat it as directory
  if [[ "${1:-}" != "" ]]; then
    dir="$1"
  fi

  eza -T -L "$depth" "$dir" --icons --color=always --group-directories-first
}

unalias open 2>/dev/null
open() {
  explorer.exe "$@"
}

# ───────────────────────────────
# Git helper
# ───────────────────────────────
git() {
  if [[ "$1" == "rm" ]]; then
    shift
    command git rm --cached "$@"
  else
    command git "$@"
  fi
}

# ───────────────────────────────
# Zoxide
# ───────────────────────────────
eval "$(zoxide init zsh)"
alias cd="z"

# ───────────────────────────────
# Android Studio
# ───────────────────────────────
export ANDROID_HOME=/mnt/c/Users/ptorn/AppData/Local/Android/Sdk

alias adb="/mnt/c/Users/ptorn/AppData/Local/Android/Sdk/platform-tools/adb.exe"
alias emulator="/mnt/c/Users/ptorn/AppData/Local/Android/Sdk/emulator/emulator.exe"

# ───────────────────────────────
# nvm (Node Version Manager)
# ───────────────────────────────
if [ -n "$ZSH_VERSION" ]; then
  if ! command -v hash >/dev/null 2>&1; then
    hash() { true; }
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH="$HOME/.cargo/bin:$PATH"

# Theme mode helpers (dark/light)
set_theme_mode() {
  local mode="$1"
  if [[ "$mode" != "dark" && "$mode" != "light" ]]; then
    echo "Usage: set_theme_mode [dark|light]"
    return 1
  fi

  printf "%s\n" "$mode" >| "$THEME_MODE_FILE"

  local tmux_theme_dir="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
  local source_file="$tmux_theme_dir/theme-${mode}.conf"
  local target_file="$tmux_theme_dir/theme-current.conf"

  if [[ -f "$source_file" ]]; then
    cp "$source_file" "$target_file"
    if command -v tmux >/dev/null 2>&1; then
      tmux source-file "$target_file" 2>/dev/null
      tmux refresh-client -S 2>/dev/null

      # Refresh running Neovim instances inside tmux panes
      local pane
      while IFS= read -r pane; do
        tmux send-keys -t "$pane" Escape ":lua require('saruDpol.theme_mode').apply(true)" Enter
      done < <(tmux list-panes -a -F '#{pane_id} #{pane_current_command}' 2>/dev/null | awk '$2 ~ /^n?vim$/ {print $1}')
    fi
  fi

  # Try to reload WezTerm config (WSL + Windows)
  if command -v wezterm >/dev/null 2>&1; then
    wezterm cli reload >/dev/null 2>&1
  fi
  if command -v powershell.exe >/dev/null 2>&1; then
    powershell.exe -NoProfile -Command "wezterm cli reload" >/dev/null 2>&1
  fi

  echo "Theme mode set to: $mode"
}

dark() {
  set_theme_mode dark
}

light() {
  set_theme_mode light
}

# TMUX IDE
ide() {
  local total=${1:-4}

  # Must be inside tmux
  if [ -z "$TMUX" ]; then
    echo "Run this inside tmux"
    return 1
  fi

  # Compute rows and columns (near-square)
  local rows=$(python3 - <<EOF
import math
n=$total
r=int(math.sqrt(n))
while n % r != 0:
    r-=1
print(r)
EOF
)
  local cols=$(( total / rows ))

  # First split into columns
  for ((i=1; i<cols; i++)); do
    tmux split-window -h
    tmux select-layout even-horizontal
  done

  # Then split each column into rows
  for ((c=0; c<cols; c++)); do
    tmux select-pane -t $c
    for ((r=1; r<rows; r++)); do
      tmux split-window -v
      tmux select-layout even-vertical
    done
  done

  tmux select-layout tiled
}
