# Updated Development Environment Setup Script (create-dev-folders.ps1)
# Final domain-based structure with hybrid dbt configuration

param(
    [string]$TargetDrive = "C",
    [switch]$Minimal,
    [switch]$CreateVirtualEnvs,
    [switch]$InstallCommonTools
)

Write-Host "🎯 Updated Development Environment Setup" -ForegroundColor Green
Write-Host "Target Drive: $TargetDrive" -ForegroundColor White
Write-Host "Minimal Setup: $Minimal" -ForegroundColor White

# Define base paths based on target drive
if ($TargetDrive -eq "D") {
    $masterPath = "D:\Dev"
    Write-Host "🎯 Setting up development environment on D: drive" -ForegroundColor Green
} else {
    $masterPath = "$env:USERPROFILE\Dev"
    Write-Host "🎯 Setting up development environment on C: drive" -ForegroundColor Green
}

# Main business domains
$domainFolders = @(
    "Academia",
    "Consulting", 
    "Ventures",
    "Learning"
)

# Academia subfolders
$academiaFolders = @("Projects", "SharedData", "Resources")

# Consulting subfolders  
$consultingFolders = @("Projects", "Proposals", "Deliverables")

# Ventures subfolders
$venturesFolders = @("Projects", "SharedData", "Ideas")

# Learning subfolders
$learningFolders = @("Projects", "Resources")

# Settings and system folders
$systemFolders = @("Settings")
$settingsSubFolders = @("Tools", "Cache", "Secure", "DBT")
$secureSubFolders = @("SSH", "Cloud", "Database", "API")
$dbtSubFolders = @("profiles", "logs", "target")

# Cache folders
$cacheFolders = @("pip", "npm", "gradle", "docker", "nuget")

function Create-Directory {
    param(
        [string]$basePath,
        [array]$folders,
        [string]$category
    )
    
    Write-Host "`n📁 Creating $category directories..." -ForegroundColor Magenta
    
    foreach ($folder in $folders) {
        $fullPath = Join-Path -Path $basePath -ChildPath $folder
        if (-not (Test-Path $fullPath)) {
            New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
            Write-Host "✅ Created: $fullPath" -ForegroundColor Green
        } else {
            Write-Host "📁 Already exists: $fullPath" -ForegroundColor Yellow
        }
    }
}

