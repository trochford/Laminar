<# 
.SYNOPSIS 
	Set the private Docker "registry" IP address into myReg environment variable
.DESCRIPTION 
	Calls "docker-machine ip registory".  Sets myReg in the User namespace
.EXAMPLE
	cd <Laminar root directory>\windows-salt  - e.g. cd c:\Laminar\windows-salt
	.\saveRegIPInEnvVar.ps1

.NOTES
	Uses [Environment]::SetEnvironmentVarialble.  Other approaches do not
	reliably allow for getting the value in the same Powershell session.
        The registry port is 86.
	
	Author     : Tim Rochford - trochford-gh@gmail.com
.LINK 
	http://github.com/trochford/Laminar
#>
 
##
# Update the process path to be the combination of the User and Machine paths
# in order to pickup any new installations not reflected in this process
$userPaths       = [Environment]::GetEnvironmentVariable('Path', 'User') -split ';'
$machinePaths    = [Environment]::GetEnvironmentVariable('Path', 'Machine') -split ';'
$newProcessPaths = $userPaths + $machinePaths
[Environment]::SetEnvironmentVariable('Path', $newProcessPaths -join ';', 'Process')

# Passing the path to the Laminar directory as an argument possibly with embedded spaces
# If spaces are embedded, the path will be split across multiple args 
# So we join all the args together will and embedded string
# The Salt cwd parm of the cmd state doesn't seem to handle quoting correctly
$lmrDir = [system.String]::Join(" ", $args)

cd "$lmrDir/windows-salt"  # Change to the windows-salt directory

$MY_REG_PORT = 86

$regIpOut = & docker-machine ip registry
$regIp = $regIpOut.split('\n')[0].Trim()

[Environment]::SetEnvironmentVariable("myReg", "$( $regIp ):$( $MY_REG_PORT )", "User")


