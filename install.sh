#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

node_version="24.14.1"
tree_sitter_cli_version="0.26.8"
starship_version="1.24.2"
eza_version="0.23.4"
lazygit_version="0.64.0"

dry_run=0
install_deps=1
install_dotfiles=1
install_nvim_plugins=0

usage() {
  cat <<EOF
Usage: ./install.sh [options]

Bootstraps this dotfiles setup from inside an already installed Ubuntu WSL2.

Options:
  --dry-run              Show commands without changing the system.
  --no-deps              Only install/link dotfiles.
  --no-dotfiles          Only install dependencies.
  --nvim-sync            Also run Neovim headless so lazy.nvim/Mason install tools.
  -h, --help             Show this help.

Pinned tool versions:
  Node.js                ${node_version}
  tree-sitter-cli        ${tree_sitter_cli_version}
  starship               ${starship_version}
  eza                    ${eza_version}
  lazygit                ${lazygit_version}

WSL2 and WezTerm itself are not installed here. This only writes the Windows
WezTerm loader that points to dotfiles/.wezterm.lua.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      dry_run=1
      ;;
    --no-deps)
      install_deps=0
      ;;
    --no-dotfiles)
      install_dotfiles=0
      ;;
    --nvim-sync)
      install_nvim_plugins=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
  shift
done

log() {
  printf '%s\n' "$*"
}

section() {
  printf '\n==> %s\n' "$*"
}

run() {
  if [[ "$dry_run" -eq 1 ]]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
    return 0
  fi

  "$@"
}

run_shell() {
  if [[ "$dry_run" -eq 1 ]]; then
    printf '[dry-run] bash -lc %q\n' "$*"
    return 0
  fi

  bash -lc "$*"
}

have() {
  command -v "$1" >/dev/null 2>&1
}

is_wsl() {
  grep -qi microsoft /proc/version 2>/dev/null
}

same_path() {
  [[ "$(readlink -f "$1" 2>/dev/null || true)" == "$(readlink -f "$2" 2>/dev/null || true)" ]]
}

backup_path() {
  local target="$1"
  local backup="$backup_dir/${target#/}"

  log "Backing up $target -> $backup"
  run mkdir -p "$(dirname "$backup")"
  run mv "$target" "$backup"
}

require_ubuntu() {
  if [[ ! -r /etc/os-release ]]; then
    log "Cannot detect OS: /etc/os-release missing."
    exit 1
  fi

  # shellcheck disable=SC1091
  . /etc/os-release
  if [[ "${ID:-}" != "ubuntu" ]]; then
    log "This bootstrap is written for Ubuntu WSL. Detected: ${PRETTY_NAME:-unknown}"
    exit 1
  fi
}

sudo_apt_install() {
  local packages=("$@")
  run sudo apt-get install -y "${packages[@]}"
}

install_apt_deps() {
  section "APT packages"

  run sudo apt-get update
  sudo_apt_install \
    software-properties-common \
    ca-certificates \
    gnupg \
    git \
    curl \
    unzip \
    build-essential \
    zsh \
    tmux \
    ripgrep \
    fd-find \
    python3 \
    python3-venv \
    zoxide
}

install_neovim() {
  section "Neovim"

  run sudo add-apt-repository -y ppa:neovim-ppa/unstable
  run sudo apt-get update
  sudo_apt_install neovim
}

install_oh_my_zsh() {
  section "Oh My Zsh"

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    run_shell 'RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
  else
    log "Already installed: $HOME/.oh-my-zsh"
  fi

  install_zsh_plugin \
    zsh-autosuggestions \
    https://github.com/zsh-users/zsh-autosuggestions.git \
    85919cd1ffa7d2d5412f6d3fe437ebdbeeec4fc5

  install_zsh_plugin \
    zsh-syntax-highlighting \
    https://github.com/zsh-users/zsh-syntax-highlighting.git \
    5eb677bb0fa9a3e60f0eff031dc13926e093df92
}

set_default_shell() {
  section "Default shell"

  local zsh_path
  zsh_path="$(command -v zsh || printf '/usr/bin/zsh')"

  if [[ "${SHELL:-}" == "$zsh_path" ]]; then
    log "Already using zsh: $zsh_path"
    return 0
  fi

  log "Setting default shell to $zsh_path"
  run sudo chsh -s "$zsh_path" "$USER"
}

