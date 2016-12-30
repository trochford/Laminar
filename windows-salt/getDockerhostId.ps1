.\globalStatusData.ps1 `
  | ConvertFrom-Csv -header id, name, provider, state, directory `
  | ForEach { if ( $($_.name) -eq "vagrant-dockerhost") { $($_.id) } }
  
