# Getting GitHub Verification Code

The verification code is only shown in the GitHub web UI. Here's how to get it:

## Quick Steps

1. **Open GitHub Pages Settings**
   - Go to: https://github.com/SPECTRACoreSolutions/docs/settings/pages
   - Or: Repository → Settings → Pages

2. **Add Custom Domain**
   - In "Custom domain" field, enter: `docs.spectradatasolutions.com`
   - Click **Save**

3. **Get Verification Code**
   - GitHub will show a message with the verification code
   - It looks like: `github-pages-domain-verification=XXXXXXXXX`
   - Copy the entire string (including `github-pages-domain-verification=`)

4. **Run the Script**
   ```powershell
   .\scripts\add-github-verification.ps1 -VerificationCode "github-pages-domain-verification=YOUR_CODE"
   ```

## Alternative: Check Browser Network Tab

If the code isn't visible, you can check the browser's developer tools:
1. Open browser DevTools (F12)
2. Go to Network tab
3. Add the domain in GitHub Pages settings
4. Look for API calls - the verification code might be in the response

## Note

The verification code is unique and changes if you remove/re-add the domain. Make sure to use the code shown when you add the domain.








