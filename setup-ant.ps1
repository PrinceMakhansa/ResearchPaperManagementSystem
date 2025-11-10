# Apache Ant Setup Script
# Run this script as Administrator to set up Apache Ant permanently

Write-Host "Setting up Apache Ant environment variables..." -ForegroundColor Green

# Set ANT_HOME
$antHome = "C:\tools\apache-ant-1.10.14"
[Environment]::SetEnvironmentVariable("ANT_HOME", $antHome, [EnvironmentVariableTarget]::Machine)

# Add Ant to PATH
$currentPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine)
$antBinPath = "$antHome\bin"

if ($currentPath -notlike "*$antBinPath*") {
    $newPath = "$currentPath;$antBinPath"
    [Environment]::SetEnvironmentVariable("PATH", $newPath, [EnvironmentVariableTarget]::Machine)
    Write-Host "Added Ant to PATH" -ForegroundColor Yellow
} else {
    Write-Host "Ant is already in PATH" -ForegroundColor Yellow
}

Write-Host "Apache Ant setup complete!" -ForegroundColor Green
Write-Host "Please restart your terminal/IDE for changes to take effect." -ForegroundColor Cyan
Write-Host "Test with: ant -version" -ForegroundColor Cyan
