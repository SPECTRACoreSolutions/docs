#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Configure Cloudflare DNS record for docs.spectradatasolutions.com

.DESCRIPTION
    Creates a CNAME record pointing docs.spectradatasolutions.com to 
    spectracoresolutions.github.io for GitHub Pages.

.PARAMETER ZoneId
    Cloudflare Zone ID for spectradatasolutions.com (optional, will auto-detect)

.PARAMETER ApiToken
    Cloudflare API Token (optional, will use wrangler auth if not provided)
#>

param(
    [string]$ZoneId,
    [string]$ApiToken
)

# Check if wrangler is available
if (-not (Get-Command wrangler -ErrorAction SilentlyContinue)) {
    Write-Error "wrangler CLI not found. Install with: npm install -g wrangler"
    exit 1
}

# Get zone ID if not provided
if (-not $ZoneId) {
    Write-Host "Getting zone ID for spectradatasolutions.com..."
    $zoneInfo = wrangler d1 list 2>&1
    # Try to get zone via API
    $ZoneId = (wrangler pages project list 2>&1 | Out-String)
    Write-Host "Zone ID detection not fully automated. Please provide Zone ID or authenticate."
}

# Use wrangler to create DNS record
Write-Host "Creating CNAME record: docs -> spectracoresolutions.github.io"

# Method 1: Use Cloudflare API directly (requires API token)
if ($ApiToken) {
    $headers = @{
        "Authorization" = "Bearer $ApiToken"
        "Content-Type" = "application/json"
    }
    
    $body = @{
        type = "CNAME"
        name = "docs"
        content = "spectracoresolutions.github.io"
        ttl = 3600
        proxied = $false  # DNS only, not proxied through Cloudflare
    } | ConvertTo-Json
    
    $zoneId = if ($ZoneId) { $ZoneId } else { 
        Write-Warning "Zone ID required. Get it from Cloudflare dashboard or use: wrangler dns create docs CNAME spectracoresolutions.github.io --zone-id <zone-id>"
        exit 1
    }
    
    try {
        $response = Invoke-RestMethod -Method Post `
            -Uri "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records" `
            -Headers $headers `
            -Body $body
        
        if ($response.success) {
            Write-Host "✅ DNS record created successfully!" -ForegroundColor Green
            Write-Host "Record ID: $($response.result.id)"
        } else {
            Write-Error "Failed to create DNS record: $($response.errors | ConvertTo-Json)"
        }
    } catch {
        Write-Error "Error creating DNS record: $_"
    }
} else {
    # Method 2: Use wrangler (requires authentication)
    Write-Host "Using wrangler CLI. You may need to authenticate first."
    Write-Host "Run: wrangler login"
    Write-Host ""
    Write-Host "Then create the record with:"
    Write-Host "  wrangler dns create docs CNAME spectracoresolutions.github.io --zone-id <zone-id>"
    Write-Host ""
    Write-Host "Or use the Cloudflare dashboard:"
    Write-Host "  1. Go to: https://dash.cloudflare.com"
    Write-Host "  2. Select zone: spectradatasolutions.com"
    Write-Host "  3. DNS → Records → Add record"
    Write-Host "  4. Type: CNAME"
    Write-Host "  5. Name: docs"
    Write-Host "  6. Target: spectracoresolutions.github.io"
    Write-Host "  7. Proxy status: DNS only (gray cloud)"
    Write-Host "  8. TTL: Auto or 3600"
    Write-Host "  9. Save"
}

