# Portable Development Environment Setup Script
# Use this script to recreate your development environment on any new machine
param(
    [string]$TargetDrive = "C",
    [switch]$CreateVirtualEnvs = $false,
    [switch]$InstallCommonTools = $false,
    [switch]$Verbose = $false,
    [switch]$Minimal = $false
)

# Display banner
Write-Host @"
🚀 Portable Development Environment Setup
========================================
Creating your standardized development environment...
Target Drive: $TargetDrive
Create Virtual Environments: $CreateVirtualEnvs
Install Common Tools: $InstallCommonTools
Minimal Setup: $Minimal
"@ -ForegroundColor Cyan

# Define base paths based on target drive
if ($TargetDrive -eq "D") {
    $basePath = "D:\Dev"
    $keysPath = "D:\Keys"
    $dbtPath = "D:\Tools\dbt"
    $toolsPath = "D:\Tools"
    $cachePath = "D:\Cache"
    Write-Host "🎯 Setting up development environment on D: drive" -ForegroundColor Green
} else {
    $basePath = "$env:USERPROFILE\Dev"
    $keysPath = "$env:USERPROFILE\.keys"
    $dbtPath = "$env:USERPROFILE\.dbt"
    $toolsPath = "$env:USERPROFILE\.tools"
    $cachePath = "$env:USERPROFILE\.cache"
    Write-Host "🎯 Setting up development environment on C: drive" -ForegroundColor Green
}

# Core development folder structure (always created)
$devFoldersCore = @(
    "personal",          # Hobby projects, utilities (no commercial intent)
    "academic",          # School/research work  
    "consulting",        # Client work
    "ventures",          # Business projects with growth potential
    "sandbox",           # Experiments, learning, throwaway code
    "dbt_projects",      # Data transformation work
    "portfolio",         # Showcase work for career/reputation
    "archive"            # Old/completed projects
)

# Extended folders (only if not minimal)
$devFoldersExtended = @(
    "flutter_projects",  # Flutter-specific development
    "web_projects",      # Web development projects
    "mobile_projects",   # Mobile app development
    "data_science",      # Data science and ML projects
    "devops",            # Infrastructure and deployment
    "learning",          # Course materials and tutorials
    "templates"          # Project templates and boilerplates
)

# Determine which folders to create
if ($Minimal) {
    $devFolders = $devFoldersCore
    Write-Host "📦 Minimal setup - creating core directories only" -ForegroundColor Yellow
} else {
    $devFolders = $devFoldersCore + $devFoldersExtended
    Write-Host "📦 Full setup - creating all directories" -ForegroundColor Green
}

# Tools folder structure
$toolsFoldersCore = @(
    "Python-Envs\personal",
    "Python-Envs\academic",
    "Python-Envs\consulting", 
    "Python-Envs\ventures",
    "Python-Envs\sandbox",
    "Python-Envs\dbt_projects",
    "Python-Envs\portfolio"
)

$toolsFoldersExtended = @(
    "Flutter-SDK",
    "Node-Modules",
    "Git-Repos",
    "Docker-Volumes",
    "Databases\Local",
    "Scripts\Automation",
    "Scripts\Deployment",
    "Backups"
)

if ($Minimal) {
    $toolsFolders = $toolsFoldersCore
} else {
    $toolsFolders = $toolsFoldersCore + $toolsFoldersExtended
}

# Cache folder structure
$cacheFoldersCore = @(
    "pip",
    "npm",
    "dbt\logs",
    "dbt\target"
)

$cacheFoldersExtended = @(
    "flutter",
    "poetry",
    "conda",
    "docker",
    "gradle",
    "maven",
    "nuget",
    "composer"
)

if ($Minimal) {
    $cacheFolders = $cacheFoldersCore
} else {
    $cacheFolders = $cacheFoldersCore + $cacheFoldersExtended
}

# Keys folder structure (security-focused)
$keysFolders = @(
    "cloud\aws",
    "cloud\azure", 
    "cloud\gcp",
    "cloud\digitalocean",
    "databases\snowflake",
    "databases\postgres",
    "databases\mongodb",
    "databases\mysql",
    "databases\redis",
    "ssh\github",
    "ssh\gitlab",
    "ssh\bitbucket",
    "ssh\servers",
    "api\jira",
    "api\slack",
    "api\github",
    "api\openai",
    "api\anthropic",
    "certificates\personal",
    "certificates\client",
    "certificates\ssl",
    "vpn",
    "backup"
)

# DBT folder structure
$dbtFolders = @(
    "profiles",
    "keys\snowflake",
    "logs",
    "target",
    "macros",
    "seeds"
)

