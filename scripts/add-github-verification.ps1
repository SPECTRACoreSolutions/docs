#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Add GitHub Pages domain verification TXT record to Cloudflare DNS

.DESCRIPTION
    Creates a TXT record for GitHub Pages domain verification.
    You need to get the verification code from GitHub first by adding the domain
    in GitHub Pages settings.

.PARAMETER VerificationCode
    The verification code provided by GitHub (starts with "github-pages-domain-verification=")

.PARAMETER ZoneName
    Cloudflare zone name (default: spectradatasolutions.com)
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$VerificationCode,
    
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
} else {
    $headers["Authorization"] = "Bearer $ApiToken"
}

# Get zone ID
Write-Host "Getting zone ID for $ZoneName..."
$zoneResponse = Invoke-RestMethod -Method Get `
    -Uri "https://api.cloudflare.com/client/v4/zones?name=$ZoneName" `
    -Headers $headers

if (-not $zoneResponse.success -or $zoneResponse.result.Count -eq 0) {
    Write-Error "Failed to get zone ID. Check your API token and zone name."
    exit 1
}

$zoneId = $zoneResponse.result[0].id
Write-Host "✅ Zone ID: $zoneId" -ForegroundColor Green

# Determine TXT record name
# GitHub uses: _github-pages-challenge-<username> or _github-pages-challenge-<org>
# For docs.spectradatasolutions.com, it should be: _github-pages-challenge-docs
$txtRecordName = "_github-pages-challenge-docs"

Write-Host "Creating TXT record: $txtRecordName -> $VerificationCode"

# Check if record already exists
$existingRecords = Invoke-RestMethod -Method Get `
    -Uri "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records?type=TXT&name=$txtRecordName" `
    -Headers $headers

if ($existingRecords.success -and $existingRecords.result.Count -gt 0) {
    $existing = $existingRecords.result[0]
    Write-Host "⚠️  TXT record already exists:" -ForegroundColor Yellow
    Write-Host "   ID: $($existing.id)"
    Write-Host "   Name: $($existing.name)"
    Write-Host "   Content: $($existing.content)"
    
    if ($existing.content -eq $VerificationCode) {
        Write-Host "✅ Record is already correctly configured!" -ForegroundColor Green
        exit 0
    } else {
        $update = Read-Host "Update existing record? (y/n)"
        if ($update -eq 'y') {
            # Update existing record
            $body = @{
                type = "TXT"
                name = $txtRecordName
                content = $VerificationCode
                ttl = 3600
            } | ConvertTo-Json
            
            $updateResponse = Invoke-RestMethod -Method Put `
                -Uri "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records/$($existing.id)" `
                -Headers $headers `
                -Body $body
            
            if ($updateResponse.success) {
                Write-Host "✅ TXT record updated successfully!" -ForegroundColor Green
                Write-Host "   Record ID: $($updateResponse.result.id)"
            } else {
                Write-Error "Failed to update record: $($updateResponse.errors | ConvertTo-Json)"
            }
        }
        exit 0
    }
}

# Create new TXT record
$body = @{
    type = "TXT"
    name = $txtRecordName
    content = $VerificationCode
    ttl = 3600
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Method Post `
        -Uri "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records" `
        -Headers $headers `
        -Body $body
    
    if ($response.success) {
        Write-Host "✅ TXT record created successfully!" -ForegroundColor Green
        Write-Host "   Record ID: $($response.result.id)"
        Write-Host "   Name: $($response.result.name)"
        Write-Host "   Content: $($response.result.content)"
        Write-Host ""
        Write-Host "Next steps:"
        Write-Host "1. Wait for DNS propagation (usually 5-15 minutes)"
        Write-Host "2. GitHub will automatically verify the domain"
        Write-Host "3. Check status in GitHub Pages settings"
    } else {
        Write-Error "Failed to create TXT record: $($response.errors | ConvertTo-Json)"
    }
} catch {
    Write-Error "Error creating TXT record: $_"
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response: $responseBody" -ForegroundColor Red
    }
}

