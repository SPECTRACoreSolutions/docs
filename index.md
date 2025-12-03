# SPECTRA Documentation

Welcome to the SPECTRA documentation! This site provides comprehensive guides, API references, and best practices for building modular AI-powered data pipelines for Microsoft Fabric.

## What is SPECTRA?

SPECTRA is a modular framework for building data pipelines that follow a standardized methodology:

- **Source** - Data ingestion and intake
- **Extract** - Data extraction from source systems
- **Clean** - Data quality and validation
- **Transform** - Business logic and transformations
- **Refine** - Data enrichment and refinement
- **Analyse** - Analytics and insights

## Quick Links

- 🚀 [Getting Started](getting-started/index.md) - New to SPECTRA? Start here
- 📚 [Framework Documentation](framework/index.md) - Core framework and utilities
- 🏗️ [Infrastructure](labs/index.md) - Deployment and infrastructure guides
- 🛠️ [CLI Tools](cli/index.md) - Command-line interface reference
- 📖 [Standards](standards/index.md) - Coding standards and best practices

## Documentation Structure

This documentation is automatically generated and updated from the SPECTRA monorepo. Documentation is organized by:

- **Framework** - Core utilities and shared code
- **Projects** - Domain-specific implementations (Jira, Xero, etc.)
- **Infrastructure** - Deployment, CI/CD, and tooling
- **Operations** - Runbooks, playbooks, and operational guides
- **Standards** - Coding standards, naming conventions, and best practices

## Contributing

Documentation is automatically updated when you commit changes to the repository. To contribute:

1. Edit markdown files in the `docs/` directory
2. Or update README files in project directories (they're automatically included)
3. Commit and push - documentation will rebuild automatically

See [Contributing Guide](contributing/index.md) for more details.

## Latest Updates

Documentation is automatically rebuilt on every push to the main branch. The last update was generated from commit: `{{ git.commit }}` on `{{ git.commit_date }}`.