# Function to create directories with enhanced feedback
function Create-Directory {
    param (
        [string]$basePath,
        [string[]]$folders,
        [string]$category = "Directory"
    )
    
    $created = 0
    $existing = 0
    
    foreach ($folder in $folders) {
        $fullPath = Join-Path -Path $basePath -ChildPath $folder
        if (-not (Test-Path $fullPath)) {
            try {
                New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
                if ($Verbose) { Write-Host "✅ Created: $fullPath" -ForegroundColor Green }
                $created++
            } catch {
                Write-Host "❌ Failed to create: $fullPath - $($_.Exception.Message)" -ForegroundColor Red
            }
        } else {
            if ($Verbose) { Write-Host "📁 Already exists: $fullPath" -ForegroundColor Yellow }
            $existing++
        }
    }
    
    Write-Host "📊 $category Summary: $created created, $existing already existed" -ForegroundColor Cyan
}

# Function to create virtual environments
function Create-VirtualEnvironments {
    Write-Host "`n🐍 Creating Python virtual environments..." -ForegroundColor Magenta
    
    $pythonExe = Get-Command python -ErrorAction SilentlyContinue
    if (-not $pythonExe) {
        Write-Host "⚠️ Python not found in PATH. Skipping virtual environment creation." -ForegroundColor Yellow
        Write-Host "💡 Install Python first, then re-run with -CreateVirtualEnvs" -ForegroundColor Cyan
        return
    }
    
    $pythonVersion = & python --version 2>&1
    Write-Host "🐍 Using: $pythonVersion" -ForegroundColor Green
    
    $categories = @("personal", "academic", "consulting", "ventures", "sandbox", "dbt_projects", "portfolio")
    
    foreach ($category in $categories) {
        $venvPath = Join-Path -Path $toolsPath -ChildPath "Python-Envs\$category\default"
        
        if (-not (Test-Path $venvPath)) {
            try {
                Write-Host "🔄 Creating virtual environment for $category..." -ForegroundColor Yellow
                & python -m venv $venvPath
                Write-Host "✅ Created virtual environment: $category\default" -ForegroundColor Green
                
                # Activate and install common packages
                $activateScript = Join-Path -Path $venvPath -ChildPath "Scripts\Activate.ps1"
                if (Test-Path $activateScript) {
                    . $activateScript
                    python -m pip install --upgrade pip setuptools wheel
                    
                    # Install category-specific packages
                    switch ($category) {
                        "dbt_projects" { 
                            pip install dbt-core dbt-snowflake dbt-postgres
                            Write-Host "  📊 Installed DBT packages" -ForegroundColor Green
                        }
                        "ventures" { 
                            pip install fastapi uvicorn pytest black flake8 python-dotenv
                            Write-Host "  🚀 Installed business development packages" -ForegroundColor Green
                        }
                        "portfolio" { 
                            pip install flask streamlit jupyter notebook plotly dash
                            Write-Host "  🎨 Installed portfolio/showcase packages" -ForegroundColor Green
                        }
                        "sandbox" { 
                            pip install requests beautifulsoup4 pandas matplotlib seaborn
                            Write-Host "  🧪 Installed experimentation packages" -ForegroundColor Green
                        }
                        "academic" {
                            pip install jupyter pandas numpy scipy matplotlib seaborn scikit-learn
                            Write-Host "  🎓 Installed academic/research packages" -ForegroundColor Green
                        }
                        default {
                            pip install requests python-dotenv
                            Write-Host "  📦 Basic packages installed" -ForegroundColor Green
                        }
                    }
                    deactivate
                }
            } catch {
                Write-Host "❌ Failed to create virtual environment for $category`: $($_.Exception.Message)" -ForegroundColor Red
            }
        } else {
            Write-Host "📁 Virtual environment already exists for $category" -ForegroundColor Yellow
        }
    }
}

# Function to install common development tools
function Install-CommonTools {
    Write-Host "`n🛠️ Installing common development tools..." -ForegroundColor Magenta
    
    # Check if winget is available
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $winget) {
        Write-Host "⚠️ winget not found. Please install App Installer from Microsoft Store." -ForegroundColor Yellow
        return
    }
    
    $tools = @(
        @{Name="Git"; Id="Git.Git"},
        @{Name="Visual Studio Code"; Id="Microsoft.VisualStudioCode"},
        @{Name="Python 3.13"; Id="Python.Python.3.13"},
        @{Name="Node.js"; Id="OpenJS.NodeJS"},
        @{Name="PowerShell 7"; Id="Microsoft.PowerShell"},
        @{Name="Windows Terminal"; Id="Microsoft.WindowsTerminal"}
    )
    
    foreach ($tool in $tools) {
        Write-Host "🔄 Installing $($tool.Name)..." -ForegroundColor Yellow
        try {
            winget install --id $tool.Id --accept-package-agreements --accept-source-agreements
            Write-Host "✅ $($tool.Name) installed successfully" -ForegroundColor Green
        } catch {
            Write-Host "⚠️ Failed to install $($tool.Name) - may already be installed" -ForegroundColor Yellow
        }
    }
}

