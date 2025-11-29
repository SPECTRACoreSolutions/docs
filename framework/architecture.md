# Framework Architecture

## Three-Tier Module Architecture

SPECTRA uses a three-tier architecture for code reuse:

1. **Framework Tier** (`Data/framework/`) - Universal utilities shared across ALL projects
2. **Project Tier** (`Data/jira`, `Data/xero`, etc.) - Domain-specific code
3. **Application Tier** (`Core/portal`, `Core/cli`) - Standalone applications

## Rule of Three

Don't centralize code until it's used in 3+ places. Wait for the pattern to prove itself.

## What Goes in Framework

- Stage utilities (source, extract, clean, transform, refine, analyse)
- Shared helpers and utilities
- Methodology code
- Data models
- Anything used across 3+ projects

## What Stays in Projects

- Client-specific logic
- Business rules
- API clients (unless used 3+ times)
- Deployment scripts

## Current Version

Framework version: **1.7.1**

Built as wheel in `Data/framework/dist/`

