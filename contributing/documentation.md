# Contributing to Documentation

SPECTRA documentation is automatically generated and deployed. Here's how to contribute.

## Documentation Structure

Documentation lives in two places:

1. **`docs/` directory** - Main documentation site (MkDocs)
2. **Project READMEs** - Auto-included in documentation

## Adding New Documentation

### Option 1: Edit in `docs/` Directory

1. Create or edit markdown files in `docs/`
2. Update `docs/mkdocs.yml` navigation if needed
3. Commit and push - documentation rebuilds automatically

### Option 2: Update Project READMEs

Project READMEs are automatically included. Just update the README in your project directory.

## Documentation Standards

- Use clear, descriptive headings
- Include code examples where helpful
- Link to related documentation
- Keep it up to date with code changes

## Local Preview

```bash
# Install MkDocs
pip install mkdocs-material

# Serve locally
cd docs
mkdocs serve
```

Visit `http://127.0.0.1:8000` to preview.

## Auto-Deployment

Documentation automatically deploys to GitHub Pages when you push to `main`. No manual steps required!

