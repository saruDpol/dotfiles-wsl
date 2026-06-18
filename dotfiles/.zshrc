export COLORTERM=truecolor
export TERM="xterm-256color"

# ───────────────────────────────
# PATH
# ───────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

WINDOWS_THEME_DIR="/mnt/c/Users/ptorn/.config"
LOCAL_THEME_MODE_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/theme-mode"
THEME_MODE_FILE="$LOCAL_THEME_MODE_FILE"
export THEME_MODE_FILE
[[ -f "$THEME_MODE_FILE" ]] || {
  mkdir -p "${THEME_MODE_FILE:h}"
  printf "dark\n" >| "$THEME_MODE_FILE"
}

theme_mode_value() {
  if [[ -f "$THEME_MODE_FILE" ]]; then
    local mode
    mode="$(head -n 1 "$THEME_MODE_FILE" 2>/dev/null)"
    [[ "$mode" == "light" ]] && { printf "light\n"; return; }
  fi
  printf "dark\n"
}

typeset -g __SHELL_THEME_MODE=""

apply_shell_theme() {
  local mode="${1:-$(theme_mode_value)}"
  local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
  [[ "$mode" == "$__SHELL_THEME_MODE" ]] && return 0
  __SHELL_THEME_MODE="$mode"

  if [[ "$mode" == "light" ]]; then
    export STARSHIP_CONFIG="$config_home/starship-light.toml"
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5f6d78'
    zstyle ':completion:*' list-colors 'fi=38;5;238:di=38;5;58:ln=38;5;25:ex=38;5;124:so=38;5;30:pi=38;5;94:bd=38;5;124:cd=38;5;124'
    zstyle ':completion:*:descriptions' format '%F{61}%d%f'
    ZSH_HIGHLIGHT_STYLES[default]='fg=#24313b'
    ZSH_HIGHLIGHT_STYLES[command]='fg=#1f6fb2'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=#1f6fb2'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=#5e8a35'
    ZSH_HIGHLIGHT_STYLES[function]='fg=#5e8a35'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#b4432a'
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=#b4432a'
  else
    export STARSHIP_CONFIG="$config_home/starship-dark.toml"
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#586e75'
    zstyle ':completion:*' list-colors 'fi=38;5;252:di=38;5;178:ln=38;5;170:ex=38;5;166:so=38;5;73:pi=38;5;136:bd=38;5;166:cd=38;5;166'
    zstyle ':completion:*:descriptions' format '%F{109}%d%f'
    ZSH_HIGHLIGHT_STYLES[default]='fg=#d0d0d0'
    ZSH_HIGHLIGHT_STYLES[command]='fg=#33a6b8'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=#33a6b8'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=#bec23f'
    ZSH_HIGHLIGHT_STYLES[function]='fg=#bec23f'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#cc543a'
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=#cc543a'
  fi
  unset EZA_COLORS

  if [[ -n "${ZSH_VERSION:-}" && $- == *i* ]]; then
    eval "$(starship init zsh)"
    zle && zle reset-prompt 2>/dev/null
  fi
}

if [[ -n $TMUX ]]; then
  export TERM="xterm-256color"
fi
export COLORTERM=truecolor

# ───────────────────────────────
# Oh My Zsh
# ───────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
unset LS_COLORS
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

autoload -Uz add-zsh-hook
sync_shell_theme_precmd() {
  apply_shell_theme "$(theme_mode_value)"
}
add-zsh-hook precmd sync_shell_theme_precmd

# ───────────────────────────────
# Starship prompt
# ───────────────────────────────
apply_shell_theme

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
eza_base() {
  command eza --group-directories-first --icons --color=always "$@"
}

eza_long() {
  local args=(-la --time-style=long-iso --group-directories-first --icons --color=always)
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    args+=(--git)
  fi
  command eza "${args[@]}" "$@"
}

alias ls='eza_base'
alias ll='eza_long'
unalias lt 2>/dev/null
lt() {
  local depth=2
  local dir="."

  if [[ "${1:-}" =~ ^[0-9]+$ ]]; then
    depth="$1"
    shift
  fi

  if [[ "${1:-}" != "" ]]; then
    dir="$1"
  fi
  command eza -T -L "$depth" "$dir" --icons --color=always --group-directories-first
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

dark() {
  "$HOME/.config/bin/theme-mode" dark >/dev/null && apply_shell_theme dark
}

light() {
  "$HOME/.config/bin/theme-mode" light >/dev/null && apply_shell_theme light
}

toggle_theme() {
  local mode
  mode="$("$HOME/.config/bin/theme-mode" toggle)"
  apply_shell_theme "$mode"
}

# TMUX IDE
ide() {
  local total=${1:-4}

  if [ -z "$TMUX" ]; then
    echo "Run this inside tmux"
    return 1
  fi

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

  for ((i=1; i<cols; i++)); do
    tmux split-window -h
    tmux select-layout even-horizontal
  done

  for ((c=0; c<cols; c++)); do
    tmux select-pane -t $c
    for ((r=1; r<rows; r++)); do
      tmux split-window -v
      tmux select-layout even-vertical
    done
  done

  tmux select-layout tiled
}
