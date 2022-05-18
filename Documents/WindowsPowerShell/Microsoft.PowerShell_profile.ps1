# Set a permanent Environment variable, and reload it into $env
function Set-Environment([String] $variable, [String] $value) {
    Set-ItemProperty "HKCU:\Environment" $variable $value
    # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
    #[System.Environment]::SetEnvironmentVariable("$variable", "$value","User")
    Invoke-Expression "`$env:${variable} = `"$value`""
}

# Make vim the default editor
Set-Environment "EDITOR" "nvim"
Set-Environment "GIT_EDITOR" $Env:EDITOR

Set-Alias vim nvimi
${function:chezmoi-cd} = { Set-Location $HOME\.local\share\chezmoi }

Invoke-Expression (&starship init powershell)

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
if ($host.Name -eq 'ConsoleHost')
{
    Set-PSReadLineOption -Colors @{ InlinePrediction = '#000055'}
    Set-PSReadLineKeyHandler -chord Ctrl+o -function ViForwardChar
    Set-PSReadlineKeyHandler -key Ctrl+d -function ViExit
    Import-Module PSReadLine
    Import-Module -Name Terminal-Icons
}

Remove-Item Alias:\\r
