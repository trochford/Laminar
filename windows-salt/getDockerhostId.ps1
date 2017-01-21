<# 
.SYNOPSIS 
	Gets the Vagrant ID of vagrant-dockerhost
.DESCRIPTION 
	Calls vagrant global-status indirectly
.EXAMPLE
	cd <Laminar root directory>\windows-salt  - e.g. cd c:\Laminar\windows-salt
	.\getDockerHostId.ps1

.NOTES
	Uses globalStatusData.ps1
	
	Author     : Tim Rochford - trochford-gh@gmail.com
.LINK 
	http://github.com/trochford/Laminar
#> 

.\globalStatusData.ps1 `
  | ConvertFrom-Csv -header id, name, provider, state, directory `
  | ForEach { if ( $($_.name) -eq "vagrant-dockerhost") { $($_.id) } }
  