# Function to setup configuration files
function Setup-ConfigurationFiles {
    Write-Host "`n⚙️ Setting up configuration files..." -ForegroundColor Magenta
    
    # Environment variables setup script
    $envConfigPath = Join-Path -Path $basePath -ChildPath "env-setup.ps1"
    $envConfig = @"
# Development Environment Variables Setup
# Run this script to configure your development environment

Write-Host "🔧 Configuring development environment..." -ForegroundColor Cyan

# Development Paths
`$env:DEV_HOME = "$basePath"
`$env:TOOLS_HOME = "$toolsPath"
`$env:CACHE_HOME = "$cachePath"
`$env:KEYS_HOME = "$keysPath"

# Python Configuration
`$env:PIP_CACHE_DIR = "$cachePath\pip"
`$env:POETRY_CACHE_DIR = "$cachePath\poetry"
`$env:PYTHONDONTWRITEBYTECODE = "1"

# Node.js Configuration
npm config set cache "$cachePath\npm" --global

# Git Configuration
git config --global init.defaultBranch main
git config --global core.autocrlf true
git config --global pull.rebase false

# Flutter Configuration (if Flutter SDK exists)
if (Test-Path "$toolsPath\Flutter-SDK") {
    `$env:FLUTTER_HOME = "$toolsPath\Flutter-SDK"
    `$env:PATH += ";$toolsPath\Flutter-SDK\bin"
    Write-Host "✅ Flutter environment configured" -ForegroundColor Green
}

# DBT Configuration
`$env:DBT_PROFILES_DIR = "$dbtPath\profiles"

# Docker Configuration (if Docker exists)
if (Get-Command docker -ErrorAction SilentlyContinue) {
    `$env:DOCKER_BUILDKIT = "1"
    Write-Host "✅ Docker environment configured" -ForegroundColor Green
}

Write-Host "✅ Development environment variables configured" -ForegroundColor Green
Write-Host "💡 Restart your terminal or IDE to use new environment variables" -ForegroundColor Yellow
"@
    Set-Content -Path $envConfigPath -Value $envConfig
    Write-Host "📝 Created environment setup script: $envConfigPath" -ForegroundColor Green
    
    # Create project organization guide
    $projectGuideContent = @"
# 📁 Development Environment Guide

## 🎯 Directory Structure & Purpose

### 📂 Core Development Directories

#### 🧪 sandbox/
**Purpose**: Experiments, learning, throwaway code
- Use for: Tutorials, API tests, proof-of-concepts, "what if" experiments
- Commitment: None - delete freely
- Examples: Framework comparisons, library testing, course exercises

#### 📂 personal/
**Purpose**: Hobby projects, utilities (no commercial intent)
- Use for: Personal tools, family projects, automation scripts
- Commitment: Low to medium
- Examples: Photo organizer, budget tracker, home automation

#### 🎓 academic/
**Purpose**: School assignments, research projects
- Use for: Course work, thesis projects, academic collaborations
- Commitment: Medium (tied to deadlines)
- Examples: Research analysis, course assignments, academic papers

#### 💼 consulting/
**Purpose**: Client work, professional services
- Use for: Contracted projects, freelance work, professional services
- Commitment: High (professional obligations)
- Examples: Client websites, custom software, data analysis services

#### 🚀 ventures/
**Purpose**: Business projects with growth/revenue potential
- Use for: Startup ideas, SaaS applications, products for market
- Commitment: High (potential commercialization)
- Examples: Mobile apps for sale, web services, business software

#### 📊 dbt_projects/
**Purpose**: Data transformation, analytics engineering
- Use for: Data pipelines, business intelligence, data warehousing
- Commitment: Medium to high (often production systems)
- Examples: ETL processes, data models, analytics dashboards

#### 🎨 portfolio/
**Purpose**: Showcase work for career advancement
- Use for: Demo applications, open source contributions, presentations
- Commitment: High (represents professional capabilities)
- Examples: GitHub showcases, technical demos, public projects

#### 📦 archive/
**Purpose**: Completed or obsolete projects
- Use for: Projects no longer actively developed
- Commitment: None (historical reference)
- Examples: Finished projects, old versions, deprecated work

## 🔄 Project Lifecycle & Decision Flow

### 💡 New Project Decision Tree
```
New Project Idea
├── Just experimenting/learning? → sandbox/
├── For school/research? → academic/
├── For a client? → consulting/
├── Personal hobby/utility? → personal/
├── Business/revenue potential? → ventures/
├── Career showcase? → portfolio/
├── Data transformation? → dbt_projects/
└── Completed project? → archive/
```

### 🎓 Project Graduation Path
1. **Idea** → Start in `sandbox/` for quick validation
2. **Prototype** → If promising, graduate to appropriate category
3. **Development** → Build with proper practices in target category
4. **Completion** → Keep active or move to `archive/`

### 🧹 Maintenance Schedule
- **Daily**: Use `sandbox/` freely for experiments
- **Weekly**: Clean `sandbox/`, graduate worthy projects  
- **Monthly**: Review all categories, organize and document
- **Quarterly**: Archive completed work, backup important projects

## 🛠️ Tools & Environment

### 🐍 Python Virtual Environments
Each category has dedicated virtual environments in `$toolsPath\Python-Envs\`:
- Isolated dependencies per project category
- Category-specific package installations
- Easy environment switching

### 💾 Cache Management
Centralized cache directories in `$cachePath\`:
- Faster builds and installations
- Easy cleanup and maintenance
- Consistent across all projects

### 🔐 Security & Keys
Organized key management in `$keysPath\`:
- Separated by service type and environment
- Proper access controls and gitignore
- Documentation and inventory tracking

## 🚀 Getting Started

### 🔧 Initial Setup
1. Run `env-setup.ps1` to configure environment variables
2. Create your first project in the appropriate category
3. Set up virtual environment for your project category
4. Configure your IDE to use the new directory structure

### 💻 IDE Configuration
- **PyCharm**: Update default project location to `$basePath`
- **VS Code**: Add workspace folders for each category
- **Git**: Configure global settings for consistent commits

### 📋 Best Practices
- Start experiments in `sandbox/`, graduate successful ones
- Use meaningful project names and documentation
- Maintain virtual environments per category
- Regular cleanup and archiving of old projects
- Backup important work, especially `ventures/` and `consulting/`

---
🏠 Environment Root: $basePath
📅 Created: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
🖥️ Machine: $env:COMPUTERNAME
👤 User: $env:USERNAME
"@
    
    $projectGuidePath = Join-Path -Path $basePath -ChildPath "README.md"
    Set-Content -Path $projectGuidePath -Value $projectGuideContent
    Write-Host "📋 Created development environment guide: $projectGuidePath" -ForegroundColor Green

    # Create useful PowerShell functions
    $functionsPath = Join-Path -Path $basePath -ChildPath "dev-functions.ps1"
    $functionsContent = @"
# Development Environment Helper Functions
# Source this file: . .\dev-functions.ps1

# Quick navigation functions
function dev { Set-Location "$basePath" }
function sandbox { Set-Location "$basePath\sandbox" }
function ventures { Set-Location "$basePath\ventures" }
function personal { Set-Location "$basePath\personal" }
function consulting { Set-Location "$basePath\consulting" }
function portfolio { Set-Location "$basePath\portfolio" }

# Project management functions
function New-SandboxProject {
    param([string]`$ProjectName)
    `$projectPath = "$basePath\sandbox\`$ProjectName"
    New-Item -ItemType Directory -Path `$projectPath -Force
    Set-Location `$projectPath
    Write-Host "🧪 Created sandbox project: `$ProjectName" -ForegroundColor Green
}

