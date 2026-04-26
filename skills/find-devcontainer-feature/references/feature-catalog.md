---
title: Feature Catalog Index
---

# Devcontainer Feature Catalog Index

This is a reference index of commonly used features. For the most up-to-date list, visit https://containers.dev/features

## Official Features (ghcr.io/devcontainers/features/)

### Languages
- **node** - Node.js runtime
  - Options: version (16, 18, 20), nvm (boolean)
  
- **python** - Python runtime
  - Options: version (3.8-3.12), installTools, enablePipx
  
- **go** - Go runtime
  - Options: version (1.20, 1.21)
  
- **rust** - Rust toolchain
  - Options: version (stable, nightly), profile (minimal, default, complete)
  
- **java** - Java runtime
  - Options: version, installMaven, installGradle
  
- **dotnet** - .NET SDK
  - Options: version (6.0, 7.0, 8.0)
  
- **ruby** - Ruby runtime
  - Options: version
  
- **php** - PHP runtime
  - Options: version
  
- **kotlin** - Kotlin/JVM
  - Options: version, installMaven, installGradle

### Databases
- **postgres** - PostgreSQL server
  - Options: version
  
- **mysql** - MySQL server
  - Options: version
  
- **mongo** - MongoDB server
  - Options: version
  
- **redis** - Redis server
  - Options: version
  
- **mariadb** - MariaDB server
  - Options: version

### Tools
- **git** - Git version control
  - Options: version, ppa (boolean)
  
- **github-cli** - GitHub CLI (gh)
  - Options: version
  
- **docker-in-docker** - Docker inside container
  - Options: version, moby, dockerDashComposeVersion
  
- **docker-outside-of-docker** - Access host Docker
  - Options: version, moby
  
- **common-utils** - Common utilities (zsh, curl, wget, nano)
  - Options: installZsh, upgradePackages, username
  
- **homebrew** - Homebrew package manager
  - Options: - 
  
- **oh-my-zsh** - Oh My Zsh shell
  - Options: - 
  
- **fish** - Fish shell
  - Options: - 

### Cloud/CLI Tools
- **aws-cli** - AWS Command Line Interface
  - Options: version
  
- **azure-cli** - Azure CLI
  - Options: version
  
- **gcloud** - Google Cloud SDK
  - Options: version
  
- **terraform** - Terraform CLI
  - Options: version
  
- **kubectl** - Kubernetes CLI
  - Options: version
  
- **helm** - Helm package manager
  - Options: version

### Desktop/Libraries
- **desktop-lite** - Lightweight desktop environment
  - Options: version, password
  
- **sshd** - SSH server
  - Options: version
  
- **npx** - NPX package runner
  - Options: version
  
- **anaconda** - Anaconda Python distribution
  - Options: version

## Community Features

### notwillk/devcontainer-features

Additional features from community:
- Various specialized tools
- Extended language support
- Custom utilities

See: https://github.com/notwillk/devcontainer-features for complete list

## Feature ID Format

Official: `ghcr.io/devcontainers/features/<name>:<version>`
Community: `ghcr.io/<username>/devcontainer-features/<name>:<version>`

## Version Tags

- `latest` or omit - Most recent version
- `1` - Latest of major version 1
- `1.2` - Latest of minor version 1.2
- `1.2.3` - Exact version

## Options Reference

Common option types:
- `string` - Text value (e.g., "18", "3.11")
- `boolean` - true/false
- `enum` - Specific values (e.g., ["stable", "nightly"])
- `number` - Numeric value

## Documentation Links

Each feature typically has documentation at:
`https://github.com/devcontainers/features/tree/main/src/<feature-name>`
