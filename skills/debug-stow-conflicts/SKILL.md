---
name: debug-stow-conflicts
description: >
  Diagnose and resolve GNU Stow failures, conflicts, and unsafe symlink states.
  Use when a Stow command reports conflicts, refuses to stow because target
  paths already exist, needs ownership checks, has tree folding or refolding
  surprises, involves risky flags such as --adopt, --defer, --override,
  --ignore, or --no-folding, uses multiple stow directories, or requires a safe
  dry-run troubleshooting workflow. For clean happy-path stow/restow workflows,
  prefer manage-stow-packages or manage-stow-dotfiles.
---

# Debug Stow Conflicts

Use this skill when Stow cannot safely create, remove, split, or refold links.
Start from observation and simulation. Do not remove user files to make Stow
succeed unless the user explicitly approves that change.

## Skill Boundaries

- Use this skill for failures, conflicts, risky migration flags, ownership
  checks, overlapping packages, and unexpected folding/refolding behavior.
- Use `manage-stow-packages` for clean package stow, unstow, restow, and layout
  planning without a reported conflict.
- Use `manage-stow-dotfiles` for happy-path dotfiles repository setup or
  dotfile package organization before conflicts appear.

## Conflict Triage

1. Capture the exact command, working directory, Stow version, and output.
2. Re-run as a dry-run with more verbosity, preserving the same `-d`, `-t`, and
   package arguments:

```bash
stow -n -vv -d /path/to/stow-dir -t /path/to/target package
```

3. Identify every conflict path and classify it:

- Existing ordinary file in the target tree.
- Existing directory containing non-Stow content.
- Symlink pointing outside the active stow directory.
- Symlink pointing into a different stow directory.
- Path already owned by another Stow package.
- Path ignored, deferred, or overridden by options.

4. Inspect paths without following symlinks:

```bash
ls -ld /path/to/target/path
readlink /path/to/target/path
```

5. Inspect the corresponding package path:

```bash
find /path/to/stow-dir/package -maxdepth 4 -print
```

6. If the command relied on default directories, make them explicit before
   continuing. Wrong working directory is a common source of misleading
   conflicts.

## Ownership Rules

Stow owns a target-tree item only when it is a symlink pointing into a package
under the current stow directory. It can remove or recompute owned links. It
does not own:

- Plain files in the target tree.
- Directories containing real files.
- Symlinks pointing outside the active stow directory.
- Files or directories inside package directories.

When a path is not owned by Stow, preserve it or ask before changing it.

## Resolution Patterns

Existing target file:

- Compare it with the intended package file.
- Move it into the package manually if it should be managed by Stow.
- Move it aside only with user approval.
- Use `--adopt` only when the user accepts that existing target files will be
  moved into the package's installation image.
- After any manual move, rerun `stow -n -v ...` before applying.

Existing target directory:

- If it contains real user files, do not remove it.
- Let Stow descend into it and create links where possible.
- Use `--no-folding` if folded subtree links would make the target harder to
  inspect or share between packages.

Link owned by another package:

- Use `--defer=REGEX` when the current package should skip paths already stowed
  by another package.
- Use `--override=REGEX` only when the current package should intentionally
  replace another package's link for matching paths.
- Restow affected packages after changing overlap policy.

Multiple stow directories:

- Identify which stow directory owns each symlink by resolving its target.
- Prefer running Stow from the owning stow directory when splitting or deleting
  folded links.
- Avoid assuming one stow directory can safely manipulate links owned by
  another.

Ignored generated files:

```bash
stow -n -v --ignore='\.DS_Store' --ignore='.*~' -d /stow -t /target package
```

## Tree Folding Problems

Stow may fold a whole directory into one symlink, split a folded symlink open
when another package needs the same subtree, and refold a directory when only
one package remains.

When folding behavior is surprising:

```bash
ls -ld /target/shared-path
readlink /target/shared-path
find /stow -maxdepth 3 -path '*/shared-path*' -print
```

Check whether the folded symlink points inside a valid package in the current
stow directory. With multiple stow directories, Stow can fail to split folded
links that point into a cooperating stow directory other than the one currently
in use. In that case, use the stow directory that owns the folded link, or
manually unfold with explicit user approval.

## Empty Directory Bug

Stow 2.4.1 has a known empty-directory issue: if one package needs an empty
directory and another package later causes that directory to be split open,
unstowing the second package can remove the target directory even though the
first package still needs it. Work around this by adding a placeholder file to
the package's empty directory, such as `.placeholder`.

## Safe Use of --adopt

`--adopt` changes the stow directory. When a target file exists and is not owned
by Stow, the file is moved into the same relative path inside the package
directory, then Stow proceeds.

Use this checklist before adopting:

- Confirm the package path exists or can be created.
- Run `stow -n -v --adopt ...` first.
- Ensure the package directory is in version control or backed up.
- After the real run, inspect changes in the package directory immediately.
- If the package already contains a file at that path, compare before adopting;
  do not silently replace curated package contents with target contents.

Example:

```bash
stow -n -v --adopt -d ~/dotfiles -t "$HOME" zsh
stow -v --adopt -d ~/dotfiles -t "$HOME" zsh
git -C ~/dotfiles diff -- zsh
```

## Final Report

For conflict work, report:

- The exact conflict paths.
- Which paths Stow owns and which it does not.
- The least destructive resolution chosen.
- Commands run, especially whether they were dry-runs or applied.
- Any remaining manual review needed before committing or deleting files.
