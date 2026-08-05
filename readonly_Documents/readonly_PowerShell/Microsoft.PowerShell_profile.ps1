
# Core shell behaviour
Import-Module PSReadLine
# Import-Module PSFzf

# PSFzf configuration
# $env:FZF_DEFAULT_OPTS = "--cycle"
# Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# Set-PsFzfOption -TabExpansion

# Completions
# Register-LazyCompleter -CommandName tailscale -Generator { tailscale completion powershell | Out-String }
# Register-LazyCompleter -CommandName chezmoi -Generator { chezmoi completion powershell | Out-String }
# Register-LazyCompleter -CommandName uv -Generator { uv --generate-shell-completion powershell | Out-String }
# Register-LazyCompleter -CommandName uvx -Generator { uvx --generate-shell-completion powershell | Out-String }
# Register-LazyCompleter -CommandName gh -Generator { gh completion -s powershell | Out-String }
# Register-LazyCompleter -CommandName rustup -Generator { rustup completions powershell | Out-String }
# Register-LazyCompleter -CommandName surge -Generator { surge completion powershell | Out-String }
# Register-LazyCompleter -CommandName rclone -Generator { rclone completion powershell | Out-String }
Import-Module ScoopCompletion
Import-Module DockerCompletion

# choco completions
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
# winget is a special case because it doesn't have a PS completion script, but it can output completions directly also is really fucking slow but what can you do
Register-LazyCompleter winget -NativeCompleter {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  $Local:word = $wordToComplete.Replace('"', '""')
  $Local:ast = $commandAst.ToString().Replace('"', '""')
  winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition |
  ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_) }
}

# fast scoop search
. ([ScriptBlock]::Create((& scoop-search --hook | Out-String)))

# Aliases
Set-Alias c clear -Scope Global -Force

# Prompt
Invoke-Expression (& oh-my-posh init pwsh --config "C:\Users\Kaarel\.config\oh-my-posh\zen.toml" | Out-String)

# PSReadLine preferences
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -Colors @{ InlinePrediction = '#865d5d' }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord
Set-PSReadLineOption -BellStyle None


