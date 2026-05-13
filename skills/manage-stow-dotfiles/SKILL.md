---
name: manage-stow-dotfiles
description: >
  Manage home-directory dotfiles and hidden configuration files with GNU Stow.
  Use when the user wants to organize a dotfiles repository, stow configuration
  into $HOME or ~/.config, use --dotfiles with dot- prefixed paths, migrate or
  adopt existing dotfiles, write dotfile-focused .stowrc defaults, restow
  dotfile packages, or troubleshoot hidden-file layouts. Prefer
  debug-stow-conflicts for failed Stow commands and manage-stow-packages for
  non-dotfile software package farms.
---

# Manage Stow Dotfiles

Use this skill for GNU Stow workflows where the target directory is usually the
user's home directory and the package directories live in a dotfiles repository.
Treat existing home-directory files as user data until proven otherwise.

## Skill Boundaries

- Use this skill for dotfiles repositories, `$HOME` targets, `~/.config`,
  `--dotfiles`, `dot-` prefix mapping, and migration of existing hidden config.
- Use `debug-stow-conflicts` if Stow has already produced a conflict or if the
  task is mainly about `--adopt`, ownership, overlapping packages, or unsafe
  target paths.
- Use `manage-stow-packages` for general software package farms such as
  `/usr/local/stow` to `/usr/local`.

## Recommended Layout

Use one package directory per tool or concern:

```text
~/dotfiles/
  zsh/
    dot-zshrc
    dot-zprofile
  git/
    dot-gitconfig
    dot-config/git/ignore
  nvim/
    dot-config/nvim/init.lua
```

With `--dotfiles`, Stow maps package entries that begin with `dot-` to target
entries beginning with `.`. For example:

- `zsh/dot-zshrc` becomes `~/.zshrc`
- `nvim/dot-config/nvim/init.lua` becomes `~/.config/nvim/init.lua`

Files not beginning with `dot-` are processed normally.

## Safe Dotfile Workflow

1. Confirm Stow is available and note the version when behavior matters:

```bash
stow --version
```

2. Identify the dotfiles repository and target home:

```bash
pwd
printf '%s\n' "$HOME"
```

3. Inspect package contents:

```bash
find ~/dotfiles/zsh -maxdepth 4 -print
```

4. Dry-run with explicit paths:

```bash
stow -n -v --dotfiles -d ~/dotfiles -t "$HOME" zsh
```

5. Resolve conflicts before applying. If conflicts are non-trivial, switch to
   `debug-stow-conflicts`.
6. Apply the same command without `-n`:

```bash
stow -v --dotfiles -d ~/dotfiles -t "$HOME" zsh
```

7. Verify links:

```bash
ls -la ~/.zshrc ~/.config 2>/dev/null
```

Prefer one package at a time for migration work so conflicts are easier to
understand and reverse.

## .stowrc Defaults

For a dotfiles repository, a local `.stowrc` can reduce command repetition:

```text
--target=~
--dotfiles
--ignore='\.DS_Store'
--ignore='\.git'
```

Run Stow from the repository root when using this pattern:

```bash
stow -n -v zsh git nvim
stow -v zsh git nvim
```

Remember: `.stowrc` path options expand `~` and environment variables, but
action flags (`-S`, `-D`, `-R`) and package names inside `.stowrc` are ignored.

## Migrating Existing Dotfiles

If a target file such as `~/.zshrc` already exists, Stow normally reports a
conflict because the file is not owned by Stow. Choose deliberately:

- Preserve first: move the existing file into the package, then stow.
- Compare first: keep the existing file in place, diff it against the package
  version, then decide.
- Adopt only with care: `--adopt` moves existing target files into the package
  directory before creating links.

Safe manual migration:

```bash
mkdir -p ~/dotfiles/zsh
mv ~/.zshrc ~/dotfiles/zsh/dot-zshrc
stow -n -v --dotfiles -d ~/dotfiles -t "$HOME" zsh
stow -v --dotfiles -d ~/dotfiles -t "$HOME" zsh
```

Careful adoption workflow:

```bash
stow -n -v --adopt --dotfiles -d ~/dotfiles -t "$HOME" zsh
stow -v --adopt --dotfiles -d ~/dotfiles -t "$HOME" zsh
git -C ~/dotfiles diff -- zsh
```

After `--adopt`, inspect the repository diff before committing because adopted
target contents may overwrite the package copy.

If a repository already has package files and the target has divergent real
files, preserve both versions for comparison before adopting or moving files.

## Restowing Dotfiles

Use restow after renaming or removing files inside a package:

```bash
stow -n -v -R --dotfiles -d ~/dotfiles -t "$HOME" zsh
stow -v -R --dotfiles -d ~/dotfiles -t "$HOME" zsh
```

Restow prunes obsolete symlinks that still point into the package and then
creates current symlinks.

## Gotchas

- Do not store package files as hidden files when using `--dotfiles`; use the
  `dot-` prefix for target hidden files.
- Do not run from the wrong directory if relying on `.stowrc`; `.` and the
  parent directory determine defaults when `-d` or `-t` are omitted.
- Empty directories can disappear during unstow in some package combinations.
  Use a placeholder such as `.placeholder` when an empty directory must remain.
- Stow does not delete the package directory when unstowing; it only removes
  owned target links and foldable directories.
- Do not use `--adopt` as a convenience flag during routine stowing. Use it as
  a migration operation and review the resulting repository diff immediately.

## Response Checklist

When finishing a dotfiles task, state:

- Dotfiles repository and home target used.
- Packages stowed, unstowed, or restowed.
- Whether `--dotfiles`, `.stowrc`, or `--adopt` was used.
- Conflicts found and how they were handled.
- Any files the user should review before committing.