function Setup-ConfigurationFiles {
    Write-Host "`n⚙️ Setting up configuration files..." -ForegroundColor Magenta
    
    # Create master directory if it doesn't exist
    if (-not (Test-Path $masterPath)) {
        New-Item -ItemType Directory -Path $masterPath -Force | Out-Null
        Write-Host "✅ Created master directory: $masterPath" -ForegroundColor Green
    }
    
    # Environment variables setup script
    $docsPath = Join-Path -Path $masterPath -ChildPath "Settings\Tools"
    $envConfigPath = Join-Path -Path $docsPath -ChildPath "env-setup.ps1"
    
    $envConfig = @"
# Development Environment Variables Setup
# Run this script to configure your development environment

Write-Host "🔧 Configuring development environment..." -ForegroundColor Cyan

# Development Paths
`$env:DEV_MASTER = "$masterPath"
`$env:ACADEMIA_HOME = "$masterPath\Academia"
`$env:CONSULTING_HOME = "$masterPath\Consulting"
`$env:VENTURES_HOME = "$masterPath\Ventures"
`$env:LEARNING_HOME = "$masterPath\Learning"
`$env:SETTINGS_HOME = "$masterPath\Settings"

# Tool Paths
`$env:TOOLS_HOME = "$masterPath\Settings\Tools"
`$env:CACHE_HOME = "$masterPath\Settings\Cache"
`$env:SECURE_HOME = "$masterPath\Settings\Secure"
`$env:DBT_PROFILES_DIR = "$masterPath\Settings\DBT\profiles"

# Python Configuration
`$env:PIP_CACHE_DIR = "$masterPath\Settings\Cache\pip"
`$env:PIPENV_VENV_IN_PROJECT = "1"

# Node.js Configuration
`$env:NPM_CONFIG_CACHE = "$masterPath\Settings\Cache\npm"

# Android Configuration
`$env:ANDROID_HOME = "$masterPath\Settings\Tools\Android"
`$env:GRADLE_USER_HOME = "$masterPath\Settings\Cache\gradle"

# Docker Configuration
`$env:DOCKER_CONFIG = "$masterPath\Settings\Tools\Docker"

# Add development tools to PATH
`$env:PATH = "`$env:PATH;$masterPath\Settings\Tools\Scripts"

Write-Host "✅ Environment variables configured!" -ForegroundColor Green
Write-Host "💡 Restart your terminal or IDE to use new environment variables" -ForegroundColor Cyan
"@

    Set-Content -Path $envConfigPath -Value $envConfig
    Write-Host "⚡ Created environment setup: $envConfigPath" -ForegroundColor Green

    # Create development guide
    $projectGuideContent = @"
# 📁 Development Environment Guide

## 🏗️ Master Directory Structure

Your development environment is organized under: **$masterPath**

```
$masterPath\
├── Academia\           # 🎓 Academic & research projects
│   ├── Projects\       # Research development projects
│   ├── SharedData\     # Research datasets used across projects
│   └── Resources\      # Academic references, documentation
├── Consulting\         # 💼 Client work
│   ├── Projects\       # Client development projects
│   ├── Proposals\      # SOWs, contracts, quotes
│   └── Deliverables\   # Reports, presentations
├── Ventures\           # 🚀 Your business projects
│   ├── Projects\       # Business development projects
│   ├── SharedData\     # Business data used across projects
│   └── Ideas\          # Business concepts, notes
├── Learning\           # 📚 Personal training & hands-on labs
│   ├── Projects\       # Learning lab projects
│   └── Resources\      # Course materials, documentation
└── Settings\           # ⚙️ Shared infrastructure
    ├── Tools\          # Scripts, utilities, configs
    ├── Cache\          # Build caches (pip, gradle, etc.)
    ├── Secure\         # All credentials & keys
    │   ├── SSH\        # SSH keys and configurations
    │   ├── Cloud\      # AWS, Azure, GCP credentials
    │   ├── Database\   # Database connection strings
    │   └── API\        # API keys and tokens
    └── DBT\            # Global dbt profiles and configurations
        ├── profiles\   # Global profiles.yml (Snowflake connections)
        ├── logs\       # Global dbt logs
        └── target\     # Global compiled files
```

## 📂 Domain-Based Organization

### 🎓 Academia
Research and academic projects using any required tools (Python, dbt, R, Snowflake).
- **Projects**: Research development projects with .venv
- **SharedData**: Research datasets shared across projects
- **Resources**: Academic references and documentation

### 💼 Consulting
Professional client work with deliverables.
- **Projects**: Client development projects (any tech stack)
- **Proposals**: SOWs, contracts, quotes
- **Deliverables**: Reports, presentations, final outputs

### 🚀 Ventures
Your business and entrepreneurial projects.
- **Projects**: Business development projects with .venv
- **SharedData**: Business data shared across ventures
- **Ideas**: Business concepts, notes, planning

### 📚 Learning
Personal training and hands-on laboratory work.
- **Projects**: Learning lab projects with .venv
- **Resources**: Course materials, documentation

### ⚙️ Settings
Shared infrastructure and configurations.
- **Tools**: Scripts, utilities, development tools
- **Cache**: Build caches (pip, npm, gradle, docker)
- **Secure**: All credentials and keys (SSH, Cloud, Database, API)
- **DBT**: Global dbt profiles and Snowflake connections

## 🎯 DBT Configuration Strategy

### Global DBT Settings (Settings\DBT\)
- **profiles.yml**: Global Snowflake connection profiles
- **logs**: All dbt execution logs
- **target**: Global compiled artifacts

### Project-Specific DBT
Each project with dbt work contains:
```
ProjectName\
├── .venv\
├── src\
├── dbt_project\
│   ├── models\
│   ├── macros\
│   ├── seeds\
│   └── dbt_project.yml
```

## 🔄 Quick Navigation Commands

Run these PowerShell functions for fast navigation:

```powershell
# Domain navigation
academia          # Go to Academia
consulting        # Go to Consulting  
ventures          # Go to Ventures
learning          # Go to Learning
settings          # Go to Settings

# Project navigation
academia-projects     # Go to Academia\Projects
consulting-projects   # Go to Consulting\Projects
ventures-projects     # Go to Ventures\Projects
learning-projects     # Go to Learning\Projects

# System navigation
tools            # Go to Settings\Tools
secure           # Go to Settings\Secure
ssh              # Go to Settings\Secure\SSH
dbt-global       # Go to Settings\DBT
cache            # Go to Settings\Cache
```

## 🚀 Development Workflow

### Starting a New Project
1. Navigate to appropriate domain: `ventures-projects`
2. Create or clone project: `git clone <repo>` or `mkdir NewProject`
3. Setup environment: `cd NewProject && python -m venv .venv`
4. Activate environment: `.venv\Scripts\activate`
5. Install dependencies: `pip install -r requirements.txt`
6. Start development with your tech stack

### Tech Stack Integration
- **Python**: Virtual environments (.venv) stay with each project
- **dbt**: Global profiles in Settings\DBT\, project models in project\dbt_project\
- **Android**: Projects in any domain, SDK tools in Settings\Tools\
- **Visual Studio**: Solutions in any domain as needed
- **Snowflake**: Global connection profiles, project-specific models

## 💡 Best Practices

- Keep virtual environments with their projects
- Use Git branches for prototyping and feature development
- Store shared datasets in domain SharedData folders
- Keep project-specific data within project folders
- Use global dbt profiles for consistent Snowflake connections
- Secure all credentials in Settings\Secure\ with proper permissions

---

🏠 Environment Root: $masterPath
📅 Created: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
🖥️ Machine: $env:COMPUTERNAME
👤 User: $env:USERNAME
"@

    $projectGuidePath = Join-Path -Path $docsPath -ChildPath "README.md"
    Set-Content -Path $projectGuidePath -Value $projectGuideContent
    Write-Host "📋 Created development environment guide: $projectGuidePath" -ForegroundColor Green

    # Create PowerShell functions
    $functionsPath = Join-Path -Path $docsPath -ChildPath "dev-functions.ps1"
    $functionsContent = @"
# Development Environment Helper Functions
# Source this file: . .\dev-functions.ps1

# Domain navigation functions
function academia { Set-Location "$masterPath\Academia" }
function consulting { Set-Location "$masterPath\Consulting" }
function ventures { Set-Location "$masterPath\Ventures" }
function learning { Set-Location "$masterPath\Learning" }
function settings { Set-Location "$masterPath\Settings" }

# Quick project access within domains
function academia-projects { Set-Location "$masterPath\Academia\Projects" }
function consulting-projects { Set-Location "$masterPath\Consulting\Projects" }
function ventures-projects { Set-Location "$masterPath\Ventures\Projects" }
function learning-projects { Set-Location "$masterPath\Learning\Projects" }

# System and configuration navigation
function tools { Set-Location "$masterPath\Settings\Tools" }
function secure { Set-Location "$masterPath\Settings\Secure" }
function ssh { Set-Location "$masterPath\Settings\Secure\SSH" }
function dbt-global { Set-Location "$masterPath\Settings\DBT" }
function cache { Set-Location "$masterPath\Settings\Cache" }

# Project management functions
function New-DomainProject {
    param(
        [Parameter(Mandatory)]
        [ValidateSet("Academia", "Consulting", "Ventures", "Learning")]
        [string]`$Domain,
        
        [Parameter(Mandatory)]
        [string]`$ProjectName
    )
    
    `$projectPath = Join-Path -Path "$masterPath\`$Domain\Projects" -ChildPath `$ProjectName
    
    if (Test-Path `$projectPath) {
        Write-Host "❌ Project already exists: `$projectPath" -ForegroundColor Red
        return
    }
    
    # Create project directory
    New-Item -ItemType Directory -Path `$projectPath -Force | Out-Null
    
    # Create basic structure
    `$subDirs = @("src", "data", "tests", "docs")
    foreach (`$dir in `$subDirs) {
        New-Item -ItemType Directory -Path (Join-Path `$projectPath `$dir) -Force | Out-Null
    }
    
    # Create virtual environment
    Set-Location `$projectPath
    python -m venv .venv
    
    # Create basic files
    Set-Content -Path (Join-Path `$projectPath "README.md") -Value "# `$ProjectName`n`nProject created: `$(Get-Date -Format 'yyyy-MM-dd')"
    Set-Content -Path (Join-Path `$projectPath "requirements.txt") -Value "# Python dependencies`n"
    Set-Content -Path (Join-Path `$projectPath ".gitignore") -Value ".venv/`n__pycache__/`n*.pyc`n.env`n"
    
    Write-Host "✅ Created project: `$projectPath" -ForegroundColor Green
    Write-Host "💡 Navigate: Set-Location `$projectPath" -ForegroundColor Cyan
    Write-Host "💡 Activate: .venv\Scripts\activate" -ForegroundColor Cyan
}

function Show-DevSummary {
    Write-Host "`n📊 Development Environment Summary" -ForegroundColor Cyan
    Write-Host "🏠 Master Path: $masterPath" -ForegroundColor White
    
    `$domains = @("Academia", "Consulting", "Ventures", "Learning")
    foreach (`$domain in `$domains) {
        `$domainPath = Join-Path -Path "$masterPath" -ChildPath `$domain
        `$projectsPath = Join-Path -Path `$domainPath -ChildPath "Projects"
        
        if (Test-Path `$projectsPath) {
            `$projectCount = (Get-ChildItem -Path `$projectsPath -Directory).Count
            Write-Host "📁 `$domain`: `$projectCount projects" -ForegroundColor White
        }
    }
    
    Write-Host "`n🔧 Quick Commands:" -ForegroundColor Yellow
    Write-Host "  New-DomainProject -Domain Ventures -ProjectName 'MyApp'" -ForegroundColor Gray
    Write-Host "  ventures-projects, learning-projects, academia-projects" -ForegroundColor Gray
    Write-Host "  tools, secure, ssh, dbt-global" -ForegroundColor Gray
}

