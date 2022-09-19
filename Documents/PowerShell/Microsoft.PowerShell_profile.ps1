# Import utilies
. $PSScriptRoot\utils.ps1

# Set useful alias
if (Get-Command nvim -ErrorAction SilentlyContinue | Test-Path) {
    Set-Alias vim nvim
}

if (Get-Command chezmoi -ErrorAction SilentlyContinue | Test-Path) {
    Set-Alias cm chezmoi
    # Helper to quick jump to chezmoi source dir
    ${function:cm-cd} = { Set-Location $HOME\.local\share\chezmoi }
}

if (Get-Command lazygit -ErrorAction SilentlyContinue | Test-Path) {
    Set-Alias lg lazygit
}

# Remove powershell default alias to enable to run R by tying 'r'
# Note: Remove-Alias only works on PowerShell v6
Remove-Item Alias:r -ErrorAction SilentlyContinue

# Invoke starship
if (Get-Command starship -ErrorAction SilentlyContinue | Test-Path) {
    # Currently, starship did not support XDG standard
    Set-EnvironmentVariable "STARSHIP_CONFIG" "$HOME\.config\starship\config.toml"
    Invoke-Expression (&starship init powershell)
}

if ($null -ne (Get-Module -ListAvailable PSReadLine -ErrorAction SilentlyContinue)) {
    Import-Module -Name PSReadLine
    Set-PSReadLineOption -Colors @{ InlinePrediction = '#000055'}
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd

    if ((Get-Host).Version -gt [System.Version]'7.1.0' -and
        (Get-Module PSReadLine).Version -gt [System.Version]'2.2.0') {
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin

        # Works in ListView
        Set-PSReadlineKeyHandler -Chord Ctrl+p -Function PreviousSuggestion
        Set-PSReadlineKeyHandler -Chord Ctrl+n -Function NextSuggestion
    } else {
        Set-PSReadLineOption -PredictionSource History
    }

    Set-PSReadlineKeyHandler -Chord Ctrl+e -Function EndOfLine

    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    # Works in InlineView
    Set-PSReadlineKeyHandler -Chord Ctrl+l -Function AcceptNextSuggestionWord
    Set-PSReadLineKeyHandler -Chord Ctrl+p -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Chord Ctrl+n -Function HistorySearchForward

    Set-PSReadLineKeyHandler -Key Ctrl+Backspace -Function ShellBackwardKillWord
    Set-PSReadLineKeyHandler -Key Ctrl+b -Function ShellBackwardWord
    Set-PSReadLineKeyHandler -Key Ctrl+f -Function ShellForwardWord
}

if ($null -ne (Get-Module -ListAvailable Terminal-Icons -ErrorAction SilentlyContinue)) {
    Import-Module -Name Terminal-Icons
}

if ($null -ne (Get-Module -ListAvailable scoop-completion -ErrorAction SilentlyContinue)) {
    Import-Module -Name scoop-completion
}
