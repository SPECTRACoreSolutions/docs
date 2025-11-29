#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Verify DNS records in Cloudflare for docs.spectradatasolutions.com

.DESCRIPTION
    Retrieves and displays DNS records from Cloudflare to verify they exist.
#>

param(
    [string]$ZoneName = "spectradatasolutions.com"
)

# Load Cloudflare credentials from .env
$envFile = Join-Path $PSScriptRoot "..\..\..\.env"
$ApiToken = $null
$email = $null

if (Test-Path $envFile) {
    Write-Host "Loading Cloudflare credentials from .env file..." -ForegroundColor Cyan
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^SPECTRA_CLOUDFLARE_TOKEN=(.+)$') {
            $ApiToken = $matches[1].Trim()
        }
        if ($_ -match '^SPECTRA_CLOUDFLARE_EMAIL=(.+)$') {
            $email = $matches[1].Trim()
        }
        if ($_ -match '^SPECTRA_CLOUDFLARE_ZONE_NAME=(.+)$' -and -not $ZoneName) {
            $ZoneName = $matches[1].Trim()
        }
    }
}

if (-not $ApiToken) {
    Write-Error "Cloudflare API token not found in .env file. Set SPECTRA_CLOUDFLARE_TOKEN."
    exit 1
}

# Setup headers
$headers = @{
    "Content-Type" = "application/json"
}

if ($email) {
    $headers["X-Auth-Email"] = $email
    $headers["X-Auth-Key"] = $ApiToken
    Write-Host "Using API Key authentication (with email)" -ForegroundColor Yellow
} else {
    $headers["Authorization"] = "Bearer $ApiToken"
    Write-Host "Using API Token authentication" -ForegroundColor Cyan
}

# Get zone ID
Write-Host "`nGetting zone ID for $ZoneName..." -ForegroundColor Cyan
$zoneResponse = Invoke-RestMethod -Method Get `
    -Uri "https://api.cloudflare.com/client/v4/zones?name=$ZoneName" `
    -Headers $headers

if (-not $zoneResponse.success -or $zoneResponse.result.Count -eq 0) {
    Write-Error "Failed to get zone ID. Check your API token and zone name."
    exit 1
}

$zoneId = $zoneResponse.result[0].id
Write-Host "✅ Zone ID: $zoneId" -ForegroundColor Green

# Get all CNAME records and filter for docs
Write-Host "`nRetrieving DNS records for 'docs' subdomain..." -ForegroundColor Cyan
$cnameResponse = Invoke-RestMethod -Method Get `
    -Uri "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records?type=CNAME" `
    -Headers $headers

$records = @()
if ($cnameResponse.success) {
    $records = $cnameResponse.result | Where-Object { $_.name -like "*docs*" }
}

# Also try direct lookup by full name
if ($records.Count -eq 0) {
    $directResponse = Invoke-RestMethod -Method Get `
        -Uri "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records?name=docs.spectradatasolutions.com" `
        -Headers $headers
    
    if ($directResponse.success -and $directResponse.result.Count -gt 0) {
        $records = $directResponse.result
    }
}

if (-not $dnsResponse.success) {
    Write-Error "Failed to retrieve DNS records: $($dnsResponse.errors | ConvertTo-Json)"
    exit 1
}

$records = $dnsResponse.result

if ($records.Count -eq 0) {
    Write-Host "⚠️  No DNS records found for 'docs' subdomain" -ForegroundColor Yellow
} else {
    Write-Host "`n✅ Found $($records.Count) DNS record(s) for 'docs':" -ForegroundColor Green
    Write-Host ""
    
    foreach ($record in $records) {
        Write-Host "Record ID: $($record.id)" -ForegroundColor Cyan
        Write-Host "  Type: $($record.type)" -ForegroundColor White
        Write-Host "  Name: $($record.name)" -ForegroundColor White
        Write-Host "  Content: $($record.content)" -ForegroundColor White
        Write-Host "  TTL: $($record.ttl)" -ForegroundColor White
        Write-Host "  Proxied: $($record.proxied)" -ForegroundColor White
        Write-Host "  Created: $($record.created_on)" -ForegroundColor Gray
        Write-Host "  Modified: $($record.modified_on)" -ForegroundColor Gray
        Write-Host ""
    }
    
    # Check for CNAME specifically
    $cnameRecord = $records | Where-Object { $_.type -eq "CNAME" -and $_.name -like "*docs*" }
    if ($cnameRecord) {
        Write-Host "✅ CNAME record verified:" -ForegroundColor Green
        Write-Host "   $($cnameRecord.name) → $($cnameRecord.content)" -ForegroundColor Cyan
        if ($cnameRecord.content -eq "spectracoresolutions.github.io") {
            Write-Host "   ✅ Target is correct!" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  Target mismatch (expected: spectracoresolutions.github.io)" -ForegroundColor Yellow
        }
        if (-not $cnameRecord.proxied) {
            Write-Host "   ✅ Proxy status: DNS only (correct for GitHub Pages)" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  Proxy status: Proxied (should be DNS only for GitHub Pages)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "⚠️  No CNAME record found for docs subdomain" -ForegroundColor Yellow
    }
}

# Also check for TXT records (verification)
Write-Host "`nChecking for GitHub Pages verification TXT records..." -ForegroundColor Cyan
$txtResponse = Invoke-RestMethod -Method Get `
    -Uri "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records?type=TXT&name=_github-pages-challenge-docs" `
    -Headers $headers

if ($txtResponse.success -and $txtResponse.result.Count -gt 0) {
    Write-Host "✅ Found GitHub Pages verification TXT record:" -ForegroundColor Green
    foreach ($txt in $txtResponse.result) {
        Write-Host "   Name: $($txt.name)" -ForegroundColor White
        Write-Host "   Content: $($txt.content)" -ForegroundColor White
    }
} else {
    Write-Host "ℹ️  No GitHub Pages verification TXT record found (not needed if using GitHub Pages URL)" -ForegroundColor Gray
}

Write-Host "`n✅ DNS verification complete!" -ForegroundColor Green

