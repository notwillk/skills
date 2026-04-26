# GitHub Actions Workflow Syntax Guide

## Workflow Structure

```yaml
name: Workflow Name
on:
  trigger: conditions
env:
  GLOBAL_VAR: value
jobs:
  job-id:
    name: Job Name
    runs-on: ubuntu-latest
    needs: other-job
    if: condition
    env:
      JOB_VAR: value
    steps:
      - name: Step Name
        uses: actions/action@v1
        with:
          input: value
        env:
          STEP_VAR: value
```

## Name

Optional but recommended for identification in UI.

```yaml
name: CI Pipeline
```

## On (Triggers)

### Push

```yaml
on:
  push:
    branches:
      - main
      - develop
    paths:
      - 'src/**'
      - '!src/**/*.md'
```

### Pull Request

```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches:
      - main
```

### Manual Trigger

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy'
        required: true
        default: 'staging'
        type: choice
        options:
          - staging
          - production
```

### Schedule

```yaml
on:
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight UTC
```

### Multiple Triggers

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:
```

## Jobs

### Basic Job

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
```

### Job Dependencies

```yaml
jobs:
  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
```

### Conditional Job

```yaml
jobs:
  deploy:
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
```

### Matrix Strategy

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        node: [16, 18, 20]
        include:
          - os: ubuntu-latest
            node: 14
        exclude:
          - os: windows-latest
            node: 16
```

## Steps

### Run Command

```yaml
steps:
  - name: Run tests
    run: npm test
    
  - name: Multi-line script
    run: |
      echo "Line 1"
      echo "Line 2"
      npm run build
```

### Use Action

```yaml
steps:
  - uses: actions/checkout@v4
  
  - uses: actions/setup-node@v4
    with:
      node-version: '20'
      
  - uses: docker/build-push-action@v5
    with:
      context: .
      push: true
      tags: user/app:latest
```

### Environment Variables

```yaml
steps:
  - name: Set env
    run: |
      echo "MY_VAR=some_value" >> $GITHUB_ENV
      
  - name: Use env
    run: echo $MY_VAR
    
  - name: Step-level env
    env:
      STEP_VAR: value
    run: echo $STEP_VAR
```

## Expressions and Contexts

### GitHub Context

```yaml
${{ github.repository }}      # owner/repo
${{ github.ref }}               # refs/heads/main
${{ github.sha }}               # commit SHA
${{ github.actor }}             # username who triggered
${{ github.event_name }}        # push, pull_request, etc
```

### Job Context

```yaml
${{ job.status }}             # success, failure, cancelled
needs.build.result            # success, failure, skipped
```

### Secrets and Variables

```yaml
${{ secrets.GITHUB_TOKEN }}
${{ secrets.MY_SECRET }}
${{ vars.MY_VARIABLE }}
```

### Conditionals

```yaml
if: github.event_name == 'push'
if: github.ref == 'refs/heads/main'
if: contains(github.event.head_commit.message, 'deploy')
if: failure() || cancelled()
```

## Outputs

### Job Outputs

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.version.outputs.value }}
    steps:
      - id: version
        run: echo "value=1.0.0" >> $GITHUB_OUTPUT
        
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: echo "Version is ${{ needs.build.outputs.version }}"
```

## Permissions

```yaml
permissions:
  contents: read
  packages: write
  actions: read
  
# Or at job level
jobs:
  build:
    permissions:
      contents: read
```

## Services

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
```

## Caching

```yaml
steps:
  - uses: actions/cache@v3
    with:
      path: |
        ~/.npm
        node_modules
      key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
      restore-keys: |
        ${{ runner.os }}-node-
```

## Artifacts

```yaml
steps:
  - name: Upload artifact
    uses: actions/upload-artifact@v4
    with:
      name: my-artifact
      path: dist/
      
  - name: Download artifact
    uses: actions/download-artifact@v4
    with:
      name: my-artifact
```

## Container

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: node:20
      env:
        NODE_ENV: production
      volumes:
        - my_docker_volume:/volume_mount
```

## Reusable Workflows

```yaml
jobs:
  call-workflow:
    uses: owner/repo/.github/workflows/reusable.yml@main
    with:
      input1: value1
    secrets:
      token: ${{ secrets.TOKEN }}
```

## Best Practices

1. **Pin action versions:** Use `@v4` not `@main`
2. **Use environment files:** `$GITHUB_ENV` not `::set-env`
3. **Limit permissions:** Grant only needed permissions
4. **Fail fast:** `fail-fast: false` for matrix when needed
5. **Cache dependencies:** Speed up workflows
6. **Use conditions:** Skip unnecessary jobs
7. **Name steps:** Makes logs readable
8. **Timeout:** Set `timeout-minutes` for long jobs
