# Set a permanent Environment variable, and reload it into $env
function Set-EnvironmentVariable([String] $variable, [String] $value) {
    Set-ItemProperty "HKCU:\Environment" $variable $value
    # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
    #[System.Environment]::SetEnvironmentVariable("$variable", "$value","User")
    Invoke-Expression "`$env:${variable} = `"$value`""
}

# Set useful alias
if (Get-Command nvim -ErrorAction SilentlyContinue | Test-Path) {
    Set-Alias vim nvim
    # Make neovim the default editor
    Set-EnvironmentVariable "EDITOR" "nvim"
    Set-EnvironmentVariable "GIT_EDITOR" $Env:EDITOR
}

if (Get-Command chezmoi -ErrorAction SilentlyContinue | Test-Path) {
    Set-Alias cm chezmoi
    # Helper to quick jump to chezmoi source dir
    ${function:cm-cd} = { Set-Location $HOME\.local\share\chezmoi }
}

# Remove powershell default alias to enable to run R by tying 'r'
Remove-Alias \\r -Force -ErrorAction SilentlyContinue

# Invoke starship
if (Get-Command starship -ErrorAction SilentlyContinue | Test-Path) {
    Invoke-Expression (&starship init powershell)
}

if ((Get-Module -ListAvailable PSReadLine -ErrorAction SilentlyContinue) -ne $NULL) {
    Import-Module -Name PSReadLine
    Set-PSReadLineOption -Colors @{ InlinePrediction = '#000055'}
    Set-PSReadLineOption -EditMode Windows

    if ((Get-Module PSReadLine).Version -gt [System.Version]'7.1.0' -and (Get-Module PSReadLine).Version -gt [System.Version]'2.2.0') {
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    } else {
        Set-PSReadLineOption -PredictionSource History
    }

    Set-PSReadlineKeyHandler -Chord Ctrl+e -Function EndOfLine

    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    # Works in InlineView
    Set-PSReadlineKeyHandler -Chord Ctrl+l -Function AcceptNextSuggestionWord
    Set-PSReadLineKeyHandler -Chord Ctrl+k -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Chord Ctrl+j -Function HistorySearchForward
    # Works in ListView
    Set-PSReadlineKeyHandler -Chord Ctrl+p -Function PreviousSuggestion
    Set-PSReadlineKeyHandler -Chord Ctrl+n -Function NextSuggestion
}

if ((Get-Module -ListAvailable Terminal-Icons -ErrorAction SilentlyContinue) -ne $NULL) {
    Import-Module -Name Terminal-Icons
}

if ((Get-Module -ListAvailable scoop-completion -ErrorAction SilentlyContinue) -ne $NULL) {
    Import-Module -Name scoop-completion
}
