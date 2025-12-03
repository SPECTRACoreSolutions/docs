# Cloudflare DNS Setup for docs.spectradatasolutions.com

## Quick Setup (Recommended: Dashboard)

The easiest way is to use the Cloudflare dashboard:

1. **Go to Cloudflare Dashboard**
   - https://dash.cloudflare.com
   - Select zone: `spectradatasolutions.com`

2. **Add DNS Record**
   - Go to: **DNS** → **Records** → **Add record**
   - **Type**: CNAME
   - **Name**: `docs`
   - **Target**: `spectracoresolutions.github.io`
   - **Proxy status**: **DNS only** (gray cloud - important!)
   - **TTL**: Auto (or 3600)
   - Click **Save**

3. **Verify**
   - Record should appear in DNS list
   - Wait 5-15 minutes for propagation

## Alternative: API Script

If you prefer to use the API, you'll need a Cloudflare API token:

### Get API Token

1. Go to: https://dash.cloudflare.com/profile/api-tokens
2. Click **Create Token**
3. Use **Edit zone DNS** template
4. Select zone: `spectradatasolutions.com`
5. Click **Continue to summary** → **Create Token**
6. Copy the token (you won't see it again!)

### Run Script

```powershell
# Set your API token
$env:CLOUDFLARE_API_TOKEN = "your-api-token-here"

# Run the script
.\scripts\create-dns-record.ps1 -ApiToken $env:CLOUDFLARE_API_TOKEN
```

Or provide token directly:

```powershell
.\scripts\create-dns-record.ps1 -ApiToken "your-api-token-here"
```

## Important Notes

⚠️ **Proxy Status**: Must be **DNS only** (gray cloud), NOT proxied (orange cloud)
- GitHub Pages requires direct DNS resolution
- Proxied records won't work with GitHub Pages custom domains

✅ **TTL**: Auto or 3600 seconds is fine

## Verification

After creating the record:

```powershell
# Check DNS resolution
nslookup docs.spectradatasolutions.com

# Should resolve to spectracoresolutions.github.io
```

## Next Steps

Once DNS is configured:

1. **Wait for DNS propagation** (5-15 minutes usually)
2. **Configure in GitHub Pages**:
   - Go to: https://github.com/SPECTRACoreSolutions/docs/settings/pages
   - Under "Custom domain", enter: `docs.spectradatasolutions.com`
   - Check **Enforce HTTPS**
   - Click **Save**
3. **Wait for SSL certificate** (automatic, may take a few hours)
4. **Test**: Visit https://docs.spectradatasolutions.com

## Troubleshooting

### Record not resolving
- Wait longer (DNS can take up to 48 hours, but usually much faster)
- Verify record in Cloudflare dashboard
- Check that proxy status is **DNS only** (gray cloud)

### GitHub shows "Not verified"
- DNS must propagate first
- GitHub checks DNS automatically
- Can take a few minutes after DNS resolves

### HTTPS not working
- SSL certificate is automatic but can take a few hours
- Ensure "Enforce HTTPS" is checked in GitHub Pages settings
- Wait for certificate provisioning

## Current Status

- ✅ CNAME file created in repository
- ✅ mkdocs.yml configured with custom domain
- ✅ Wrangler CLI installed and authenticated
- ⏳ DNS record needs to be created (use dashboard or API script)
- ⏳ GitHub Pages custom domain configuration needed








