# Documentation Setup Guide

This guide explains how the SPECTRA documentation system works and how to get it running.

## Overview

SPECTRA documentation is built with [MkDocs](https://www.mkdocs.org/) and the [Material theme](https://squidfunk.github.io/mkdocs-material/). It automatically aggregates documentation from across the monorepo and deploys to GitHub Pages.

## Architecture

```
docs/
├── mkdocs.yml          # Main configuration
├── index.md            # Homepage
├── getting-started/    # Getting started guides
├── framework/         # Framework documentation
├── projects/          # Project docs (auto-generated)
├── infrastructure/    # Infrastructure guides
├── operations/        # Operational docs
├── standards/         # Standards and guidelines
├── contributing/      # Contribution guides
└── scripts/
    └── aggregate_docs.py  # Aggregation script
```

## How It Works

1. **Documentation Source**: Documentation lives in the `docs/` directory and in project README files
2. **Aggregation**: The `aggregate_docs.py` script collects README files from across the monorepo
3. **Build**: MkDocs builds a static site from markdown files
4. **Deploy**: GitHub Actions automatically deploys to GitHub Pages on push to `main`

## Local Development

### Prerequisites

```bash
pip install -r docs/requirements.txt
```

### Serve Locally

```bash
cd docs
mkdocs serve
```

Visit `http://127.0.0.1:8000` to view the documentation.

### Build

```bash
cd docs
mkdocs build
```

Output will be in the `site/` directory (gitignored).

## Adding Documentation

### Option 1: Edit in `docs/` Directory

1. Create or edit markdown files in `docs/`
2. Update `docs/mkdocs.yml` navigation if adding new sections
3. Commit and push - documentation rebuilds automatically

### Option 2: Update Project READMEs

Project READMEs are automatically aggregated. Just update the README in your project directory and the aggregation script will include it.

## Customization

### Theme

Edit `docs/mkdocs.yml` to customize:
- Colors and palette
- Navigation structure
- Plugins and extensions
- Site metadata

### Navigation

Update the `nav:` section in `mkdocs.yml` to add or reorganize pages.

## Deployment

Documentation automatically deploys to GitHub Pages when you push to `main`. The workflow:

1. Runs `aggregate_docs.py` to collect documentation
2. Builds the MkDocs site
3. Deploys to GitHub Pages

### Custom Domain

To use a custom domain:

1. Add a `CNAME` file in `docs/` with your domain
2. Configure DNS for your domain
3. Update `site_url` in `mkdocs.yml`

## Troubleshooting

### Build Fails

- Check that all markdown files are valid
- Verify `mkdocs.yml` syntax
- Check GitHub Actions logs

### Missing Documentation

- Ensure README files are in expected locations
- Check `aggregate_docs.py` exclusions
- Verify file paths in `mkdocs.yml`

### Local Preview Issues

- Clear `site/` directory: `rm -rf docs/site`
- Reinstall dependencies: `pip install -r docs/requirements.txt --force-reinstall`
- Check Python version (3.11+)

## Next Steps

- [MkDocs Documentation](https://www.mkdocs.org/)
- [Material Theme Documentation](https://squidfunk.github.io/mkdocs-material/)
- [Contributing Guide](contributing/documentation.md)

