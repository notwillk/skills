---
title: Devcontainer Properties Reference
---

# Devcontainer.json Properties Reference

## Core Properties

### name
- **Type:** string
- **Description:** Display name for the devcontainer
- **Example:** `"name": "My Node.js Project"`

### image
- **Type:** string
- **Description:** Container registry image to use
- **Examples:**
  - `mcr.microsoft.com/devcontainers/python:3.11`
  - `mcr.microsoft.com/devcontainers/node:18`
  - `mcr.microsoft.com/devcontainers/universal:2`

### build
- **Type:** object
- **Description:** Dockerfile-based configuration
- **Properties:**
  - `dockerfile`: Path to Dockerfile
  - `context`: Build context path
  - `args`: Build arguments
  - `options`: Docker build options
  - `target`: Build stage target
  - `cacheFrom`: Cache image sources

## Feature Properties

### features
- **Type:** object
- **Description:** Map of feature IDs to options
- **Example:**
```json
"features": {
  "ghcr.io/devcontainers/features/node": {
    "version": "18"
  },
  "ghcr.io/devcontainers/features/docker-in-docker": {}
}
```

### overrideFeatureInstallOrder
- **Type:** array
- **Description:** Override automatic feature installation order
- **Example:** `["ghcr.io/devcontainers/features/common-utils"]`

## Port Properties

### forwardPorts
- **Type:** array
- **Description:** Ports to forward from container to host
- **Examples:**
  - `[3000, 5432]`
  - `["db:5432"]`
  - `[3000, "app:8080"]`

### portsAttributes
- **Type:** object
- **Description:** Configuration for specific ports
- **Properties per port:**
  - `label`: Display name
  - `onAutoForward`: Action (notify, openBrowser, openPreview, silent, ignore)
  - `protocol`: http or https
  - `requireLocalPort`: boolean
  - `elevateIfNeeded`: boolean

## Environment Properties

### containerEnv
- **Type:** object
- **Description:** Environment variables for all container processes
- **Example:**
```json
"containerEnv": {
  "NODE_ENV": "development",
  "DATABASE_URL": "postgres://localhost:5432/mydb"
}
```

### remoteEnv
- **Type:** object
- **Description:** Environment variables for IDE/tools only
- **Example:**
```json
"remoteEnv": {
  "EDITOR": "code",
  "SHELL": "/bin/zsh"
}
```

### remoteUser
- **Type:** string
- **Description:** User for IDE/tool processes
- **Example:** `"remoteUser": "node"`

### containerUser
- **Type:** string
- **Description:** User for all container processes
- **Example:** `"containerUser": "root"`

## Lifecycle Properties

### initializeCommand
- **Type:** string, array, or object
- **Description:** Command run on host during initialization
- **Runs:** Before container creation

### onCreateCommand
- **Type:** string, array, or object
- **Description:** Command run when container first created
- **Runs:** Container start (first time only)

### updateContentCommand
- **Type:** string, array, or object
- **Description:** Command run when content updates
- **Runs:** After onCreateCommand

### postCreateCommand
- **Type:** string, array, or object
- **Description:** Command run after container is assigned to user
- **Runs:** After updateContentCommand

### postStartCommand
- **Type:** string, array, or object
- **Description:** Command run each time container starts
- **Runs:** Every container start

### postAttachCommand
- **Type:** string, array, or object
- **Description:** Command run when tool attaches to container
- **Runs:** Every attach

### waitFor
- **Type:** enum
- **Values:** `initializeCommand`, `onCreateCommand`, `updateContentCommand`
- **Default:** `updateContentCommand`
- **Description:** Which command to wait for before connecting

## Docker Compose Properties

### dockerComposeFile
- **Type:** string or array
- **Description:** Path(s) to docker-compose.yml
- **Example:** `["docker-compose.yml", "docker-compose.override.yml"]`

### service
- **Type:** string
- **Description:** Which Compose service to attach to
- **Required with dockerComposeFile**

### runServices
- **Type:** array
- **Description:** Services to start (defaults to all)
- **Example:** `["app", "db"]`

## Other Properties

### mounts
- **Type:** array
- **Description:** Additional mounts
- **Example:**
```json
"mounts": [
  {
    "source": "${localEnv:HOME}/.ssh",
    "target": "/home/vscode/.ssh",
    "type": "bind"
  }
]
```

### shutdownAction
- **Type:** enum
- **Values:** `none`, `stopContainer`, `stopCompose`
- **Description:** What to do when closing IDE

### overrideCommand
- **Type:** boolean
- **Default:** true (for image), false (for Compose)
- **Description:** Whether to override container default command

### hostRequirements
- **Type:** object
- **Properties:**
  - `cpus`: minimum CPU cores
  - `memory`: minimum memory (e.g., "4gb")
  - `storage`: minimum storage
  - `gpu`: "optional" or "required"

## Customizations

### customizations
- **Type:** object
- **Description:** Tool-specific settings
- **Example:**
```json
"customizations": {
  "vscode": {
    "extensions": ["dbaeumer.vscode-eslint"],
    "settings": {
      "editor.formatOnSave": true
    }
  }
}
```
