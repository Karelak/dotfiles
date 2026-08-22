Import-Module PSReadLine
Import-Module PSFzf
# PSReadLine preferences
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -Colors @{ InlinePrediction = '#865d5d' }
Set-PSReadlineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord
Set-PSReadLineOption -BellStyle None

# PSFzf preferences
Set-PsFzfOption -TabExpansion

# fast scoop search
. ([ScriptBlock]::Create((& scoop-search --hook | Out-String)))

# Editor
$env:MICRO_TRUECOLOR = "1"


# Aliases
Set-Alias c clear -Scope Global -Force

Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
