vagrant global-status --machine-readable `
  | ConvertFrom-Csv -header timestamp, target, type, data, token `
  | Select-Object token `
  | ForEach { $i=0 } { if ( $i -gt 6 ) {"$($_.token)";} $i++ } `
  | ForEach { $j=0; $buf = "" } { if ($j -lt 5 ) { $buf += $_.trim(); if ( $j -lt 4 ) {$buf +=  ',' }; $j++; return }  $j=0; $out=$buf; $buf=""; $out  }  
