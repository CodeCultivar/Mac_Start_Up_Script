# Mac Start Up Script

One script that turns a fresh Mac into a ready-to-use development machine for
**Python**, **Go**, **React/Node.js** and **GitHub**.

Run it once on a new Mac. If it stops partway through, fix the problem and run it
again: steps that are already done are skipped.

## What you get

| Area | Installed |
| --- | --- |
| Basics | Xcode Command Line Tools, Homebrew |
| Git & GitHub | Git, GitHub CLI (`gh`), SSH key, sensible Git defaults |
| Python | Python, [uv](https://docs.astral.sh/uv/), ruff, pytest, mypy, IPython |
| Go | Go, gopls (language server), Delve (debugger), golangci-lint |
| React / Node.js | Node.js LTS (via fnm), npm, pnpm |
| Terminal tools | jq, ripgrep, fd, fzf, bat, tree, wget, htop, direnv, pre-commit, git-delta |
| Apps | iTerm2, Sublime Text |
| VS Code | ESLint, Prettier and Tailwind CSS extensions (if the `code` command is available) |

See [docs/TOOLS.md](docs/TOOLS.md) for what each tool does and how to use it.

## Requirements

- macOS on Apple Silicon or Intel
- An administrator account (you'll be asked for your Mac password)
- An internet connection
- A [GitHub account](https://github.com/signup)

## Quick start

### One-line install

Open the **Terminal** app and paste:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/CodeCultivar/Mac_Start_Up_Script/main/setup-dev.sh)
```

Then skip to step 4 below. It's a good habit to
[read the script](setup-dev.sh) before running anything from the internet.

### Step by step

1. **Get the script.** On this page, click **Code → Download ZIP** and unzip it,
   or, if you already have Git:

   ```bash
   git clone https://github.com/CodeCultivar/Mac_Start_Up_Script.git
   ```

2. **(Optional) Enable the VS Code `code` command.** In VS Code, press
   <kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> and choose
   **Shell Command: Install 'code' command in PATH**. Without it, the script
   skips the VS Code extensions.

3. **Run it** from the **Terminal** app (not VS Code's built-in terminal):

   ```bash
   cd ~/Downloads/Mac_Start_Up_Script   # or wherever you put it
   bash setup-dev.sh
   ```

4. **Open a new terminal window** when it finishes, so the changes take effect.

5. **Check GitHub works:**

   ```bash
   ssh -T git@github.com
   ```

   The first time, type `yes` to trust GitHub. You should then see
   `Hi <your-username>! You've successfully authenticated...`.

## What to expect while it runs

The whole run usually takes 15–30 minutes. You'll be asked for input a few times:

1. **Xcode tools popup** (fresh Macs only). Click **Install** and wait for it to
   finish. The script stops here; run it again afterwards.
2. **Mac password** for Homebrew. Nothing appears on screen as you type; that's normal.
3. **Your name and email** for Git commits. Use the email on your GitHub account.
4. **GitHub login** at the very end. The terminal prints a line like
   `First copy your one-time code: AB12-CD34`. Copy that code, press
   <kbd>Enter</kbd>, and paste it into the GitHub page that opens. When asked,
   say **yes** to uploading your SSH key.

## What it changes on your Mac

Besides installing software, the script edits a few settings files in your home
folder. Each change is added only once, so re-running is safe.

| File | Change |
| --- | --- |
| `~/.zprofile` | Loads Homebrew |
| `~/.zshrc` | Adds Go tools to your PATH and turns on direnv, fzf and fnm |
| `~/.gitconfig` | Your name and email; `main` as the default branch; delta for diffs; auto-set upstream on first push |
| `~/.gitignore_global` | Ignores `.DS_Store`, `.env`, `.venv/`, `__pycache__/`, `*.pyc`, `.idea/` in every repo |
| `~/.ssh/id_ed25519` | New SSH key (only if you don't have one) |
| `~/.ssh/config` | Stores the SSH key in the macOS Keychain |

> **Note:** the SSH key is created **without a passphrase**, so the script can run
> without stopping. That's fine for a personal Mac. To add one later, run
> `ssh-keygen -p -f ~/.ssh/id_ed25519`.

## After setup

Start a React app and put it on GitHub:

```bash
mkdir -p ~/code && cd ~/code
npm create vite@latest my-app -- --template react-ts
cd my-app && npm install
git init && git add . && git commit -m "Initial commit"
gh repo create my-app --private --source=. --push
npm run dev
```

Also install the **React Developer Tools** extension in your browser.

## Updating your tools later

```bash
brew update && brew upgrade   # Homebrew packages and apps
uv tool upgrade --all         # Python tools
fnm install --lts             # newest Node.js LTS
```

For Go tools, re-run the `go install ...@latest` lines from the script.

## Troubleshooting

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for common problems and fixes.

## Customizing

The script is plain Bash, split into labeled sections (`echo "==> ..."`). To add
a Homebrew tool, add it to one of the `brew install` lines. To skip something,
delete or comment out its section.

## License

[MIT](LICENSE)
