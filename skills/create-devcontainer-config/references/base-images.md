---
title: Devcontainer Base Images Reference
---

# Devcontainer Base Images Reference

## Universal Images

### mcr.microsoft.com/devcontainers/universal:2
Full-featured image with many languages and tools pre-installed.
- Node.js, Python, Java, Go, Rust, Ruby, PHP
- Git, GitHub CLI, Docker CLI
- Good starting point when unsure

## Language-Specific Images

### Node.js
- `mcr.microsoft.com/devcontainers/node:18` - Node 18 LTS
- `mcr.microsoft.com/devcontainers/node:20` - Node 20 LTS
- Includes: npm, yarn, nvm

### Python
- `mcr.microsoft.com/devcontainers/python:3.10`
- `mcr.microsoft.com/devcontainers/python:3.11`
- `mcr.microsoft.com/devcontainers/python:3.12`
- Includes: pip, setuptools, venv

### Go
- `mcr.microsoft.com/devcontainers/go:1.20`
- `mcr.microsoft.com/devcontainers/go:1.21`
- Includes: go, gofmt, godoc

### Rust
- `mcr.microsoft.com/devcontainers/rust:1`
- Includes: cargo, rustc, rustfmt, clippy

### Java
- `mcr.microsoft.com/devcontainers/java:11`
- `mcr.microsoft.com/devcontainers/java:17`
- `mcr.microsoft.com/devcontainers/java:21`
- Includes: Maven, Gradle options

### .NET
- `mcr.microsoft.com/devcontainers/dotnet:6.0`
- `mcr.microsoft.com/devcontainers/dotnet:7.0`
- `mcr.microsoft.com/devcontainers/dotnet:8.0`

### Ruby
- `mcr.microsoft.com/devcontainers/ruby:3`
- Includes: gem, bundler

### PHP
- `mcr.microsoft.com/devcontainers/php:8.1`
- `mcr.microsoft.com/devcontainers/php:8.2`
- Includes: composer

## Base OS Images

### Ubuntu
- `mcr.microsoft.com/devcontainers/base:ubuntu`
- Minimal Ubuntu with common tools
- Good base for Dockerfile builds

### Debian
- `mcr.microsoft.com/devcontainers/base:debian`
- Minimal Debian with common tools

### Alpine
- `mcr.microsoft.com/devcontainers/base:alpine`
- Minimal Alpine (smaller, musl libc)

## Image Variants

### -bullseye, -bookworm
Debian version suffixes:
- `node:18-bullseye` - Debian 11
- `node:18-bookworm` - Debian 12

### -jammy, -focal
Ubuntu version suffixes:
- `node:18-focal` - Ubuntu 20.04
- `node:18-jammy` - Ubuntu 22.04

## Choosing an Image

**When to use universal:**
- Unsure of requirements
- Multiple languages needed
- Quick start

**When to use language-specific:**
- Single primary language
- Want smaller image
- Need specific version

**When to use base OS:**
- Custom requirements
- Building from Dockerfile
- Minimal attack surface
