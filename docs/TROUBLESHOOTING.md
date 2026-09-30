# Troubleshooting

The script is safe to re-run. For most problems, fix the cause and run
`bash setup-dev.sh` again.

## The script stopped after the Xcode popup

That's expected on a fresh Mac. Finish the Xcode Command Line Tools install
(it can take 10–20 minutes), then run the script again.

## "command not found" after the script finishes

The terminal window you ran the script in doesn't know about the new tools yet.
Open a **new** terminal window, or run:

```bash
source ~/.zprofile && source ~/.zshrc
```

## GitHub login: I can't find the code

GitHub doesn't send you the code. It's printed **in the terminal**, on a line like:

```
! First copy your one-time code: AB12-CD34
Press Enter to open https://github.com/login/device in your browser...
```

Copy the code **before** pressing <kbd>Enter</kbd>, because the browser opens on
top of the terminal. To try again:

```bash
gh auth login --hostname github.com --git-protocol ssh --web
```

### Log in with a token instead

1. On GitHub, go to **Settings → Developer settings → Personal access tokens →
   Tokens (classic) → Generate new token**.
2. Tick **repo**, **read:org** and **admin:public_key**, then generate and copy it.
3. Run the following, paste the token, press <kbd>Enter</kbd>, then <kbd>Ctrl</kbd>+<kbd>D</kbd>:

   ```bash
   gh auth login --git-protocol ssh --with-token
   ```

## `ssh -T git@github.com` asks "Are you sure you want to continue connecting?"

Normal the first time. Type `yes`. GitHub's ED25519 fingerprint is
`SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU`
([GitHub's published fingerprints](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints)).

## `Permission denied (publickey)`

Your SSH key isn't on your GitHub account. Upload it:

```bash
gh ssh-key add ~/.ssh/id_ed25519.pub --title "My Mac"
```

If that fails with a permissions error, run `gh auth refresh -s admin:public_key`
first, then try again.

## "It seems there is already an App at ..."

Homebrew won't overwrite an app installed another way. The script already skips
iTerm2 and Sublime Text if they're in `/Applications`. For any other app, either
delete it from `/Applications` or remove it from the script.

## VS Code extensions were skipped

The `code` command isn't set up. In VS Code, press
<kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd>, choose
**Shell Command: Install 'code' command in PATH**, then run the script again.

## Homebrew asks for a password and nothing appears as I type

That's normal. macOS hides password input. Type it and press <kbd>Enter</kbd>.

## Starting over on part of the setup

- Change your Git name or email:
  `git config --global user.name "New Name"` / `git config --global user.email "you@example.com"`
- Undo shell changes: open `~/.zshrc` or `~/.zprofile` in an editor and delete the lines you don't want.
