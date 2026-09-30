#!/usr/bin/env bash
# macOS developer setup: Python, Go, Node/React and GitHub. Safe to re-run.
set -euo pipefail

echo "==> Xcode command line tools"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install || true
  echo "Finish the Xcode tools install popup, then re-run this script."
  exit 0
fi

echo "==> Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make brew available now and in future shells (Apple Silicon or Intel)
if [ -x /opt/homebrew/bin/brew ]; then BREW=/opt/homebrew/bin/brew; else BREW=/usr/local/bin/brew; fi
eval "$($BREW shellenv)"
if ! grep -q 'brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
  echo "eval \"\$($BREW shellenv)\"" >> "$HOME/.zprofile"
fi

echo "==> Git, GitHub CLI, Python (via uv), Go"
brew install git gh go uv python

echo "==> Everyday CLI tools"
# jq: JSON; ripgrep/fd: fast search; fzf: fuzzy finder; bat: better cat;
# tree/wget/htop: basics; direnv: per-project env vars; pre-commit: git hooks;
# golangci-lint: Go linter bundle; git-delta: nicer git diffs
brew install jq ripgrep fd fzf bat tree wget htop direnv pre-commit golangci-lint git-delta

echo "==> Apps (iTerm2, Sublime Text)"
# Skip apps already installed outside Homebrew, or brew would error
[ -d "/Applications/iTerm.app" ] || brew install --cask iterm2
[ -d "/Applications/Sublime Text.app" ] || brew install --cask sublime-text

echo "==> Git config"
if [ -z "$(git config --global user.name || true)" ]; then
  read -r -p "Your name for git commits: " GIT_NAME
  git config --global user.name "$GIT_NAME"
fi
if [ -z "$(git config --global user.email || true)" ]; then
  read -r -p "Your email for git commits (use your GitHub email): " GIT_EMAIL
  git config --global user.email "$GIT_EMAIL"
fi
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global push.autoSetupRemote true
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
if [ ! -f "$HOME/.gitignore_global" ]; then
  printf '.DS_Store\n.env\n.venv/\n__pycache__/\n*.pyc\n.idea/\n' > "$HOME/.gitignore_global"
fi
git config --global core.excludesfile "$HOME/.gitignore_global"

echo "==> SSH key for GitHub"
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
  ssh-keygen -t ed25519 -C "$(git config --global user.email)" -f "$HOME/.ssh/id_ed25519" -N ""
fi
if ! grep -q 'UseKeychain' "$HOME/.ssh/config" 2>/dev/null; then
  printf 'Host github.com\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_ed25519\n' >> "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
fi
ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519" 2>/dev/null || true

echo "==> Shell hooks (direnv, fzf)"
if ! grep -q 'direnv hook zsh' "$HOME/.zshrc" 2>/dev/null; then
  echo 'eval "$(direnv hook zsh)"' >> "$HOME/.zshrc"
fi
if ! grep -q 'fzf --zsh' "$HOME/.zshrc" 2>/dev/null; then
  echo 'source <(fzf --zsh)' >> "$HOME/.zshrc"
fi

echo "==> Go PATH"
if ! grep -q 'go env GOPATH' "$HOME/.zshrc" 2>/dev/null; then
  echo 'export PATH="$PATH:$(go env GOPATH)/bin"' >> "$HOME/.zshrc"
fi

echo "==> Go tools (language server, debugger)"
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest

echo "==> Python tools"
uv tool install ruff
uv tool install pytest
uv tool install mypy
uv tool install ipython
uv tool update-shell || true

echo "==> Node.js (via fnm) for React"
# fnm manages Node versions; --use-on-cd switches versions per project (.nvmrc / .node-version)
brew install fnm
if ! grep -q 'fnm env' "$HOME/.zshrc" 2>/dev/null; then
  echo 'eval "$(fnm env --use-on-cd --shell zsh)"' >> "$HOME/.zshrc"
fi
eval "$(fnm env --shell bash)"
fnm install --lts
fnm default lts-latest
fnm use lts-latest
# pnpm: fast package manager; start new React apps with `npm create vite@latest`
npm install -g pnpm

echo "==> VS Code extensions for React"
if command -v code >/dev/null 2>&1; then
  code --install-extension dbaeumer.vscode-eslint
  code --install-extension esbenp.prettier-vscode
  code --install-extension bradlc.vscode-tailwindcss
else
  echo "VS Code 'code' command not found; skipping extensions."
fi

echo "==> GitHub login"
# Last, so a failed login doesn't stop the rest of the setup
if gh auth status >/dev/null 2>&1; then
  echo "Already logged in to GitHub."
else
  echo "Look for 'First copy your one-time code: XXXX-XXXX' below."
  echo "Copy that code, press Enter, then paste it into the GitHub page."
  # Also uploads the SSH key above to your GitHub account
  if ! gh auth login --hostname github.com --git-protocol ssh --web; then
    echo "GitHub login didn't finish. Run 'gh auth login' later to try again."
  fi
fi
if gh auth status >/dev/null 2>&1; then
  gh auth setup-git
fi

echo
echo "==> Versions"
python3 --version
uv --version
go version
git --version
gh --version | head -1
echo "node $(node --version)"
echo "npm $(npm --version)"
echo "pnpm $(pnpm --version)"
echo
echo "Done. Open a new terminal window so PATH changes load."
echo "Test GitHub SSH with: ssh -T git@github.com"
echo "Start a React app with: npm create vite@latest my-app -- --template react-ts"
echo "Also install the React Developer Tools extension in your browser."
