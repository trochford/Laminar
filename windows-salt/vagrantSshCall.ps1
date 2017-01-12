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
	Uses [Environment]::GetEnvironmentVarialble.  Other approaches do not
	reliably allow for getting the value in the same Powershell session.
	Calls: getDockerhostId.ps1
	Author     : Tim Rochford - trochford-gh@gmail.com
.LINK 
	http://github.com/trochford/Laminar
#> 

$id = PowerShell '.\getDockerhostId.ps1'
$ip = [Environment]::GetEnvironmentVariable( "myReg", "User" )

# Set the PATH in our current process to include the git/usr/bin set in the calling dockerHostRegRef.sls
foreach($level in "Machine","User") {
   [Environment]::GetEnvironmentVariables($level).GetEnumerator() | % {
      # For Path variables, append the new values, if they're not already in there
      if($_.Name -match 'Path$') { 
         $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -split ';' | Select -unique) -join ';'
      }
      $_
   } | ForEach{ Set-Content -Path "Env:$($_.Name)" -Value $_.Value }
}

$bashCmd = 'echo DOCKER_OPTS="--insecure-registry=' + $ip + '" >> /etc/default/docker'
$vagrantCmd = "sudo bash -c '" + $bashCmd + "'"

vagrant ssh $id -c  $vagrantCmd

vagrant ssh $id -c "sudo restart docker"

vagrant ssh $id -c "/bin/bash -x /vagrantShare/exportRegIP.sh $ip"

