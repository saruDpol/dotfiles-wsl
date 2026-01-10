export COLORTERM=truecolor
export TERM="xterm-256color"
# ───────────────────────────────
# PATH
# ───────────────────────────────
export PATH="$HOME/.local/bin:$PATH"


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
alias lt='eza -T --icons --color=always --group-directories-first'

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
