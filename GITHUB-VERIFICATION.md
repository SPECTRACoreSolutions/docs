# GitHub Pages Domain Verification

GitHub requires domain verification before you can use a custom domain. This involves adding a TXT record to your DNS.

## Steps to Verify

### 1. Get Verification Code from GitHub

1. Go to: https://github.com/SPECTRACoreSolutions/docs/settings/pages
2. Under "Custom domain", enter: `docs.spectradatasolutions.com`
3. Click **Save**
4. GitHub will show a verification code (starts with `github-pages-domain-verification=`)

### 2. Add TXT Record

Use the script to add the verification record:

```powershell
.\scripts\add-github-verification.ps1 -VerificationCode "github-pages-domain-verification=YOUR_CODE_HERE"
```

Or manually in Cloudflare:
- **Type**: TXT
- **Name**: `_github-pages-challenge-docs`
- **Content**: The verification code from GitHub
- **TTL**: 3600

### 3. Wait for Verification

- DNS propagation: 5-15 minutes
- GitHub will automatically verify once DNS resolves
- Check status in GitHub Pages settings

## Verification Record Format

The TXT record should be:
- **Name**: `_github-pages-challenge-docs.spectradatasolutions.com`
- **Type**: TXT
- **Value**: `github-pages-domain-verification=XXXXX` (from GitHub)

## Troubleshooting

### GitHub shows "Not verified"
- Wait for DNS propagation (can take up to 24 hours, usually much faster)
- Verify TXT record exists: `nslookup -type=TXT _github-pages-challenge-docs.spectradatasolutions.com`
- Check record name matches exactly (including underscore)

### Verification code not showing
- Make sure you've entered the domain in GitHub Pages settings
- Try refreshing the page
- Check repository permissions

## Current Status

- ✅ CNAME record created: `docs` → `spectracoresolutions.github.io`
- ⏳ TXT verification record needed (get code from GitHub first)
- ⏳ Domain verification pending








