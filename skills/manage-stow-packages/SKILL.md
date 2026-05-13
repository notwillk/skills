---
name: manage-stow-packages
description: >
  Manage general GNU Stow symlink farms for software, tools, or data packages
  outside specialized dotfile migrations. Use when the user wants to create,
  inspect, stow, unstow/delete, restow, or reorganize Stow packages; choose stow
  and target directories; configure .stowrc; run safe dry-runs; or reason about
  package directories, installation images, relative symlinks, target trees, and
  tree folding. Prefer manage-stow-dotfiles for home dotfiles and
  debug-stow-conflicts when Stow reports conflicts or unsafe existing paths.
---

# Manage Stow Packages

Use this skill to manage GNU Stow packages safely and predictably. Prefer
explicit stow and target directories, simulate first, and explain which files
Stow owns before changing anything.

## Skill Boundaries

- Use this skill for normal package lifecycle work: layout, stow, unstow,
  restow, `.stowrc`, target selection, and tree folding.
- Use `manage-stow-dotfiles` when the target is `$HOME` and the task is about
  hidden configuration files, `dot-` names, or dotfiles repository migration.
- Use `debug-stow-conflicts` when a Stow command has failed, reports conflicts,
  needs ownership triage, or involves `--adopt`, `--defer`, or `--override` as
  the main problem.

## Core Model

- Package: a named directory inside the stow directory.
- Stow directory: the directory containing package directories. If `-d` is not
  set, Stow uses `STOW_DIR` or the current directory.
- Package directory: the package's installation image rooted at
  `<stow-dir>/<package>`.
- Target directory: the tree where the package should appear installed. If
  `-t` is not set, Stow uses the parent of the stow directory.
- Installation image: the package layout relative to the target, such as
  `bin/tool`, `share/man/man1/tool.1`, or `lib/tool/plugin`.
- Ownership: Stow owns target-tree symlinks that point into a package in the
  current stow directory. It can remove or recompute those links. It does not
  own ordinary files or directories in package directories.

Stow creates relative symlinks. It may also fold an entire target subtree into
a single symlink when no other package needs to share that subtree.

## Safe Workflow

1. Confirm Stow is available and note the version when behavior matters:

```bash
stow --version
```

2. Identify the stow directory, target directory, action, and packages. Prefer
   explicit `-d` and `-t` in commands you suggest or run.
3. Inspect package layout before stowing:

```bash
find /path/to/stow-dir/package -maxdepth 3 -print
```

4. Simulate with verbosity before mutating the filesystem:

```bash
stow -n -v -d /path/to/stow-dir -t /path/to/target package
```

5. If the dry-run is clean, run the same command without `-n`:

```bash
stow -v -d /path/to/stow-dir -t /path/to/target package
```

6. Verify created links point where expected:

```bash
find /path/to/target -maxdepth 3 -type l -ls
```

When paths affect a user's home directory or a system prefix such as
`/usr/local`, preserve a dry-run summary in the response before making changes
unless the user explicitly requested immediate execution.

If the dry-run reports conflicts, stop the package workflow and switch to
`debug-stow-conflicts`.

## Common Operations

Stow one or more packages:

```bash
stow -n -v -d /usr/local/stow -t /usr/local perl emacs
stow -v -d /usr/local/stow -t /usr/local perl emacs
```

Unstow packages from the target tree without deleting the package directory:

```bash
stow -n -v -D -d /usr/local/stow -t /usr/local perl
stow -v -D -d /usr/local/stow -t /usr/local perl
```

Restow after a package update, first unstowing obsolete symlinks and then
stowing current files:

```bash
stow -n -v -R -d /usr/local/stow -t /usr/local perl
stow -v -R -d /usr/local/stow -t /usr/local perl
```

Mix actions in one command only when the intent is clear:

```bash
stow -v -d /usr/local/stow -t /usr/local -D oldpkg -S newpkg
```

## Tree Folding

Stow tries to create as few symlinks as possible. If a target subtree is empty
and only one package needs it, Stow may create one symlink for the whole
subtree. If another package later needs files in that subtree, Stow can split
the folded symlink into a real directory containing links to both packages.

When explaining or debugging folding:

- Check whether a target path is a symlink or real directory.
- Confirm the symlink points inside a valid package in the active stow
  directory before expecting Stow to split it.
- Use `--no-folding` if the user wants individual links and directories instead
  of folded subtree links.

## Resource Files

Stow reads default options from `.stowrc` in the current directory, then
`~/.stowrc`; if both exist, their options are effectively appended. Use
resource files for stable defaults such as:

```text
--dir=/path/to/stow-dir
--target=/path/to/target
--ignore='\.DS_Store'
```

Do not rely on `.stowrc` for actions or package names: `-S`, `-D`, `-R`, and
packages listed in a resource file are ignored by Stow.

## Handling Existing Target Paths

If a target path already exists and is not owned by Stow, Stow reports a
conflict and refuses to proceed. Do not delete or overwrite such paths
automatically. Choose one of these paths:

- Move the existing target file aside after confirming with the user.
- Convert it into the package directory manually, then stow.
- Use `--adopt` only when the user understands that Stow will move existing
  target files into the package's installation image.
- Use `--defer=REGEX` or `--override=REGEX` only for known overlapping paths
  between packages.

When the user's goal is to resolve one of these cases rather than simply
understand the options, use `debug-stow-conflicts`.

## Response Checklist

When completing a Stow package task, report:

- Stow directory and target directory used.
- Packages and actions performed.
- Whether the command was simulated or applied.
- Any conflicts, ignored paths, or ownership assumptions.
- Suggested verification command if the user should inspect the resulting links.
