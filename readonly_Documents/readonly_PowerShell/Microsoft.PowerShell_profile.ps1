# # Repair PATH when the hosting process fails to include the user-level entries.
# $userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
# if ($userPath) {
#     $existingPaths = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
#     foreach ($pathEntry in ($env:Path -split ';')) {
#         if ($pathEntry) {
#             [void]$existingPaths.Add($pathEntry.TrimEnd('\'))
#         }
#     }

#     $missingPaths = foreach ($pathEntry in ($userPath -split ';')) {
#         if ($pathEntry -and -not $existingPaths.Contains($pathEntry.TrimEnd('\'))) {
#             $pathEntry
#         }
#     }

#     if ($missingPaths) {
#         $env:Path = ($env:Path.TrimEnd(';') + ';' + ($missingPaths -join ';'))
#     }
# }

# Module imports
Import-Module PSReadLine
Import-Module DockerCompletion

# Shell completions
Invoke-Expression (&chezmoi completion powershell | Out-String)
Invoke-Expression (&surge completion powershell | Out-String)
Invoke-Expression (& zoxide init powershell | Out-String)
Invoke-Expression (&gh completion -s powershell | Out-String)

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
Import-Module scoop-completion
. ([ScriptBlock]::Create((& scoop-search --hook | Out-String)))
# Aliases
Import-Module "C:\Program Files\WindowsPowerShell\Modules\gsudoModule"
Import-Module posh-git
Set-Alias 'sudo' 'gsudo'
Set-Alias 'c' 'clear'
# Prompt
Invoke-Expression (&oh-my-posh init pwsh --config "C:\Users\Kaarel\.config\oh-my-posh\zen.toml" | Out-String)
if (Get-Command tailscale -ErrorAction SilentlyContinue) {
    tailscale completion powershell | Out-String | Invoke-Expression
}

# PSReadLine options
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -Colors @{ InlinePrediction = '#875f5f' }

# PSReadLine key bindings
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord "Ctrl+RightArrow" -Function ForwardWord