install_zsh_plugin() {
  local name="$1"
  local url="$2"
  local commit="$3"
  local target="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$name"

  if [[ ! -d "$target/.git" ]]; then
    run git clone "$url" "$target"
  else
    log "Already installed: $target"
  fi

  run git -C "$target" fetch --depth 1 origin "$commit"
  run git -C "$target" checkout --quiet "$commit"
}

install_starship() {
  section "Starship"

  if have starship && [[ "$(starship --version | sed -n '1s/^starship //p')" == "$starship_version" ]]; then
    log "Already installed: starship $starship_version"
    return 0
  fi

  run_shell "curl -fsSL https://starship.rs/install.sh | sh -s -- --yes --version ${starship_version}"
}

install_eza() {
  section "eza"

  if have eza && eza --version | grep -q "v${eza_version}"; then
    log "Already installed: eza $eza_version"
    return 0
  fi

  local tmp
  if [[ "$dry_run" -eq 1 ]]; then
    tmp="/tmp/eza-${eza_version}"
  else
    tmp="$(mktemp -d)"
  fi
  run_shell "curl -fsSL -o '${tmp}/eza.tar.gz' 'https://github.com/eza-community/eza/releases/download/v${eza_version}/eza_x86_64-unknown-linux-gnu.tar.gz'"
  run tar -xzf "$tmp/eza.tar.gz" -C "$tmp"
  run mkdir -p "$HOME/.local/bin"
  run install -m 0755 "$tmp/eza" "$HOME/.local/bin/eza"
  run rm -rf "$tmp"
}

install_nvm_node() {
  section "Node.js via nvm"

  if [[ ! -d "$HOME/.nvm" ]]; then
    run_shell 'curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash'
  else
    log "Already installed: $HOME/.nvm"
  fi

  run_shell "source '$HOME/.nvm/nvm.sh' && nvm install ${node_version} && nvm alias default ${node_version} && nvm use ${node_version}"
  run_shell "source '$HOME/.nvm/nvm.sh' && npm install -g tree-sitter-cli@${tree_sitter_cli_version}"
}

install_tmux_tpm() {
  section "tmux TPM"

  local target="$repo_dir/tmux/plugins/tpm"
  if [[ ! -d "$target/.git" ]]; then
    run git clone https://github.com/tmux-plugins/tpm "$target"
  else
    log "Already installed: $target"
  fi
}

install_lazygit() {
  section "lazygit"

  if have lazygit; then
    local installed_version
    installed_version="$(
      lazygit --version 2>/dev/null |
        sed -n 's/.*version=\([^, ]*\).*/\1/p'
    )"

    if [[ "$installed_version" == "$lazygit_version" ]]; then
      log "Already installed: lazygit $lazygit_version"
      return 0
    fi

    log "Updating lazygit: ${installed_version:-unknown} -> $lazygit_version"
  fi

  local machine
  local arch
  local tmp
  local archive
  local url

  machine="$(uname -m)"

  case "$machine" in
    x86_64|amd64)
      arch="x86_64"
      ;;
    aarch64|arm64)
      arch="arm64"
      ;;
    *)
      log "Unsupported architecture for lazygit: $machine"
      return 1
      ;;
  esac

  if [[ "$dry_run" -eq 1 ]]; then
    tmp="/tmp/lazygit-${lazygit_version}"
  else
    tmp="$(mktemp -d)"
  fi

  archive="$tmp/lazygit.tar.gz"
  url="https://github.com/jesseduffield/lazygit/releases/download/v${lazygit_version}/lazygit_${lazygit_version}_Linux_${arch}.tar.gz"

  run mkdir -p "$tmp"
  run curl -fsSL -o "$archive" "$url"
  run tar -xzf "$archive" -C "$tmp" lazygit
  run sudo install -m 0755 "$tmp/lazygit" /usr/local/bin/lazygit
  run rm -rf "$tmp"

  if [[ "$dry_run" -eq 0 ]]; then
    lazygit --version
  fi
}

