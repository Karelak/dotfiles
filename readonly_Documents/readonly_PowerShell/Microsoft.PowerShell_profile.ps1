$_lcFlags = [System.Reflection.BindingFlags]"Instance, NonPublic"
$_lcContext = $ExecutionContext.GetType().GetField("_context", $_lcFlags).GetValue($ExecutionContext)
$_lcNative = $_lcContext.GetType().GetProperty("NativeArgumentCompleters", $_lcFlags)
$_lcCustom = $_lcContext.GetType().GetProperty("CustomArgumentCompleters", $_lcFlags)
$_lcCache = Join-Path (Split-Path $PROFILE) "Completions"

function Get-CompleterVersion ([string]$CommandName) {
  $cmd = Get-Command $CommandName -ErrorAction SilentlyContinue
  if (-not $cmd) { return "unknown" }
  if ($cmd.Version) { return $cmd.Version.ToString() }
  $path = $cmd.Source
  if ($path -and (Test-Path $path)) {
    return (Get-FileHash $path -Algorithm MD5).Hash.Substring(0, 8)
  }
  return "unknown"
}

function Register-LazyCompleter {
  param(
    [string]$CommandName,

    # Type 1 — binary generates PS completion script
    [scriptblock]$Generator,

    # Type 2 — module registers completer on import
    [string]$ModuleName,

    # Type 3 — native (-Native) scriptblock completer
    [scriptblock]$NativeCompleter
  )

  $ctx = $_lcContext
  $native = $_lcNative
  $custom = $_lcCustom
  $cache = $_lcCache

  switch ($true) {

    { $PSBoundParameters.ContainsKey('Generator') } {
      Register-ArgumentCompleter -CommandName $CommandName -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)

        $version = Get-CompleterVersion $CommandName
        $cacheFile = Join-Path $cache "$CommandName-$version.ps1"

        Get-Item (Join-Path $cache "$CommandName-*.ps1") -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -ne $cacheFile } |
        Remove-Item -Force

        if (-not (Test-Path $cacheFile)) {
          New-Item -ItemType Directory -Force -Path $cache | Out-Null
          Set-Content -Path $cacheFile -Value (& $Generator) -Encoding UTF8
        }

        . $cacheFile

        $completer = $native.GetValue($ctx)[$CommandName]
        if ($completer) { return & $completer $wordToComplete $commandAst $cursorPosition }
      }.GetNewClosure()
      break
    }

    { $PSBoundParameters.ContainsKey('ModuleName') } {
      Register-ArgumentCompleter -CommandName $CommandName -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)

        Import-Module -Global $ModuleName -ErrorAction Stop

        $completer = $native.GetValue($ctx)[$CommandName]
        if ($completer) { return & $completer $wordToComplete $commandAst $cursorPosition }
      }.GetNewClosure()
      break
    }

    { $PSBoundParameters.ContainsKey('NativeCompleter') } {
      Register-ArgumentCompleter -Native -CommandName $CommandName -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)

        Register-ArgumentCompleter -Native -CommandName $CommandName -ScriptBlock $NativeCompleter

        $completer = $custom.GetValue($ctx)[$CommandName]
        if ($completer) { return & $completer $wordToComplete $commandAst $cursorPosition }
      }.GetNewClosure()
      break
    }

    default {
      throw "Register-LazyCompleter: specify -Generator, -ModuleName, or -NativeCompleter"
    }
  }
}


# Core shell behaviour
Import-Module PSReadLine
Import-Module PSFzf

# PSFzf configuration
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PsFzfOption -TabExpansion

# Completions
Register-LazyCompleter -CommandName scoop -ModuleName scoop-completion
Register-LazyCompleter -CommandName docker -ModuleName DockerCompletion
Register-LazyCompleter -CommandName choco -ModuleName "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
Register-LazyCompleter -CommandName tailscale -Generator { tailscale completion powershell | Out-String }
Register-LazyCompleter -CommandName chezmoi -Generator { chezmoi completion powershell | Out-String }
Register-LazyCompleter -CommandName uv -Generator { uv --generate-shell-completion powershell | Out-String }
Register-LazyCompleter -CommandName uvx -Generator { uvx --generate-shell-completion powershell | Out-String }
Register-LazyCompleter -CommandName gh -Generator { gh completion -s powershell | Out-String }
Register-LazyCompleter -CommandName rustup -Generator { rustup completions powershell | Out-String }
Register-LazyCompleter -CommandName surge -Generator { surge completion powershell | Out-String }
Register-LazyCompleter -CommandName rclone -Generator { rclone completion powershell | Out-String }

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
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord

