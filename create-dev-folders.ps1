# Define base path
$basePath = "$env:USERPROFILE\Dev"

# Simple folder list
$folders = @(
    "personal",
    "academic",
    "consulting",
    "sandbox"
)

# Create folders
foreach ($folder in $folders) {
    $fullPath = Join-Path -Path $basePath -ChildPath $folder
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath | Out-Null
        Write-Host "Created: $fullPath"
    } else {
        Write-Host "Already exists: $fullPath"
    }
}

Write-Host "`n✅ Clean folder structure created!"
