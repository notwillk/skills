# GitHub Actions Trigger Types

## workflow_dispatch (Manual)

Run workflow manually from UI or API.

```yaml
on:
  workflow_dispatch:
    inputs:
      logLevel:
        description: 'Log level'
        required: true
        default: 'warning'
        type: choice
        options:
          - info
          - warning
          - debug
      tags:
        description: 'Test scenario tags'
        required: false
        type: string
      dry_run:
        description: 'Dry run'
        required: false
        type: boolean
        default: false
```

## push

Run on code push.

```yaml
on:
  push:
    branches:
      - main
      - develop
      - 'releases/**'
    tags:
      - 'v*'
    paths:
      - 'src/**'
      - '!**.md'
```

## pull_request

Run on pull request activity.

```yaml
on:
  pull_request:
    types: [opened, reopened, synchronize]
    branches:
      - main
    paths:
      - 'src/**'
```

**Available types:**
- `opened`
- `reopened`
- `synchronize` (new commits)
- `edited`
- `closed`
- `labeled`
- `unlabeled`

## schedule

Run on cron schedule.

```yaml
on:
  schedule:
    - cron: '0 0 * * *'     # Daily at midnight
    - cron: '0 */6 * * *'   # Every 6 hours
    - cron: '0 0 * * 0'     # Weekly on Sunday
```

Cron format: `minute hour day month weekday`

Common patterns:
- `*/5 * * * *` - Every 5 minutes
- `0 * * * *` - Every hour
- `0 0 * * *` - Daily at midnight
- `0 0 * * 0` - Weekly (Sunday)
- `0 0 1 * *` - Monthly (1st)

## release

Run on release activity.

```yaml
on:
  release:
    types: [published]
```

## create/delete

Run on branch or tag creation/deletion.

```yaml
on:
  create:
    branches:
      - 'feature/**'
  delete:
```

## issue_comment

Run on issue/PR comment.

```yaml
on:
  issue_comment:
    types: [created, edited]
```

## workflow_call (Reusable)

Make workflow reusable from other workflows.

```yaml
on:
  workflow_call:
    inputs:
      username:
        required: true
        type: string
    secrets:
      token:
        required: true
```

## workflow_run

Run after another workflow completes.

```yaml
on:
  workflow_run:
    workflows: ["CI"]
    types: [completed]
    branches: [main]
```

## Multiple Triggers

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:
  schedule:
    - cron: '0 0 * * *'
```

## Activity Types

Each trigger has specific activity types available. Common ones:

| Trigger | Common Types |
|---------|-------------|
| `push` | None (always triggers on push) |
| `pull_request` | `opened`, `synchronize`, `closed`, `reopened` |
| `release` | `published`, `unpublished`, `created`, `edited` |
| `issues` | `opened`, `closed`, `reopened`, `labeled` |
| `check_run` | `completed`, `created`, `rerequested` |

## Path Filtering

Only trigger when specific paths change:

```yaml
on:
  push:
    paths:
      - 'src/**'
      - 'package*.json'
    paths-ignore:
      - '**.md'
      - 'docs/**'
```

## Branch Filtering

Control which branches trigger:

```yaml
on:
  push:
    branches:
      - main
      - develop
      - 'release/**'
      - '!release/**-beta'
```

Use patterns:
- `main` - exact match
- `release/**` - wildcard
- `!release/**-beta` - negative pattern
