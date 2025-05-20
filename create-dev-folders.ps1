# Define base paths
$basePath = "$env:USERPROFILE\Dev"
$keysPath = "$env:USERPROFILE\.keys"
$dbtPath = "$env:USERPROFILE\.dbt"

# Development folder structure
$devFolders = @(
    "personal",
    "academic",
    "consulting",
    "sandbox",
    "dbt_projects"
)

# Keys folder structure
$keysFolders = @(
    "cloud\aws",
    "cloud\azure",
    "cloud\gcp",
    "databases\snowflake",
    "databases\postgres",
    "databases\mongodb",
    "ssh\github",
    "ssh\gitlab",
    "ssh\servers",
    "api\jira",
    "api\slack",
    "certificates\personal",
    "certificates\client"
)

# DBT folder structure
$dbtFolders = @(
    "keys\snowflake"
)

# Function to create directories
function Create-Directory {
    param (
        [string]$basePath,
        [string[]]$folders
    )
    
    foreach ($folder in $folders) {
        $fullPath = Join-Path -Path $basePath -ChildPath $folder
        if (-not (Test-Path $fullPath)) {
            New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
            Write-Host "Created: $fullPath"
        } else {
            Write-Host "Already exists: $fullPath"
        }
    }
}

# Create Dev folders
Write-Host "`n📁 Creating development directories..."
Create-Directory -basePath $basePath -folders $devFolders

# Create Keys folders
Write-Host "`n🔑 Creating keys directories..."
Create-Directory -basePath $keysPath -folders $keysFolders

# Create DBT folders
Write-Host "`n🔧 Creating dbt directories..."
Create-Directory -basePath $dbtPath -folders $dbtFolders

# Move Snowflake keys if they exist
$sourceKeyPublic = "$env:USERPROFILE\rsa_key.pub"
$sourceKeyPrivate = "$env:USERPROFILE\rsa_key"
$destKeyPath = "$keysPath\databases\snowflake"

if (Test-Path $sourceKeyPublic) {
    Write-Host "`n🔄 Moving Snowflake public key to new location..."
    Move-Item -Path $sourceKeyPublic -Destination "$destKeyPath\rsa_key.pub" -Force
    Write-Host "Moved: $sourceKeyPublic -> $destKeyPath\rsa_key.pub"
}

if (Test-Path $sourceKeyPrivate) {
    Write-Host "🔄 Moving Snowflake private key to new location..."
    Move-Item -Path $sourceKeyPrivate -Destination "$destKeyPath\rsa_key" -Force
    Write-Host "Moved: $sourceKeyPrivate -> $destKeyPath\rsa_key"
}

# Create a README file for key management
$readmePath = "$keysPath\README.md"
if (-not (Test-Path $readmePath)) {
    $readmeContent = @"
# Key Management

This directory contains authentication keys and certificates for various services.

## Directory Structure

- **cloud/** - Cloud provider credentials
  - aws/ - Amazon Web Services
  - azure/ - Microsoft Azure
  - gcp/ - Google Cloud Platform
- **databases/** - Database authentication
  - snowflake/ - Snowflake keys
  - postgres/ - PostgreSQL certificates
  - mongodb/ - MongoDB certificates
- **ssh/** - SSH keys
  - github/ - GitHub SSH keys
  - gitlab/ - GitLab SSH keys
  - servers/ - Server access keys
- **api/** - API keys and tokens
  - jira/ - Jira API tokens
  - slack/ - Slack API tokens
- **certificates/** - SSL/TLS certificates
  - personal/ - Personal certificates
  - client/ - Client certificates

## Security Notes

- Ensure these directories are excluded from version control
- Rotate keys regularly according to security policies
- Back up these keys securely

## Keys Inventory

| Key | Location | Used By | Expiry Date | Last Rotated |
|-----|----------|---------|-------------|--------------|
| Snowflake | databases/snowflake/ | dbt projects | N/A | $(Get-Date -Format "yyyy-MM-dd") |

"@
    Set-Content -Path $readmePath -Value $readmeContent
    Write-Host "`n📝 Created keys management README: $readmePath"
}

# Create .gitignore to prevent committing keys
$gitignorePath = "$keysPath\.gitignore"
if (-not (Test-Path $gitignorePath)) {
    $gitignoreContent = @"
# Ignore everything in this directory
*
# Except for this file
!.gitignore
!README.md
"@
    Set-Content -Path $gitignorePath -Value $gitignoreContent
    Write-Host "🛡️ Created .gitignore for keys directory"
}

# Set restrictive permissions on keys directory
Try {
    Write-Host "`n🔒 Setting restrictive permissions on keys directory..."
    icacls $keysPath /inheritance:r
    icacls $keysPath /grant:r "${env:USERNAME}:(OI)(CI)F"
    Write-Host "Permissions set successfully."
} Catch {
    Write-Host "⚠️ Could not set permissions. Run as administrator to set secure permissions."
}

Write-Host "`n✅ Complete directory structure created!"
Write-Host "`n📌 Next Steps:"
Write-Host "   1. Update your dbt profiles.yml to use keys from: $keysPath\databases\snowflake\rsa_key"
Write-Host "   2. Review the README in the keys directory for best practices"
Write-Host "   3. Ensure these directories are excluded from cloud sync services"
