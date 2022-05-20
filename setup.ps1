# Set a permanent Environment variable, and reload it into $env
function Set-EnvironmentVariable([String] $variable, [String] $value) {
    Set-ItemProperty "HKCU:\Environment" $variable $value
    # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
    #[System.Environment]::SetEnvironmentVariable("$variable", "$value","User")
    Invoke-Expression "`$env:${variable} = `"$value`""
}

# Make neovim the default editor
Set-EnvironmentVariable "EDITOR" "nvim"
Set-EnvironmentVariable "GIT_EDITOR" $Env:EDITOR

# Set komorebi config home
Set-EnvironmentVariable "KOMOREBI_CONFIG_HOME" "$Env:UserProfile\.config\komorebi"
