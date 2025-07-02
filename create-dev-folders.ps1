# Development Environment Setup Script
param(
    [string]$TargetDrive = "C"
)

Write-Host "Development Environment Setup" -ForegroundColor Green
Write-Host "Target Drive: $TargetDrive" -ForegroundColor White

# Define base paths
if ($TargetDrive -eq "D") {
    $masterPath = "D:\Dev"
    Write-Host "Setting up on D: drive" -ForegroundColor Green
} else {
    $masterPath = "$env:USERPROFILE\Dev"
    Write-Host "Setting up on C: drive" -ForegroundColor Green
}

# Domain folders
$domainFolders = @("Academia", "Consulting", "Ventures", "Learning")

# Subfolders for each domain
$academiaFolders = @("Projects", "SharedData", "Resources")
$consultingFolders = @("Projects", "Proposals", "Deliverables")
$venturesFolders = @("Projects", "SharedData", "Ideas")
$learningFolders = @("Projects", "Resources")

# Settings folders
$settingsSubFolders = @("Tools", "Cache", "Secure", "DBT")
$secureSubFolders = @("SSH", "Cloud", "Database", "API")
$dbtSubFolders = @("profiles", "logs", "target")
$cacheFolders = @("pip", "npm", "gradle", "docker", "nuget")

function Create-Directory {
    param(
        [string]$basePath,
        [array]$folders,
        [string]$category
    )
    
    Write-Host "Creating $category directories..." -ForegroundColor Magenta
    
    foreach ($folder in $folders) {
        $fullPath = Join-Path -Path $basePath -ChildPath $folder
        if (-not (Test-Path $fullPath)) {
            New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
            Write-Host "Created: $fullPath" -ForegroundColor Green
        } else {
            Write-Host "Already exists: $fullPath" -ForegroundColor Yellow
        }
    }
}

# Main execution
Write-Host "Creating master development directory..." -ForegroundColor Magenta
if (-not (Test-Path $masterPath)) {
    New-Item -ItemType Directory -Path $masterPath -Force | Out-Null
    Write-Host "Created master directory: $masterPath" -ForegroundColor Green
} else {
    Write-Host "Master directory already exists: $masterPath" -ForegroundColor Yellow
}

# Create main domain directories
Write-Host "Creating domain directories..." -ForegroundColor Magenta
foreach ($domain in $domainFolders) {
    $domainPath = Join-Path -Path $masterPath -ChildPath $domain
    if (-not (Test-Path $domainPath)) {
        New-Item -ItemType Directory -Path $domainPath -Force | Out-Null
        Write-Host "Created domain: $domainPath" -ForegroundColor Green
    } else {
        Write-Host "Domain already exists: $domainPath" -ForegroundColor Yellow
    }
}

# Create domain subfolders
$academiaPath = Join-Path -Path $masterPath -ChildPath "Academia"
Create-Directory -basePath $academiaPath -folders $academiaFolders -category "Academia"

$consultingPath = Join-Path -Path $masterPath -ChildPath "Consulting"
Create-Directory -basePath $consultingPath -folders $consultingFolders -category "Consulting"

$venturesPath = Join-Path -Path $masterPath -ChildPath "Ventures"
Create-Directory -basePath $venturesPath -folders $venturesFolders -category "Ventures"

$learningPath = Join-Path -Path $masterPath -ChildPath "Learning"
Create-Directory -basePath $learningPath -folders $learningFolders -category "Learning"

# Create Settings directory and subfolders
$settingsPath = Join-Path -Path $masterPath -ChildPath "Settings"
Create-Directory -basePath $settingsPath -folders $settingsSubFolders -category "Settings"

$securePath = Join-Path -Path $settingsPath -ChildPath "Secure"
Create-Directory -basePath $securePath -folders $secureSubFolders -category "Secure"

$dbtPath = Join-Path -Path $settingsPath -ChildPath "DBT"
Create-Directory -basePath $dbtPath -folders $dbtSubFolders -category "DBT"

$cachePath = Join-Path -Path $settingsPath -ChildPath "Cache"
Create-Directory -basePath $cachePath -folders $cacheFolders -category "Cache"

# Create basic configuration files
Write-Host "Setting up configuration files..." -ForegroundColor Magenta

# Create simple PowerShell functions file
$toolsPath = Join-Path -Path $settingsPath -ChildPath "Tools"
$functionsPath = Join-Path -Path $toolsPath -ChildPath "dev-functions.ps1"

$functionsContent = @'
# Development Environment Helper Functions
# Source this file: . .\dev-functions.ps1

function academia { Set-Location "MASTER_PATH_PLACEHOLDER\Academia" }
function consulting { Set-Location "MASTER_PATH_PLACEHOLDER\Consulting" }
function ventures { Set-Location "MASTER_PATH_PLACEHOLDER\Ventures" }
function learning { Set-Location "MASTER_PATH_PLACEHOLDER\Learning" }
function settings { Set-Location "MASTER_PATH_PLACEHOLDER\Settings" }

function academia-projects { Set-Location "MASTER_PATH_PLACEHOLDER\Academia\Projects" }
function consulting-projects { Set-Location "MASTER_PATH_PLACEHOLDER\Consulting\Projects" }
function ventures-projects { Set-Location "MASTER_PATH_PLACEHOLDER\Ventures\Projects" }
function learning-projects { Set-Location "MASTER_PATH_PLACEHOLDER\Learning\Projects" }