Write-Host "✅ Development functions loaded!" -ForegroundColor Green
Write-Host "💡 Try: academia, ventures, learning, consulting" -ForegroundColor Cyan
Write-Host "🚀 Management: New-DomainProject, Show-DevSummary" -ForegroundColor Cyan
"@

    Set-Content -Path $functionsPath -Value $functionsContent
    Write-Host "⚡ Created helper functions: $functionsPath" -ForegroundColor Green

    # Setup global dbt profile
    $dbtProfilesPath = Join-Path -Path $masterPath -ChildPath "Settings\DBT\profiles"
    $dbtProfilePath = Join-Path -Path $dbtProfilesPath -ChildPath "profiles.yml"
    
    if (-not (Test-Path $dbtProfilePath)) {
        $dbtProfileContent = @"
# Global dbt Profiles Configuration
# Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

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
      client_session_keep_alive: false
      query_tag: dbt_dev
      
    prod:
      type: snowflake
      account: "{{ env_var('SNOWFLAKE_ACCOUNT') }}"
      user: "{{ env_var('SNOWFLAKE_PROD_USER') }}"
      password: "{{ env_var('SNOWFLAKE_PROD_PASSWORD') }}"
      role: "{{ env_var('SNOWFLAKE_PROD_ROLE') }}"
      database: "{{ env_var('SNOWFLAKE_PROD_DATABASE') }}"
      warehouse: "{{ env_var('SNOWFLAKE_PROD_WAREHOUSE') }}"
      schema: "{{ env_var('SNOWFLAKE_PROD_SCHEMA') }}"
      threads: 8
      client_session_keep_alive: false
      query_tag: dbt_prod
      
  target: dev
"@
        Set-Content -Path $dbtProfilePath -Value $dbtProfileContent -Encoding UTF8
        Write-Host "✅ Created global dbt profile: $dbtProfilePath" -ForegroundColor Green
    }
}

