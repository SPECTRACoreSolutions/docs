# SPECTRA Documentation

**Comprehensive documentation for SPECTRA - Modular AI-powered data pipelines for Microsoft Fabric**

[![Documentation](https://img.shields.io/badge/docs-live-blue)](https://spectracoresolutions.github.io/docs/)
[![GitHub Pages](https://img.shields.io/badge/deploy-GitHub%20Pages-green)](https://github.com/SPECTRACoreSolutions/docs/actions)

## Overview

This repository contains the source files for the SPECTRA documentation site, built with [MkDocs](https://www.mkdocs.org/) and the [Material theme](https://squidfunk.github.io/mkdocs-material/).

The documentation automatically aggregates content from across the SPECTRA workspace and deploys to GitHub Pages on every push to `main`.

## Quick Start

### Local Development

```bash
# Install dependencies
pip install -r requirements.txt

# Serve locally
mkdocs serve
```

Visit `http://127.0.0.1:8000` to view the documentation.

### Build

```bash
# Build static site
mkdocs build
```

Output will be in the `site/` directory.

## Documentation Structure

- **Getting Started** - Installation and quick start guides
- **Framework** - Core framework documentation and architecture
- **Projects** - Project-specific documentation (auto-aggregated from workspace)
- **Infrastructure** - Deployment, CI/CD, and infrastructure guides
- **Operations** - Runbooks, playbooks, and operational documentation
- **Standards** - Coding standards, naming conventions, and best practices
- **Contributing** - Contribution guidelines and documentation standards

## How It Works

1. **Documentation Source**: Markdown files in this repository + README files from workspace projects
2. **Aggregation**: `scripts/aggregate_docs.py` collects README files from across the SPECTRA workspace
3. **Build**: MkDocs builds a static site from markdown files
4. **Deploy**: GitHub Actions automatically deploys to GitHub Pages on push to `main`

## Contributing

Documentation is automatically updated when you commit changes. To contribute:

1. Edit markdown files in this repository
2. Or update README files in project directories (they're automatically included)
3. Commit and push - documentation will rebuild automatically

See [Contributing Guide](contributing/documentation.md) for details.

## Auto-Deployment

Documentation automatically deploys to GitHub Pages when you push to `main`. The workflow:

1. Aggregates documentation from across the SPECTRA workspace
2. Builds the MkDocs site
3. Deploys to GitHub Pages

No manual steps required!

## Repository Information

- **Organization**: SPECTRACoreSolutions
- **Repository**: docs
- **Live Site**: https://spectracoresolutions.github.io/docs/
- **Pattern**: Follows the same structure as `academy` - a cross-cutting resource repository

## Related Repositories

- [SPECTRA Framework](https://github.com/SPECTRACoreSolutions/framework) - Core utilities
- [SPECTRA Academy](https://github.com/SPECTRACoreSolutions/academy) - Learning resources
- [Fabric SDK](https://github.com/SPECTRADataSolutions/fabric-sdk) - Microsoft Fabric SDK

## License

Part of the SPECTRA ecosystem. See individual project repositories for license information.
