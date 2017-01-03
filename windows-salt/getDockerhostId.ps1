<# 
.SYNOPSIS 
	Set the private Docker "registry" IP address into REG_IP environment variable
.DESCRIPTION 
	Calls "docker-machine ip registory".  Sets REG_IP in the User namespace
.EXAMPLE
	cd <Laminar root directory>\windows-salt  - e.g. cd c:\Laminar\windows-salt
	.\saveRegIPInEnvVar.ps1

.NOTES
	Uses [Environment]::SetEnvironmentVarialble.  Other approaches do not
	reliably allow for getting the value in the same Powershell session.
	
	Author     : Tim Rochford - trochford-gh@gmail.com
.LINK 
	http://github.com/trochford/Laminar
#> 

.\globalStatusData.ps1 `
  | ConvertFrom-Csv -header id, name, provider, state, directory `
  | ForEach { if ( $($_.name) -eq "vagrant-dockerhost") { $($_.id) } }
  