# Main execution starts here
Write-Host "`n🏗️ Creating master development directory..." -ForegroundColor Magenta
if (-not (Test-Path $masterPath)) {
    New-Item -ItemType Directory -Path $masterPath -Force | Out-Null
    Write-Host "✅ Created master directory: $masterPath" -ForegroundColor Green
} else {
    Write-Host "📁 Master directory already exists: $masterPath" -ForegroundColor Yellow
}

# Create main domain directories
Write-Host "`n📁 Creating domain directories..." -ForegroundColor Magenta
foreach ($domain in $domainFolders) {
    $domainPath = Join-Path -Path $masterPath -ChildPath $domain
    if (-not (Test-Path $domainPath)) {
        New-Item -ItemType Directory -Path $domainPath -Force | Out-Null
        Write-Host "✅ Created domain: $domainPath" -ForegroundColor Green
    } else {
        Write-Host "📁 Domain already exists: $domainPath" -ForegroundColor Yellow
    }
}

# Create Academia subfolders
$academiaPath = Join-Path -Path $masterPath -ChildPath "Academia"
Create-Directory -basePath $academiaPath -folders $academiaFolders -category "Academia"

# Create Consulting subfolders
$consultingPath = Join-Path -Path $masterPath -ChildPath "Consulting"
Create-Directory -basePath $consultingPath -folders $consultingFolders -category "Consulting"

