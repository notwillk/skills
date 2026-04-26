# Versioning Guide for Devcontainer Features

## Semantic Versioning Rules

Features follow [SemVer](https://semver.org/):

```
MAJOR.MINOR.PATCH
```

### When to Bump PATCH

- Bug fixes in `install.sh`
- URL updates (same mechanism)
- Version default updates
- Documentation changes
- Test improvements
- Config/description updates in `devcontainer-feature.json`

**Examples:**
- Fixed typo in download URL
- Updated default version from 1.0 to 1.1
- Improved error handling
- Fixed architecture detection

### When to Bump MINOR

- New options added
- Install mechanism changed
- Dependencies added/removed/changed
- New functionality added
- Lifecycle hooks added

**Examples:**
- Added `version` option
- Changed from apt install to binary download
- Added `dependsOn` for node feature
- Added `postCreateCommand`

### When to Bump MAJOR

- Breaking changes to existing options
- Removing options
- Changing option defaults in incompatible way
- Feature becomes incompatible with previous usage

**Note:** Breaking changes should be rare. Consider using new option instead.

**Examples:**
- Removed `installPath` option
- Changed `version` option to require specific format
- Feature no longer supports certain architectures

## Auto-Detection Rules

### Content Change Detection

| File Changed | Change Type | Bump |
|--------------|-------------|------|
| `install.sh` | Bugfix, same mechanism | patch |
| `install.sh` | Mechanism changed | minor |
| `devcontainer-feature.json` | Description only | patch |
| `devcontainer-feature.json` | New option | minor |
| `devcontainer-feature.json` | Dependencies changed | minor |
| `test.sh` | Any change | patch |
| `README.md` | Any change | patch |

### Mechanism Change Detection

Compare old vs new `install.sh`:

- Same tool (curl, wget) → **patch**
- Different download method (curl → npm) → **minor**
- Package manager change (apt → pip) → **minor**
- Build from source added → **minor**

### Dependencies Change Detection

- Adding `dependsOn` → **minor**
- Adding `installsAfter` → **patch** (soft dependency)
- Removing dependencies → **minor** (could break)
- Changing dependency options → **minor**

## Version Bump Process

1. **Detect changes** using `detect-repo-changes`
2. **Analyze each change** for impact
3. **Determine highest bump** needed (patch < minor < major)
4. **Confirm with user** showing reasoning
5. **Update version** in `devcontainer-feature.json`
6. **Commit with message** describing change

## Examples

### Example 1: Bug Fix

```
Change: Fixed typo in download URL
Files: install.sh
Bump: 1.0.0 → 1.0.1 (patch)
```

### Example 2: New Option

```
Change: Added version option
Files: devcontainer-feature.json (new option), install.sh (use VERSION)
Bump: 1.0.1 → 1.1.0 (minor)
```

### Example 3: Mechanism Change

```
Change: Switched from apt install to binary download
Files: install.sh (complete rewrite)
Bump: 1.1.0 → 1.2.0 (minor)
```

### Example 4: New Dependency

```
Change: Added node as dependsOn for npm-based install
Files: devcontainer-feature.json (new dependsOn)
Bump: 1.2.0 → 1.3.0 (minor)
```

## Multiple Changes

When multiple files change:

1. Analyze each independently
2. Take the **highest** bump required
3. Single version bump covers all changes

```
Changes:
- install.sh: bugfix (patch)
- devcontainer-feature.json: new option (minor)
- test.sh: improved (patch)

Result: 1.0.0 → 1.1.0 (minor)
```

## Starting Versions

New features always start at `1.0.0`.

Pre-release features can use `0.x.x` but should migrate to `1.0.0` for stability.

## Version Conflicts

If calculated new version already exists:

1. Inform user: "Version 1.0.1 already published"
2. Options:
   - Skip (no changes needed)
   - Force next version (1.0.2)
   - Major bump (1.1.0)

Publishing tools are idempotent, so re-publishing same version is safe but unnecessary.
