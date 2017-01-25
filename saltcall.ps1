<# 
.SYNOPSIS 
	
	Invokes salt calling the salt-call command passing the arguments passed to this script.

.DESCRIPTION 
	Convenience wrapper arounc the salt verb - salt-call that passes pillar values for:
		- PROGRAM_FILES
		- LAMINAR_DIR
		- HOME_PATH
		- VBOX_DIR
	
	For details on SaltStack's salt-call, see: https://docs.saltstack.com/en/latest/ref/cli/salt-call.html

.EXAMPLE
	cd <Laminar root directory>  - e.g. cd c:\Laminar
	.\saltcall.ps1 state.apply vagrant

	 Will invoke the vagrant.sls file in the windows-salt directory

.NOTES
	The minion configuration path is set during salt-call invocation.
	If an argument beginning with "pillar" is passed in, that argument overrides the wrapper pillar values.

	Author     : Tim Rochford - trochford-gh@gmail.com
.LINK 
	http://github.com/trochford/Laminar
#>


# Assume there is no pillar override in #args and prove wrong
$pillarOveride = $False

$logLevel = "info" # Convenient spot to switch log levels

foreach ($i in $args)
    { 
      If ($i.StartsWith("pillar")) { $pillarOverride = $True } 
      If ($i.StartsWith("quiet")) { $logLevel = "error" } 
    }

$PSScriptRootNSE = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition 
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition 
# Invoke-Expression requires escaping of embedded quotes

# Dispatch the sub-command
switch ($args[0]) {
  "--help" { & get-help $PSScriptRoot\saltcall.ps1 }
  "help"   { & get-help $PSScriptRoot\saltcall.ps1 }
  ""       { & get-help $PSScriptRoot\saltcall.ps1 }
  default  { 
		$programFiles = $Env:PROGRAMFILES
		$homePath     = $Env:HOMEDRIVE+$Env:HOMEPATH
		$vboxDir      = $Env:VBOX_MSI_INSTALL_PATH
                if ( -not $vboxDir ) { # not installed, set to VB install default
                   $vboxDir = "C:\Program Files\Oracle\VirtualBox" 
                } else {
                   $vboxDir = $vboxDir.TrimEnd( '/' ).TrimEnd( '\' )
                }
		
		# Adjust the slashes of these 4 directory references for salt compatible syntax
		$saltPSScriptRoot    = $PSScriptRoot.Replace('\','/')
		$saltProgramFiles    = $programFiles.Replace('\','/')
		$saltHomePath        = $homePath.Replace('\','/')
		$saltVboxDir         = $vboxDir.Replace('\','/')

		if ( $pillarOverride ) {
			echo \salt\salt-call.bat --config-dir="$PSScriptRoot\windows-salt\conf" -l $logLevel $args 
			\salt\salt-call.bat --config-dir="$PSScriptRoot\windows-salt\conf" -l $logLevel $args 
		} else {
			echo \salt\salt-call.bat --config-dir="$PSScriptRoot\windows-salt\conf" -l $logLevel $args `
			   pillar="{PROGRAM_FILES: '$saltProgramFiles', LAMINAR_DIR: '$saltPSScriptRoot', HOME_PATH: '$saltHomePath', VBOX_DIR: '$saltVboxDir' }" 
			\salt\salt-call.bat --config-dir="$PSScriptRoot\windows-salt\conf" -l $logLevel $args `
			   pillar="{PROGRAM_FILES: '$saltProgramFiles', LAMINAR_DIR: '$saltPSScriptRoot', HOME_PATH: '$saltHomePath', VBOX_DIR: '$saltVboxDir' }" 
		}
            }
}