# Create Ventures subfolders
$venturesPath = Join-Path -Path $masterPath -ChildPath "Ventures"
Create-Directory -basePath $venturesPath -folders $venturesFolders -category "Ventures"

# Create Learning subfolders
$learningPath = Join-Path -Path $masterPath -ChildPath "Learning"
Create-Directory -basePath $learningPath -folders $learningFolders -category "Learning"

# Create Settings directory and subfolders
$settingsPath = Join-Path -Path $masterPath -ChildPath "Settings"
Create-Directory -basePath $settingsPath -folders $settingsSubFolders -category "Settings"

# Create Secure subfolders
$securePath = Join-Path -Path $settingsPath -ChildPath "Secure"
Create-Directory -basePath $securePath -folders $secureSubFolders -category "Secure"

# Create DBT subfolders
$dbtPath = Join-Path -Path $settingsPath -ChildPath "DBT"
Create-Directory -basePath $dbtPath -folders $dbtSubFolders -category "DBT"

# Create Cache subfolders
$cachePath = Join-Path -Path $settingsPath -ChildPath "Cache"
Create-Directory -basePath $cachePath -folders $cacheFolders -category "Cache"

# Setup configuration files and documentation
Setup-ConfigurationFiles

# Final summary
Write-Host @"

===========================================
🎉 DEVELOPMENT ENVIRONMENT SETUP COMPLETE!
===========================================

📍 Environment Details:
  🏠 Master Directory: $masterPath
  
📁 Domain Structure:
  🎓 Academia: $masterPath\Academia
  💼 Consulting: $masterPath\Consulting
  🚀 Ventures: $masterPath\Ventures
  📚 Learning: $masterPath\Learning
  ⚙️ Settings: $masterPath\Settings

🚀 Next Steps:
  1. Run: $masterPath\Settings\Tools\env-setup.ps1 (configure environment variables)
  2. Read: $masterPath\Settings\Tools\README.md (comprehensive guide)
  3. Load: . $masterPath\Settings\Tools\dev-functions.ps1 (helper functions)
  4. Start: Create your first project with New-DomainProject!

💡 Quick Start Commands:
  - New project: New-DomainProject -Domain Ventures -ProjectName "MyApp"
  - Navigate: academia, ventures, learning, consulting
  - Projects: academia-projects, ventures-projects, learning-projects
  - System: tools, secure, ssh, dbt-global, cache
  - Summary: Show-DevSummary

📚 Documentation Created:
  - Environment Guide: $masterPath\Settings\Tools\README.md
  - Helper Functions: $masterPath\Settings\Tools\dev-functions.ps1
  - Environment Setup: $masterPath\Settings\Tools\env-setup.ps1
  - Global dbt Profile: $masterPath\Settings\DBT\profiles\profiles.yml

🔄 Reusable Setup:
  This script can be used on any new machine to recreate your development environment!

===========================================
"@ -ForegroundColor Green

Write-Host "✅ Setup complete! Happy coding! 🚀" -ForegroundColor Green