function tools { Set-Location "MASTER_PATH_PLACEHOLDER\Settings\Tools" }
function secure { Set-Location "MASTER_PATH_PLACEHOLDER\Settings\Secure" }
function ssh { Set-Location "MASTER_PATH_PLACEHOLDER\Settings\Secure\SSH" }
function dbt-global { Set-Location "MASTER_PATH_PLACEHOLDER\Settings\DBT" }
function cache { Set-Location "MASTER_PATH_PLACEHOLDER\Settings\Cache" }

Write-Host "Development functions loaded!" -ForegroundColor Green
Write-Host "Try: academia, ventures, learning, consulting" -ForegroundColor Cyan
'@

$functionsContent = $functionsContent -replace "MASTER_PATH_PLACEHOLDER", $masterPath
Set-Content -Path $functionsPath -Value $functionsContent
Write-Host "Created helper functions: $functionsPath" -ForegroundColor Green

# Create simple environment setup script
$envSetupPath = Join-Path -Path $toolsPath -ChildPath "env-setup.ps1"
$envContent = @'
# Development Environment Variables Setup
Write-Host "Configuring development environment..." -ForegroundColor Cyan

$env:DEV_MASTER = "MASTER_PATH_PLACEHOLDER"
$env:DBT_PROFILES_DIR = "MASTER_PATH_PLACEHOLDER\Settings\DBT\profiles"
$env:PIP_CACHE_DIR = "MASTER_PATH_PLACEHOLDER\Settings\Cache\pip"

Write-Host "Environment variables configured!" -ForegroundColor Green
'@

$envContent = $envContent -replace "MASTER_PATH_PLACEHOLDER", $masterPath
Set-Content -Path $envSetupPath -Value $envContent
Write-Host "Created environment setup: $envSetupPath" -ForegroundColor Green

# Create basic README
$readmePath = Join-Path -Path $toolsPath -ChildPath "README.md"
$readmeContent = @'
# Development Environment Guide

## Directory Structure

Your development environment is organized under: **MASTER_PATH_PLACEHOLDER**

### Domains
- Academia: Academic and research projects
- Consulting: Client work and deliverables  
- Ventures: Your business projects
- Learning: Personal training and hands-on labs
- Settings: Shared infrastructure

### Quick Navigation
Load functions with: . .\Settings\Tools\dev-functions.ps1

Then use: academia, ventures, learning, consulting

Created: DATE_PLACEHOLDER
'@

$readmeContent = $readmeContent -replace "MASTER_PATH_PLACEHOLDER", $masterPath
$readmeContent = $readmeContent -replace "DATE_PLACEHOLDER", (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Set-Content -Path $readmePath -Value $readmeContent
Write-Host "Created README: $readmePath" -ForegroundColor Green

# Create basic dbt profile
$dbtProfilesPath = Join-Path -Path $dbtPath -ChildPath "profiles"
$dbtProfilePath = Join-Path -Path $dbtProfilesPath -ChildPath "profiles.yml"

if (-not (Test-Path $dbtProfilePath)) {
    $dbtContent = @'
# Global dbt Profiles Configuration
default:
  outputs:
    dev:
      type: snowflake
      account: "{{ env_var('SNOWFLAKE_ACCOUNT') }}"
      user: "{{ env_var('SNOWFLAKE_USER') }}"
      password: "{{ env_var('SNOWFLAKE_PASSWORD') }}"
      role: "{{ env_var('SNOWFLAKE_ROLE') }}"
      database: "{{ env_var('SNOWFLAKE_DATABASE') }}"
      warehouse: "{{ env_var('SNOWFLAKE_WAREHOUSE') }}"
      schema: "{{ env_var('SNOWFLAKE_SCHEMA') }}"
      threads: 4
  target: dev
'@
    
    Set-Content -Path $dbtProfilePath -Value $dbtContent -Encoding UTF8
    Write-Host "Created dbt profile: $dbtProfilePath" -ForegroundColor Green
}

# Final summary
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "DEVELOPMENT ENVIRONMENT SETUP COMPLETE!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Environment Details:" -ForegroundColor Cyan
Write-Host "  Master Directory: $masterPath" -ForegroundColor White
Write-Host ""
Write-Host "Domain Structure:" -ForegroundColor Cyan
Write-Host "  Academia: $masterPath\Academia" -ForegroundColor White
Write-Host "  Consulting: $masterPath\Consulting" -ForegroundColor White
Write-Host "  Ventures: $masterPath\Ventures" -ForegroundColor White
Write-Host "  Learning: $masterPath\Learning" -ForegroundColor White
Write-Host "  Settings: $masterPath\Settings" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Load functions: . $masterPath\Settings\Tools\dev-functions.ps1" -ForegroundColor Gray
Write-Host "  2. Run env setup: $masterPath\Settings\Tools\env-setup.ps1" -ForegroundColor Gray
Write-Host "  3. Read guide: $masterPath\Settings\Tools\README.md" -ForegroundColor Gray
Write-Host ""
Write-Host "Setup complete! Happy coding!" -ForegroundColor Green
