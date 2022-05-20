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

# Set useful alias
Set-Alias vim nvim
Set-Alias cm chezmoi
# Remove powershell default alias to enable to run R by tying 'r'
Remove-Item Alias:\\r
# Helper to quick jump to chezmoi source dir
${function:cm-cd} = { Set-Location $HOME\.local\share\chezmoi }

# Invoke starship
Invoke-Expression (&starship init powershell)

Import-Module -Name PSReadLine
Import-Module -Name Terminal-Icons
Import-Module -Name scoop-completion

Set-PSReadLineOption -Colors @{ InlinePrediction = '#000055'}
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -EditMode Windows
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -chord Ctrl+o -function ViForwardChar
Set-PSReadlineKeyHandler -key Ctrl+d -function ViExit
Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord DownArrow -Function HistorySearchForward
