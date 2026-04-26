---
name: find-devcontainer-feature
description: >
  Search for devcontainer features in official (containers.dev) and community catalogs. 
  Find and compare features for languages (Node, Python, Go), databases (PostgreSQL, Redis), 
  and development tools. Use when looking for a specific feature ID, exploring available 
  tools, or needing feature installation options. Also applies when the user asks 
  "what features are available for [tool]?", "find me a [tool] feature", or describes 
  wanting to add capabilities to their devcontainer without knowing the exact feature name.
license: MIT
compatibility: Requires internet access to fetch feature catalogs
metadata:
  author: agentskills
  version: "1.0.0"
  category: devcontainer-discovery
---

# Find Devcontainer Feature

Search for devcontainer features in official and community catalogs.

## Quick Start

To find a feature:

1. Search by tool name or description
2. Review results from official and community sources
3. Select appropriate feature
4. Copy feature ID for use in devcontainer.json

## Usage

### Search by Tool Name

```
Find feature for: Redis
```

Returns:
```json
{
  "results": [
    {
      "id": "ghcr.io/devcontainers/features/redis",
      "description": "Installs Redis server",
      "options": ["version"],
      "source": "official"
    }
  ]
}
```

### Search by Purpose

```
Find feature for: Python development
```

Returns multiple options:
```json
{
  "results": [
    {
      "id": "ghcr.io/devcontainers/features/python",
      "description": "Python runtime with pip",
      "options": ["version", "installTools"],
      "source": "official"
    }
  ]
}
```

## Catalog Sources

### Primary: Official Catalog

**URL:** https://containers.dev/features

Search the official Dev Containers features catalog maintained by Microsoft and community.

**Characteristics:**
- Curated and tested
- Well-documented
- Regularly updated
- Broad language/tool support

### Secondary: Community Catalog

**URL:** https://github.com/notwillk/devcontainer-features

Search additional community-contributed features.

**Characteristics:**
- Extended feature set
- Specialized tools
- Community maintained
- May have less documentation

## Search Strategy

### Step 1: Parse Search Query

Extract keywords from user request:
- Tool name: "redis", "postgres", "node"
- Purpose: "database", "development", "deployment"
- Category: "language", "service", "utility"

### Step 2: Search Official Catalog

Query containers.dev API or search index for:
- Exact matches (high priority)
- Partial matches
- Related features

### Step 3: Search Community Catalog

If limited results from official catalog, also search:
- notwillk/devcontainer-features
- Other community repositories

### Step 4: Rank and Deduplicate

Present results sorted by:
1. Official vs community (official first)
2. Relevance to query
3. Documentation quality
4. Recent activity

### Step 5: Return Results

Format with clear labels:
```json
{
  "query": "redis",
  "total_results": 3,
  "results": [
    {
      "id": "ghcr.io/devcontainers/features/redis",
      "name": "Redis",
      "description": "Installs and configures Redis server",
      "options": {
        "version": {
          "type": "string",
          "default": "latest",
          "description": "Redis version to install"
        }
      },
      "source": "official",
      "documentation": "https://github.com/devcontainers/features/tree/main/src/redis"
    },
    {
      "id": "ghcr.io/community-features/redis-cluster",
      "name": "Redis Cluster",
      "description": "Redis with clustering support",
      "options": {},
      "source": "community",
      "documentation": null
    }
  ]
}
```

## Common Features Reference

### Language Runtimes

| Tool | Feature ID | Common Options |
|------|-----------|----------------|
| Node.js | ghcr.io/devcontainers/features/node | version (18, 20) |
| Python | ghcr.io/devcontainers/features/python | version, installTools |
| Go | ghcr.io/devcontainers/features/go | version |
| Rust | ghcr.io/devcontainers/features/rust | version (stable, nightly) |
| Java | ghcr.io/devcontainers/features/java | version, installMaven |
| .NET | ghcr.io/devcontainers/features/dotnet | version |
| Ruby | ghcr.io/devcontainers/features/ruby | version |
| PHP | ghcr.io/devcontainers/features/php | version |

### Databases

| Tool | Feature ID | Common Options |
|------|-----------|----------------|
| PostgreSQL | ghcr.io/devcontainers/features/postgres | version |
| MySQL | ghcr.io/devcontainers/features/mysql | version |
| MongoDB | ghcr.io/devcontainers/features/mongo | version |
| Redis | ghcr.io/devcontainers/features/redis | version |
| MariaDB | ghcr.io/devcontainers/features/mariadb | version |

### Development Tools

| Tool | Feature ID | Common Options |
|------|-----------|----------------|
| Git | ghcr.io/devcontainers/features/git | version |
| GitHub CLI | ghcr.io/devcontainers/features/github-cli | version |
| Docker-in-Docker | ghcr.io/devcontainers/features/docker-in-docker | version, moby |
| Common Utils | ghcr.io/devcontainers/features/common-utils | - |
| Homebrew | ghcr.io/devcontainers/features/homebrew | - |
| Oh My Zsh | ghcr.io/devcontainers/features/oh-my-zsh | - |

### Cloud Tools

| Tool | Feature ID | Common Options |
|------|-----------|----------------|
| AWS CLI | ghcr.io/devcontainers/features/aws-cli | version |
| Azure CLI | ghcr.io/devcontainers/features/azure-cli | version |
| Google Cloud SDK | ghcr.io/devcontainers/features/gcloud | version |
| Terraform | ghcr.io/devcontainers/features/terraform | version |

## Using Search Results

### Selecting a Feature

When presenting results, include:

1. **Feature ID** - Required for installation
2. **Description** - What it does
3. **Available Options** - What can be configured
4. **Source** - Official vs community
5. **Documentation Link** - For detailed info

### Installation Example

After finding feature, user can add to devcontainer.json:

```json
"features": {
  "ghcr.io/devcontainers/features/redis": {
    "version": "7.0"
  }
}
```

## Gotchas

- **Case sensitivity:** Feature IDs are case-sensitive
- **Version tags:** Omit for "latest", specify for reproducibility
- **Registry format:** Must use full registry path (ghcr.io/...)
- **No search API:** Catalog may require web scraping or cached index
- **Community features:** May have less documentation or testing

## Catalog URLs

### Official
- **Features:** https://containers.dev/features
- **API:** https://containers.dev/api/features
- **Source:** https://github.com/devcontainers/features

### Community (notwillk)
- **Repository:** https://github.com/notwillk/devcontainer-features
- **Features:** Listed in README

## Integration with Update Skill

This skill is callable from `update-devcontainer-config` when:
- User requests adding a feature
- No specific feature ID provided
- Multiple options may exist

**Flow:**
1. User: "Add Redis to my devcontainer"
2. Update skill detects no feature ID
3. **Calls this skill:** Search for "Redis"
4. Present options to user
5. User selects preferred option
6. Update skill proceeds with installation

## Implementation Notes

Since there's no official search API, implementations may use:
- Cached catalog index
- Web scraping (respect rate limits)
- Manual feature list updates
- GitHub API for community repos

## Resources

- containers.dev/features - Official feature catalog
- https://github.com/devcontainers/features - Official source
- https://github.com/notwillk/devcontainer-features - Community features
- `update-devcontainer-config` - Use found features to update devcontainer
