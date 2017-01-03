<# 
.SYNOPSIS 
	Extracts "global-status" from Vagrant in a friendly CSV format.
.DESCRIPTION 
	Calls "vagrant global-status" capturing a machine reaadable format. 
	Converts the format to CSV which can be fed to other scripts.
.EXAMPLE
	cd <Laminar root directory>\windows-salt  - e.g. cd c:\Laminar\windows-salt
	.\saveRegIPInEnvVar.ps1

.NOTES
	
	Author     : Tim Rochford - trochford-gh@gmail.com
.LINK 
	http://github.com/trochford/Laminar
#> 

vagrant global-status --machine-readable `
  | ConvertFrom-Csv -header timestamp, target, type, data, token `
  | Select-Object token `
  | ForEach { $i=0 } { if ( $i -gt 6 ) {"$($_.token)";} $i++ } `
  | ForEach { $j=0; $buf = "" } { if ($j -lt 5 ) { $buf += $_.trim(); if ( $j -lt 4 ) {$buf +=  ',' }; $j++; return }  $j=0; $out=$buf; $buf=""; $out  }  