function Graduate-Project {
    param(
        [string]`$ProjectName,
        [string]`$FromCategory,
        [string]`$ToCategory
    )
    `$sourcePath = "$basePath\`$FromCategory\`$ProjectName"
    `$destPath = "$basePath\`$ToCategory\`$ProjectName"
    
    if (Test-Path `$sourcePath) {
        Move-Item -Path `$sourcePath -Destination `$destPath
        Write-Host "🎓 Graduated `$ProjectName from `$FromCategory to `$ToCategory" -ForegroundColor Green
    } else {
        Write-Host "❌ Project not found: `$sourcePath" -ForegroundColor Red
    }
}

function Show-DevSummary {
    Write-Host "`n📊 Development Environment Summary" -ForegroundColor Cyan
    Write-Host "🏠 Base Path: $basePath" -ForegroundColor White
    
    `$categories = @("sandbox", "personal", "academic", "consulting", "ventures", "portfolio", "dbt_projects")
    foreach (`$category in `$categories) {
        `$categoryPath = "$basePath\`$category"
        if (Test-Path `$categoryPath) {
            `$projectCount = (Get-ChildItem -Path `$categoryPath -Directory).Count
            Write-Host "📁 `$category`: `$projectCount projects" -ForegroundColor Yellow
        }
    }
}

