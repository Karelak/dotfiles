Import-Module PSReadLine

# PSReadLine preferences
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -Colors @{ InlinePrediction = '#865d5d' }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord
Set-PSReadLineOption -BellStyle None


# fast scoop search
. ([ScriptBlock]::Create((& scoop-search --hook | Out-String)))

# Aliases
Set-Alias c clear -Scope Global -Force

# Prompt
# Invoke-Expression (& oh-my-posh init pwsh --config "C:\Users\Kaarel\.config\oh-my-posh\zen.toml" | Out-String)
function Invoke-Starship-TransientFunction {
  &starship module character
}

Invoke-Expression (&starship init powershell)

Enable-TransientPrompt