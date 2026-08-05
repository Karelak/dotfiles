Import-Module PSReadLine

# Completions
Import-Module scoop-completion
Import-Module DockerCompletion
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

# Generated completions
tailscale completion powershell | Out-String | Invoke-Expression
chezmoi completion powershell | Out-String | Invoke-Expression
uv --generate-shell-completion powershell | Out-String | Invoke-Expression
uvx --generate-shell-completion powershell | Out-String | Invoke-Expression
gh completion -s powershell | Out-String | Invoke-Expression
rustup completions powershell | Out-String | Invoke-Expression
surge completion powershell | Out-String | Invoke-Expression
rclone completion powershell | Out-String | Invoke-Expression

# winget
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)

  [Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

  winget complete `
    --word="$($wordToComplete.Replace('"', '""'))" `
    --commandline "$($commandAst.ToString().Replace('"', '""'))" `
    --position $cursorPosition |
  ForEach-Object {
    [System.Management.Automation.CompletionResult]::new(
      $_, $_, 'ParameterValue', $_
    )
  }
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