# Virtual environment helpers
function Activate-Venv {
    param([string]`$Category = "sandbox")
    `$venvPath = "$toolsPath\Python-Envs\`$Category\default\Scripts\Activate.ps1"
    if (Test-Path `$venvPath) {
        & `$venvPath
        Write-Host "🐍 Activated virtual environment: `$Category" -ForegroundColor Green
    } else {
        Write-Host "❌ Virtual environment not found for: `$Category" -ForegroundColor Red
    }
}

Write-Host "✅ Development functions loaded!" -ForegroundColor Green
Write-Host "💡 Try: dev, sandbox, ventures, New-SandboxProject, Show-DevSummary" -ForegroundColor Cyan
"@
    Set-Content -Path $functionsPath -Value $functionsContent
    Write-Host "⚡ Created helper functions: $functionsPath" -ForegroundColor Green
}

# Main execution starts here
Write-Host "`n📁 Creating development directories..." -ForegroundColor Magenta
Create-Directory -basePath $basePath -folders $devFolders -category "Development"

Write-Host "`n🔧 Creating tools directories..." -ForegroundColor Magenta  
Create-Directory -basePath $toolsPath -folders $toolsFolders -category "Tools"

Write-Host "`n💾 Creating cache directories..." -ForegroundColor Magenta
Create-Directory -basePath $cachePath -folders $cacheFolders -category "Cache"

Write-Host "`n🔑 Creating keys directories..." -ForegroundColor Magenta
Create-Directory -basePath $keysPath -folders $keysFolders -category "Keys"

Write-Host "`n🔧 Creating dbt directories..." -ForegroundColor Magenta
Create-Directory -basePath $dbtPath -folders $dbtFolders -category "DBT"

# Optional features
if ($CreateVirtualEnvs) {
    Create-VirtualEnvironments
}

if ($InstallCommonTools) {
    Install-CommonTools
}

# Setup configuration files
Setup-ConfigurationFiles

# Create comprehensive .gitignore for keys
$gitignorePath = "$keysPath\.gitignore"
$gitignoreContent = @"
# 🛡️ Security: Ignore all keys and certificates
*

# Allow documentation and configuration
!.gitignore
!README.md
!*.template
!*.example
!*.md

# Allow directory structure documentation
!**/README.md
"@
Set-Content -Path $gitignorePath -Value $gitignoreContent
Write-Host "🛡️ Created comprehensive .gitignore for keys" -ForegroundColor Green

# Set secure permissions for keys directory
try {
    Write-Host "`n🔒 Setting secure permissions on keys directory..." -ForegroundColor Magenta
    icacls $keysPath /inheritance:r 2>$null
    icacls $keysPath /grant:r "${env:USERNAME}:(OI)(CI)F" 2>$null
    Write-Host "✅ Permissions set successfully" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Could not set permissions. Run as administrator for secure permissions." -ForegroundColor Yellow
}

# Final summary
Write-Host @"

🎉 Portable Development Environment Created!
===========================================

📍 Environment Details:
   🏠 Base Path: $basePath
   🔧 Tools: $toolsPath  
   💾 Cache: $cachePath
   🔑 Keys: $keysPath
   📊 DBT: $dbtPath
   
   Setup Type: $(if ($Minimal) { "Minimal" } else { "Full" })
   Virtual Envs: $(if ($CreateVirtualEnvs) { "Created" } else { "Skipped" })
   Common Tools: $(if ($InstallCommonTools) { "Installed" } else { "Skipped" })

🚀 Next Steps:
   1. Run: $basePath\env-setup.ps1 (configure environment variables)
   2. Read: $basePath\README.md (comprehensive guide)
   3. Load: . $basePath\dev-functions.ps1 (helper functions)
   4. Start: Create your first project in the appropriate category!

💡 Quick Start Commands:
   - New experiment: New-SandboxProject "my-test"
   - Navigate: dev, sandbox, ventures, personal
   - Summary: Show-DevSummary
   - Environment: Activate-Venv sandbox

📚 Documentation Created:
   - Environment Guide: $basePath\README.md
   - Helper Functions: $basePath\dev-functions.ps1
   - Environment Setup: $basePath\env-setup.ps1

🔄 Reusable Setup:
   This script can be used on any new machine to recreate your development environment!
   
"@ -ForegroundColor Green

Write-Host "🌟 Your standardized development environment is ready!" -ForegroundColor Cyan
