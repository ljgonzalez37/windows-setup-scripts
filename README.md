# Development Environment Setup

A comprehensive PowerShell script to create an organized, domain-based development environment for solutions architects working with modern data and software development stacks.

## 🎯 Overview

This script creates a professional development environment organized by **business domains** rather than tools, making it easier to manage projects across different contexts while supporting flexible technology stacks.

## 🏗️ Directory Structure

```
D:\Dev\  (or C:\Users\[Username]\Dev\)
├── Academia\              # 🎓 Academic & research projects
│   ├── Projects\          # Research development projects
│   ├── SharedData\        # Research datasets used across projects
│   └── Resources\         # Academic references, documentation
├── Consulting\            # 💼 Client work
│   ├── Projects\          # Client development projects
│   ├── Proposals\         # SOWs, contracts, quotes
│   └── Deliverables\      # Reports, presentations
├── Ventures\              # 🚀 Your business projects
│   ├── Projects\          # Business development projects
│   ├── SharedData\        # Business data used across projects
│   └── Ideas\             # Business concepts, notes
├── Learning\              # 📚 Personal training & hands-on labs
│   ├── Projects\          # Learning lab projects
│   └── Resources\         # Course materials, documentation
└── Settings\              # ⚙️ Shared infrastructure
    ├── Tools\             # Scripts, utilities, configs
    ├── Cache\             # Build caches (pip, gradle, etc.)
    ├── Secure\            # All credentials & keys
    │   ├── SSH\           # SSH keys and configurations
    │   ├── Cloud\         # AWS, Azure, GCP credentials
    │   ├── Database\      # Database connection strings
    │   └── API\           # API keys and tokens
    └── DBT\               # Global dbt profiles and configurations
        ├── profiles\      # Global profiles.yml (Snowflake connections)
        ├── logs\          # Global dbt logs
        └── target\        # Global compiled files
```

## 🚀 Quick Start

### Prerequisites
- **PowerShell 5.1+** 
- **Python 3.7+** (for virtual environments)
- **Git** (for version control)
- **Appropriate execution policy**: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

### Installation

1. **Download the script**:
   ```powershell
   # Save as create-dev-folders.ps1
   ```

2. **Run the setup**:
   ```powershell
   # For D: drive setup
   .\create-dev-folders.ps1 -TargetDrive D
   
   # For C: drive setup (default)
   .\create-dev-folders.ps1
   
   # Minimal setup (no virtual environments)
   .\create-dev-folders.ps1 -Minimal
   ```

3. **Load the helper functions**:
   ```powershell
   . .\Settings\Tools\dev-functions.ps1
   ```

4. **Configure environment variables**:
   ```powershell
   .\Settings\Tools\env-setup.ps1
   ```

## 🎯 Supported Technology Stack

This environment is optimized for solutions architects working with:

- **Data Engineering**: dbt, Python, Snowflake, SQL
- **Software Development**: Visual Studio, Python, Node.js
- **Mobile Development**: Android Studio, Flutter
- **DevOps**: Docker, Kubernetes, CI/CD
- **Cloud Platforms**: AWS, Azure, GCP
- **Version Control**: Git with proper branch management

## 📁 Domain Organization

### 🎓 Academia
For research, academic projects, and educational work.
- **Use Case**: Thesis projects, research papers, academic collaborations
- **Tools**: Python, R, dbt, Jupyter, LaTeX, statistical software
- **Example**: `Academia\Projects\GeneticVariationAnalysis\`

### 💼 Consulting
Professional client work with deliverables and proposals.
- **Use Case**: Client projects, consulting deliverables, professional services
- **Tools**: Whatever the client requires (full flexibility)
- **Example**: `Consulting\Projects\ClientABC_DataPipeline\`

### 🚀 Ventures
Your business projects and entrepreneurial work.
- **Use Case**: Startup ideas
