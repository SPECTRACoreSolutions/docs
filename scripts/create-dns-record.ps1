#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Create Cloudflare DNS CNAME record for docs.spectradatasolutions.com

.DESCRIPTION
    Uses Cloudflare API to create a CNAME record. Requires Cloudflare API token.
    Get your API token from: https://dash.cloudflare.com/profile/api-tokens
    Create a token with Zone.DNS Edit permissions.
#>

param(
    [string]$ApiToken,
    [string]$ZoneName = "spectradatasolutions.com"
)

# Load from .env file if token not provided
if (-not $ApiToken) {
    $envFile = Join-Path $PSScriptRoot "..\..\..\.env"
    if (Test-Path $envFile) {
        Write-Host "Loading Cloudflare token from .env file..." -ForegroundColor Cyan
        Get-Content $envFile | ForEach-Object {
            if ($_ -match '^SPECTRA_CLOUDFLARE_TOKEN=(.+)$') {
                $ApiToken = $matches[1].Trim()
            }
            if ($_ -match '^SPECTRA_CLOUDFLARE_ZONE_NAME=(.+)$' -and -not $ZoneName) {
                $ZoneName = $matches[1].Trim()
            }
        }
    }
    
    if (-not $ApiToken) {
        Write-Error "Cloudflare API token not found. Provide -ApiToken parameter or set SPECTRA_CLOUDFLARE_TOKEN in .env file."
        exit 1
    }
}

# Get zone ID
Write-Host "Getting zone ID for $ZoneName..."

# Determine auth method (API Token vs API Key + Email)
$headers = @{
    "Content-Type" = "application/json"
}

# Check if we have email (indicates API Key format)
$email = $null
$envFile = Join-Path $PSScriptRoot "..\..\..\.env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^SPECTRA_CLOUDFLARE_EMAIL=(.+)$') {
            $email = $matches[1].Trim()
        }
    }
}

if ($email) {
    # API Key format (older method)
    Write-Host "Using API Key authentication (with email)..." -ForegroundColor Yellow
    $headers["X-Auth-Email"] = $email
    $headers["X-Auth-Key"] = $ApiToken
} else {
    # API Token format (newer method)
    Write-Host "Using API Token authentication..." -ForegroundColor Cyan
    $headers["Authorization"] = "Bearer $ApiToken"
}

$zoneResponse = Invoke-RestMethod -Method Get `
    -Uri "https://api.cloudflare.com/client/v4/zones?name=$ZoneName" `
    -Headers $headers

if (-not $zoneResponse.success -or $zoneResponse.result.Count -eq 0) {
    Write-Error "Failed to get zone ID. Check your API token and zone name."
    exit 1
}

$zoneId = $zoneResponse.result[0].id
Write-Host "✅ Zone ID: $zoneId" -ForegroundColor Green

# Check if record already exists
Write-Host "Checking for existing 'docs' CNAME record..."
    $existingRecords = Invoke-RestMethod -Method Get `
    -Uri "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records?type=CNAME&name=docs" `
    -Headers $headers

if ($existingRecords.success -and $existingRecords.result.Count -gt 0) {
    $existing = $existingRecords.result[0]
    Write-Host "⚠️  Record already exists:" -ForegroundColor Yellow
    Write-Host "   ID: $($existing.id)"
    Write-Host "   Name: $($existing.name)"
    Write-Host "   Content: $($existing.content)"
    
    if ($existing.content -eq "spectracoresolutions.github.io") {
        Write-Host "✅ Record is already correctly configured!" -ForegroundColor Green
        exit 0
    } else {
        $update = Read-Host "Update existing record? (y/n)"
        if ($update -eq 'y') {
            # Update existing record
            $body = @{
                type = "CNAME"
                name = "docs"
                content = "spectracoresolutions.github.io"
                ttl = 3600
                proxied = $false
            } | ConvertTo-Json
            
            $updateResponse = Invoke-RestMethod -Method Put `
                -Uri "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records/$($existing.id)" `
                -Headers $headers `
                -Body $body
            
            if ($updateResponse.success) {
                Write-Host "✅ Record updated successfully!" -ForegroundColor Green
            } else {
                Write-Error "Failed to update record: $($updateResponse.errors | ConvertTo-Json)"
            }
        }
        exit 0
    }
}

# Create new record
Write-Host "Creating CNAME record: docs -> spectracoresolutions.github.io"
$body = @{
    type = "CNAME"
    name = "docs"
    content = "spectracoresolutions.github.io"
    ttl = 3600
    proxied = $false  # DNS only, not proxied (required for GitHub Pages)
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Method Post `
        -Uri "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records" `
        -Headers $headers `
        -Body $body
    
    if ($response.success) {
        Write-Host "✅ DNS record created successfully!" -ForegroundColor Green
        Write-Host "   Record ID: $($response.result.id)"
        Write-Host "   Name: $($response.result.name)"
        Write-Host "   Content: $($response.result.content)"
        Write-Host ""
        Write-Host "Next steps:"
        Write-Host "1. Wait for DNS propagation (usually 5-15 minutes)"
        Write-Host "2. Configure custom domain in GitHub Pages:"
        Write-Host "   https://github.com/SPECTRACoreSolutions/docs/settings/pages"
        Write-Host "3. Enter: docs.spectradatasolutions.com"
        Write-Host "4. Check 'Enforce HTTPS'"
    } else {
        Write-Error "Failed to create DNS record: $($response.errors | ConvertTo-Json)"
    }
} catch {
    Write-Error "Error creating DNS record: $_"
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response: $responseBody" -ForegroundColor Red
    }
}

