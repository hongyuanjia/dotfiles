# Set a permanent Environment variable, and reload it into $env
function Set-EnvironmentVariable([String] $variable, [String] $value) {
    Set-ItemProperty "HKCU:\Environment" $variable $value
    # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
    #[System.Environment]::SetEnvironmentVariable("$variable", "$value","User")
    Invoke-Expression "`$Env:${variable} = `"$value`""
}

# Make neovim the default editor
Set-EnvironmentVariable "EDITOR" "nvim"
Set-EnvironmentVariable "GIT_EDITOR" $Env:EDITOR

# Set komorebi config home
Set-EnvironmentVariable "KOMOREBI_CONFIG_HOME" "$Env:UserProfile\.config\komorebi"

# Install scoop
if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue | Test-Path)) {
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
}
# Restore scoop buckets and install apps
. $PSScriptRoot\Documents\PowerShell\utils.ps1
Import-ScoopData $PSScriptRoot\scoop.json

# Install chocolatey in a separate powershell
if (-not (Get-Command "choco" -ErrorAction SilentlyContinue | Test-Path)) {
    Start-Process powershell -Wait -Verb runAs -ArgumentList @(
        "Set-ExecutionPolicy Bypass -Scope Process -Force;",
        "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;",
        "Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));"
    )
}
Start-Process powershell -Wait -Verb runAs -ArgumentList @("choco install -y $((Get-ChildItem . -Filter choco.config).FullName)")
