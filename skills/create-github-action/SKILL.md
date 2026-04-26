---
name: create-github-action
description: >
  Create GitHub Actions workflows for CI/CD automation. Use when setting up automated 
  testing, building, publishing, or any workflow that responds to GitHub events like 
  push, pull requests, or scheduled runs. Special support for devcontainer feature 
  publishing workflows with test discovery and OCI registry publishing. Also applies 
  when the user mentions "create a workflow", "set up GitHub Actions", "automate publishing", 
  or describes CI/CD needs for their repository — even without explicit GitHub Actions 
  knowledge.
license: MIT
compatibility: Requires .github/workflows directory creation
metadata:
  author: agentskills
  version: "1.0.0"
  category: automation
---

# Create GitHub Action

Generate GitHub Actions workflows for various automation scenarios, with special optimization for devcontainer feature publishing.

## Quick Start

To create a workflow:

1. Determine workflow purpose (test, build, publish, custom)
2. Choose trigger events (push, PR, schedule, manual)
3. Define jobs and steps
4. Generate workflow YAML
5. Validate workflow name (must not exist)

## Workflow Types

### Type 1: Devcontainer Feature Publish

Complete workflow for testing and publishing devcontainer features to ghcr.io.

**Features:**
- Auto-discovers all features with test.sh
- Tests each feature in isolated devcontainer
- Publishes all features (skips already published versions)

**Usage:**
```bash
# Default workflow name
.github/workflows/publish-features.yml

# Or custom name
.github/workflows/release.yml
```

**Template:**

```yaml
name: Release devcontainer features

on:
  workflow_dispatch: {}
  push:
    branches: [main]

jobs:
  discover:
    runs-on: ubuntu-latest
    outputs:
      tests: ${{ steps.set-matrix.outputs.tests }}

    steps:
      - uses: actions/checkout@v4

      - id: set-matrix
        run: |
          files=$(find src -name "test.sh" -type f | jq -R -s -c '
            split("\n")[:-1]
            | map({
                path: .,
                name: (split("/")[1]),
                script: ("bash \"" + . + "\"")
              })
          ')
          echo "tests=$files" >> "$GITHUB_OUTPUT"

  test:
    needs: discover
    runs-on: ubuntu-latest
    name: test ${{ matrix.test.name }}
    strategy:
      fail-fast: false
      matrix:
        test: ${{ fromJson(needs.discover.outputs.tests) }}

    steps:
      - uses: actions/checkout@v4
      - name: Run feature test in devcontainer
        uses: devcontainers/ci@v0.3
        with:
          runCmd: ${{ matrix.test.script }}

  publish:
    needs: test
    if: ${{ github.ref == 'refs/heads/main' }}
    runs-on: ubuntu-latest

    permissions:
      contents: read
      packages: write

    steps:
      - uses: actions/checkout@v4

      - name: Publish Features
        uses: devcontainers/action@v1.4.3
        with:
          publish-features: "true"
          base-path-to-features: "./src"
          imageName: "ghcr.io/${{ github.repository }}"
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          FORCE_JAVASCRIPT_ACTIONS_TO_NODE24: "true"
```

### Type 2: Generic Workflow

Custom workflow for any automation need.

**Common patterns:**

**Test on push:**
```yaml
name: Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: ./test.sh
```

**Scheduled job:**
```yaml
name: Nightly
on:
  schedule:
    - cron: '0 0 * * *'
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
```

## Workflow Components

### Triggers (on)

| Trigger | Syntax | When it runs |
|---------|--------|--------------|
| Push | `push: {branches: [main]}` | On push to branch |
| Pull Request | `pull_request:` | On PR open/update |
| Manual | `workflow_dispatch:` | When manually triggered |
| Schedule | `schedule: {cron: '0 0 * * *'}` | On cron schedule |
| Tag | `push: {tags: ['v*']}` | On tag push |

### Jobs

```yaml
jobs:
  job-name:
    runs-on: ubuntu-latest
    needs: other-job  # Optional dependency
    if: github.ref == 'refs/heads/main'  # Optional condition
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Step name
        run: echo "Command here"
        
      - uses: some/action@v1
        with:
          option: value
```

### Matrix Strategy

```yaml
strategy:
  fail-fast: false
  matrix:
    os: [ubuntu-latest, macos-latest]
    node: [16, 18, 20]
```

### Permissions

```yaml
permissions:
  contents: read
  packages: write
  actions: read
```

## Gotchas

- **Workflow file must not exist:** Check before writing
- **YAML indentation:** Must be 2 spaces
- **Secret access:** Use `${{ secrets.NAME }}`
- **Env vars:** Repository-level vs workflow-level vs step-level
- **Action versions:** Use specific versions, not `@main`

## Creating a Workflow

### Step 1: Determine Purpose

Ask: "What should trigger this workflow?"
- Push to main branch?
- Pull request?
- Manual trigger?
- Schedule?

Ask: "What should it do?"
- Test code?
- Build artifacts?
- Publish to registry?
- Deploy?

### Step 2: Choose Workflow Type

**For devcontainer features:**
- Use devcontainer-publish template
- Auto-discovers tests
- Optimized for ghcr.io publishing

**For other projects:**
- Use generic workflow
- Custom triggers
- Custom steps

### Step 3: Validate Name

Workflow files go in `.github/workflows/<name>.yml`

Check: File must not already exist

**Default names:**
- Devcontainer publish: `publish-features.yml`
- Testing: `test.yml`
- Building: `build.yml`
- Releasing: `release.yml`

User can specify custom name.

### Step 4: Generate YAML

Create workflow with:
- Proper YAML structure
- Valid GitHub Actions syntax
- Appropriate triggers
- Required permissions

### Step 5: Present to User

Show generated workflow and ask for confirmation.

## Examples

### Example 1: Devcontainer Feature Workflow

User: "Set up publishing for my devcontainer features"

1. Detect repository has `src/` with features
2. Generate devcontainer-publish workflow
3. Default name: `publish-features.yml`
4. Include test discovery, test job, publish job
5. Present YAML to user
6. Ask user to confirm and commit

### Example 2: Custom Test Workflow

User: "Create a workflow that runs tests on every PR"

1. Determine triggers: `pull_request`
2. Determine job: test runner
3. Generate custom workflow:
   ```yaml
   name: PR Tests
   on: [pull_request]
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - name: Run tests
           run: make test
   ```
4. Write to `.github/workflows/pr-tests.yml`

### Example 3: Multi-Job Workflow

User: "I need a workflow that lints, tests, and builds"

```yaml
name: CI
on: [push, pull_request]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Lint
        run: npm run lint
        
  test:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      - name: Test
        run: npm test
        
  build:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: npm run build
```

## Resources

- `references/workflow-syntax-guide.md` - Complete GitHub Actions syntax
- `references/devcontainer-publish-template.yml` - Full publish workflow
- `references/trigger-types.md` - All trigger options
- `references/permissions-reference.md` - Permission scopes

## Integration with Other Skills

**Called by `manage-devcontainer-feature`:**
- When creating new feature
- User asked: "Set up publishing workflow?"
- Delegates to this skill with devcontainer-publish type

**Cross-reference:**
- `manage-devcontainer-feature` creates features
- `create-github-action` creates workflow to publish them
