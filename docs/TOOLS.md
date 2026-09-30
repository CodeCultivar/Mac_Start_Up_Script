# Tools reference

What each installed tool is for, with a quick example.

## Git & GitHub

| Tool | What it does | Try it |
| --- | --- | --- |
| `git` | Version control | `git status` |
| `gh` | GitHub from the terminal: repos, pull requests, issues | `gh repo create`, `gh pr create`, `gh pr list` |
| `delta` | Colorful, side-by-side-friendly `git diff` output (used automatically) | `git diff` |
| `pre-commit` | Runs checks such as linters before each commit | `pre-commit install` in a repo with a `.pre-commit-config.yaml` |

## Python

| Tool | What it does | Try it |
| --- | --- | --- |
| `uv` | Fast Python package and project manager | `uv init my-project`, `uv add requests`, `uv run main.py` |
| `ruff` | Linter and formatter | `ruff check .`, `ruff format .` |
| `pytest` | Test runner | `pytest` |
| `mypy` | Type checker | `mypy .` |
| `ipython` | Friendlier interactive Python shell | `ipython` |

## Go

| Tool | What it does | Try it |
| --- | --- | --- |
| `go` | The Go toolchain | `go mod init example.com/hello`, `go run .` |
| `gopls` | Language server that powers editor autocomplete | Used automatically by VS Code's Go extension |
| `dlv` | Debugger | `dlv debug` |
| `golangci-lint` | Runs many Go linters at once | `golangci-lint run` |

## React / Node.js

| Tool | What it does | Try it |
| --- | --- | --- |
| `fnm` | Installs and switches Node.js versions; switches automatically in folders with a `.nvmrc` or `.node-version` file | `fnm list`, `fnm install 20` |
| `node` / `npm` | Runs JavaScript; installs packages | `npm install`, `npm run dev` |
| `pnpm` | Faster, disk-efficient alternative to npm | `pnpm install`, `pnpm dev` |

New React app: `npm create vite@latest my-app -- --template react-ts`

## Terminal tools

| Tool | What it does | Try it |
| --- | --- | --- |
| `rg` (ripgrep) | Search inside files, very fast | `rg "TODO"` |
| `fd` | Find files by name | `fd config` |
| `fzf` | Fuzzy finder | <kbd>Ctrl</kbd>+<kbd>R</kbd> searches history, <kbd>Ctrl</kbd>+<kbd>T</kbd> picks a file |
| `bat` | `cat` with syntax highlighting and line numbers | `bat README.md` |
| `jq` | Read and filter JSON | `curl -s https://api.github.com/users/octocat \| jq .name` |
| `tree` | Show a folder's structure | `tree -L 2` |
| `wget` | Download files | `wget <url>` |
| `htop` | See what's using CPU and memory | `htop` (press <kbd>q</kbd> to quit) |
| `direnv` | Load per-project environment variables from `.envrc` | `echo 'export API_KEY=abc' > .envrc && direnv allow` |

## Apps

- **iTerm2**: a more capable replacement for the built-in Terminal app (split panes, search, profiles).
- **Sublime Text**: a fast, lightweight text editor.

## VS Code extensions

Installed only if the `code` command is available:

- **ESLint** (`dbaeumer.vscode-eslint`): highlights JavaScript/TypeScript mistakes.
- **Prettier** (`esbenp.prettier-vscode`): formats code consistently.
- **Tailwind CSS IntelliSense** (`bradlc.vscode-tailwindcss`): autocomplete for Tailwind classes.
