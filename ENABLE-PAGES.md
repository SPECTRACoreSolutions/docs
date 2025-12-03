# Enable GitHub Pages

GitHub Pages needs to be enabled through the web UI for GitHub Actions deployment.

## Steps to Enable

1. **Go to Repository Settings**

   - Visit: https://github.com/SPECTRACoreSolutions/docs/settings/pages

2. **Configure Source**

   - Under "Source", select: **GitHub Actions**
   - (Not "Deploy from a branch")

3. **Save**
   - Click "Save"

## What Happens Next

Once enabled:

- The workflow will automatically deploy on every push to `main`
- Documentation will be available at: `https://spectracoresolutions.github.io/docs/`
- The first deployment may take a few minutes

## Verify Deployment

1. Check workflow status:

   ```bash
   gh run list --workflow="docs.yml"
   ```

2. View the live site:

   - https://spectracoresolutions.github.io/docs/

3. Check Pages settings:
   ```bash
   gh api repos/SPECTRACoreSolutions/docs/pages
   ```

## Troubleshooting

If the workflow fails:

- Ensure GitHub Pages is set to "GitHub Actions" (not branch deployment)
- Check workflow permissions in repository settings
- Verify the workflow file is in `.github/workflows/docs.yml`







