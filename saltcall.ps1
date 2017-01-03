<# 
.SYNOPSIS 
	
	Invokes salt calling the salt-call command passing the arguments passed to this script.

.DESCRIPTION 
	Convenience wrapper arounc the salt verb - salt-call that passes pillar values for:
		- PROGRAM_FILES
		- LAMINAR_DIR
	
	For details on SaltStack's salt-call, see: https://docs.saltstack.com/en/latest/ref/cli/salt-call.html

.EXAMPLE
	cd <Laminar root directory>  - e.g. cd c:\Laminar
	.\saltcall.ps1 state.apply vagrant

	 Will invoke the vagrant.sls file in the windows-salt directory

.NOTES
	Author     : Tim Rochford - trochford-gh@gmail.com
.LINK 
	http://github.com/trochford/Laminar
#>

#Param (
#  [String]$args_to_pass_to_salt
#) 

# Dispatch the sub-command
switch ($args[0]) {
  "--help" { & get-help .\saltcall.ps1 }
  "help"   { & get-help .\saltcall.ps1 }
  ""       { & get-help .\saltcall.ps1 }
  default  { 
		$programFiles = $Env:PROGRAMFILES
		$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
		$programFiles = $programFiles -replace ' ', '`%20'
		$PSScriptRoot = $PSScriptRoot -replace ' ', '`%20'

		\salt\salt-call.bat --config-dir='.\windows-salt\conf' -l info $args pillar="{PROGRAM_FILES: '$programFiles', LAMINAR_DIR: '$PSScriptRoot' }"
            }
}