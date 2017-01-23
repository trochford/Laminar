<# 
.SYNOPSIS 
	Point the Vagrant Dockerhost to the container registry using 
	an environment variable in dockerhost
.DESCRIPTION 
	Creates a bash command executed through Vagrant SSH in the 
	vagrant-dockerhost.  Restarts Docker in the dockerhost, then
	invokes exportRegIP.sh.
.EXAMPLE
	cd <Laminar root directory>\windows-salt  - e.g. cd c:\Laminar\windows-salt
	.\vagrantSshCall.ps1

.NOTES
	Uses [Environment]::GetEnvironmentVariable to get current value of "myReg". 
        Updates the current process (not the interactive shell) with User+Machine paths 
        to reflect any new installations in the calling process
	 
	Author     : Tim Rochford - trochford-gh@gmail.com
.LINK 
	http://github.com/trochford/Laminar
#> 

$ip = [Environment]::GetEnvironmentVariable( "myReg", "User" )


##
# Update the process path to be the combination of the User and Machine paths
# in order to pickup any new installations not reflected in this process
$userPaths       = [Environment]::GetEnvironmentVariable('Path', 'User') -split ';'
$machinePaths    = [Environment]::GetEnvironmentVariable('Path', 'Machine') -split ';'
$newProcessPaths = $userPaths + $machinePaths
[Environment]::SetEnvironmentVariable('Path', $newProcessPaths -join ';', 'Process')

$bashCmd = 'echo DOCKER_OPTS="--insecure-registry=' + $ip + '" >> /etc/default/docker'
$vagrantCmd = "sudo bash -c '" + $bashCmd + "'"

# Passing the path to the Laminar directory as an argument possibly with embedded spaces
# If spaces are embedded, the path will be split across multiple args 
# So we join all the args together will and embedded string
# The Salt cwd parm of the cmd state doesn't seem to handle quoting correctly
$lmrDir = [system.String]::Join(" ", $args)

cd "$lmrDir/vagrantShare"  # Change to the vagrantShare directory

vagrant ssh -c  $vagrantCmd

vagrant ssh -c "sudo restart docker"

vagrant ssh -c "/bin/bash -x /vagrantShare/exportRegIP.sh $ip"