windows_home_dir() {
  if [[ -n "${WINDOWS_HOME:-}" && -d "$WINDOWS_HOME" ]]; then
    printf '%s\n' "$WINDOWS_HOME"
    return 0
  fi

  if have cmd.exe && have wslpath; then
    local win_profile
    local wsl_profile

    win_profile="$(cmd.exe /C "echo %USERPROFILE%" 2>/dev/null | tr -d '\r')"
    if [[ -n "$win_profile" ]]; then
      wsl_profile="$(wslpath "$win_profile" 2>/dev/null || true)"
      if [[ -d "$wsl_profile" ]]; then
        printf '%s\n' "$wsl_profile"
        return 0
      fi
    fi
  fi

  if [[ -d /mnt/c/Users/ptorn ]]; then
    printf '%s\n' /mnt/c/Users/ptorn
    return 0
  fi

  return 1
}

install_dependencies() {
  require_ubuntu
  install_apt_deps
  install_neovim
  install_oh_my_zsh
  set_default_shell
  install_starship
  install_eza
  install_nvm_node
  install_tmux_tpm
  install_lazygit
}

install_zshrc() {
  local source="$repo_dir/dotfiles/.zshrc"
  local target="$HOME/.zshrc"

  if same_path "$source" "$target"; then
    log "Already installed: $target"
    return 0
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    backup_path "$target"
  fi

  log "Linking $target -> $source"
  run ln -s "$source" "$target"
}

sync_eza_theme() {
  local mode_file="$repo_dir/theme-mode"
  local mode="dark"
  local source
  local target="$repo_dir/eza/theme.yml"

  if [[ -f "$mode_file" ]]; then
    local current
    current="$(head -n 1 "$mode_file" 2>/dev/null || true)"
    if [[ "$current" == "light" ]]; then
      mode="light"
    fi
  fi

  source="$repo_dir/eza/theme-${mode}.yml"
  if [[ ! -f "$source" ]]; then
    log "Skipping eza theme sync: missing $source"
    return 0
  fi

  log "Syncing eza theme: $source -> $target"
  if [[ "$dry_run" -eq 1 ]]; then
    log "[dry-run] copy $source to $target"
    return 0
  fi

  cp "$source" "$target"
}

install_wezterm_windows_loader() {
  local source="$repo_dir/dotfiles/.wezterm.lua"
  local windows_home
  local target
  local windows_source
  local marker

  if ! is_wsl; then
    log "Skipping WezTerm loader: this does not look like WSL."
    return 0
  fi

  if ! windows_home="$(windows_home_dir)"; then
    log "Skipping WezTerm loader: Windows home not found."
    log "Set WINDOWS_HOME=/mnt/c/Users/<your-user> and rerun if needed."
    return 0
  fi

  target="$windows_home/.wezterm.lua"
  windows_source="$(wslpath -w "$source")"
  marker="-- Managed by $repo_dir/install.sh"

  if [[ -f "$target" ]] && [[ "$(sed -n '2p' "$target" 2>/dev/null || true)" == "$marker" ]]; then
    log "Already installed: $target"
    return 0
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    backup_path "$target"
  fi

  log "Writing WezTerm loader: $target -> $windows_source"
  if [[ "$dry_run" -eq 1 ]]; then
    log "[dry-run] write loader to $target"
    return 0
  fi

  cat > "$target" <<EOF
-- This file is intentionally tiny.
$marker
-- Edit the real config in the dotfiles repo.
return dofile([[${windows_source}]])
EOF
}

install_dotfile_links() {
  section "Dotfile links"
  install_zshrc
  sync_eza_theme
  install_wezterm_windows_loader
}

sync_neovim() {
  section "Neovim plugin sync"

  run nvim --headless "+Lazy! sync" +qa
  run nvim --headless "+MasonToolsInstallSync" +qa
}

main() {
  log "Repo: $repo_dir"

  if [[ "$install_deps" -eq 1 ]]; then
    install_dependencies
  fi

  if [[ "$install_dotfiles" -eq 1 ]]; then
    install_dotfile_links
  fi

  if [[ "$install_nvim_plugins" -eq 1 ]]; then
    sync_neovim
  fi

  log "Done."
  if [[ "$dry_run" -eq 0 ]]; then
    log "Backups, if any, are in: $backup_dir"
  fi
}

main "$@"
