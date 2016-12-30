$programFiles = $Env:PROGRAMFILES
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$programFiles = $programFiles -replace ' ', '`%20'
$PSScriptRoot = $programFiles -replace ' ', '`%20'

\salt\salt-call.bat --config-dir='.\windows-salt\conf' -l all $args pillar="{PROGRAM_FILES: '$programFiles', LAMINAR_DIR: '$PSScriptRoot' }"
