# Custom Domain Setup: docs.spectradatasolutions.com

## DNS Configuration Required

To complete the custom domain setup, you need to configure DNS records:

### Option 1: CNAME Record (Recommended)

Add a CNAME record in your DNS provider:

```
Type: CNAME
Name: docs
Value: spectracoresolutions.github.io
TTL: 3600 (or your default)
```

### Option 2: A Records (Alternative)

If CNAME isn't supported, use A records:

```
Type: A
Name: docs
Value: 185.199.108.153
TTL: 3600

Type: A
Name: docs
Value: 185.199.109.153
TTL: 3600

Type: A
Name: docs
Value: 185.199.110.153
TTL: 3600

Type: A
Name: docs
Value: 185.199.111.153
TTL: 3600
```

## GitHub Pages Configuration

1. **Add CNAME file** (already done - `CNAME` in repo root)
2. **Enable custom domain in GitHub**:
   - Go to: https://github.com/SPECTRACoreSolutions/docs/settings/pages
   - Under "Custom domain", enter: `docs.spectradatasolutions.com`
   - Check "Enforce HTTPS" (recommended)
   - Save

## Verification

After DNS propagates (can take up to 48 hours, usually much faster):

1. **Check DNS propagation**:
   ```bash
   nslookup docs.spectradatasolutions.com
   ```

2. **Test HTTPS**:
   ```bash
   curl -I https://docs.spectradatasolutions.com
   ```

3. **Verify in GitHub**:
   - Settings → Pages should show "Custom domain verified"

## Current Status

- ✅ CNAME file created in repository
- ✅ mkdocs.yml updated with custom domain
- ⏳ DNS configuration needed (in your DNS provider)
- ⏳ GitHub Pages custom domain configuration needed

## Troubleshooting

### Domain not resolving
- Wait for DNS propagation (up to 48 hours)
- Verify DNS records are correct
- Check DNS provider settings

### HTTPS not working
- Ensure "Enforce HTTPS" is enabled in GitHub Pages settings
- Wait for SSL certificate provisioning (automatic, can take a few hours)

### GitHub shows "Not verified"
- DNS must be configured first
- Wait for DNS propagation
- GitHub will automatically verify once DNS resolves

## Related

- [GitHub Pages Custom Domain Docs](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site)
- Portal domain: `spectradatasolutions.com` (root domain)








