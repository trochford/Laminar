<# 
.SYNOPSIS 
	
	Dispatches a Laminar request to seven sub-commands.

	Sub-commands include:
		- bootstrap
		- up
		- kubeup
		- start
		- env
		- stop
		- down
		- remove

.DESCRIPTION 
	 Laminar commands include:

	  - bootstrap 
	    Download and install toolsets (listed below in Notes section) and wire together and activate them.

	  - up
	    Typically used after "laminar down" - restarts the toolsets reinstantiating as needed.

	  - kubeup
	    Starts just the minikube cluster with Laminar config parameters.  Alias for "minikube up".

	  - start
	    Typically used after "laminar stop" - restarts the toolsets.

	  - env
	    Sets the shell variable $myReg .

	  - stop
	    Deactivates the underlying Laminar toolsets - used to free up compute resources on your physical machine.

	  - down
	    Deactivated underlying Laminar toolsets and destroys any instances created. The Docker registry is stopped 
	    but contents are not removed.

	  - remove
	    Uninstalls the Laminar toolsets.

	Laminar should be run in a Powershell with Administrator privileges with ExecutionPolicy set to Unrestricted.

.EXAMPLE
	In a Powershell with Admin privileges...

	cd <Laminar root directory>  - e.g. cd c:\Laminar
	.\laminar < bootstrap | up | kubeup | start | env | stop | down | remove >

.NOTES
	Laminar Toolset:
	- Git
	- Salt
	- Virtualbox
	- Vagrant
	- Docker
	- Docker Toolbox
	- Minikube and Kubectl
	- Kompose

	Author     : Tim Rochford - trochford-gh@gmail.com
.LINK 
	http://github.com/trochford/Laminar
#> 

$runningNoLogOutput = $FALSE  # Assume false and prove true

##
# $PSScriptRoot holds the name of the directory where this script resides
# Effectively that is the Laminar directory
# $PSScriptRootNSE - the directory name - Not Space Escaped

  $PSScriptRootNSE = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition 

# Invoke-Expression requires escaping of embedded quotes

  $PSScriptRoot = $PSScriptRootNSE.Replace(' ','` ') # for directory names with spaces


echo "Running Laminar.... " $args[0] |
  tee -filepath "$PSScriptRootNSE\output0.txt" | Out-String -stream | Out-Host;


# Dispatch the sub-command
switch ($args[0]) {

  "bootstrap"   { 
                  Invoke-Expression "$($PSScriptRoot)\bootstrap.ps1 2>&1 |
                    tee -filepath $($PSScriptRoot)\output1.txt | Out-String -stream | Out-Host";
                  echo "" > $PSScriptRootNSE\output2.txt;
                  echo "" > $PSScriptRootNSE\output3.txt;

                  # Set myReg to be available in the shell calling this script
                  & { $global:myReg = [Environment]::GetEnvironmentVariable("myReg", "User") }
                  
                  # Update the process path to be the combination of the User and Machine paths
                  # in order to pickup any new installations; Also add the laminar directory to User path
                  $userPaths       = [Environment]::GetEnvironmentVariable('Path', 'User') -split ';'
                  $userPaths       +=  $PSScriptRoot 
                  [Environment]::SetEnvironmentVariable('Path', $userPaths -join ';', 'User')
                  $machinePaths    = [Environment]::GetEnvironmentVariable('Path', 'Machine') -split ';'
                  $newProcessPaths = $userPaths + $machinePaths 
                  [Environment]::SetEnvironmentVariable('Path', $newProcessPaths -join ';', 'Process')

                }
  "up"          { 
                  Invoke-Expression "$($PSScriptRoot)\saltcall.ps1 state.apply laminar-up 2>&1 | 
                     tee -filepath $($PSScriptRoot)\output1.txt | Out-String -stream | Out-Host";
                  echo "" > $PSScriptRootNSE\output2.txt;
                  echo "" > $PSScriptRootNSE\output3.txt;
                  # Set myReg to be available in the shell calling this script
                  & { $global:myReg = [Environment]::GetEnvironmentVariable("myReg", "User") }
                }
  "kubeup"      { $runningNoLogOutput = $TRUE;
                  & minikube up
                }
  "start"       { Invoke-Expression ".$($PSScriptRoot)\saltcall.ps1 state.apply laminar-start 2>&1 |
                     tee -filepath $($PSScriptRoot)\output1.txt | Out-String -stream | Out-Host";
                  echo "" > $PSScriptRootNSE\output2.txt;
                  echo "" > $PSScriptRootNSE\output3.txt;
                }
  "env"         { $runningNoLogOutput = $TRUE;
                  & { $global:myReg = [Environment]::GetEnvironmentVariable("myReg", "User") };
                }
  "stop"        { Invoke-Expression "$($PSScriptRoot)\saltcall.ps1 state.apply laminar-stop 2>&1 |
                     tee -filepath $($PSScriptRoot)\output1.txt | Out-String -stream | Out-Host";
                  echo "" > $PSScriptRootNSE\output2.txt;
                  echo "" > $PSScriptRootNSE\output3.txt;
                }
  "down"        { 
                  Invoke-Expression "$($PSScriptRoot)\saltcall.ps1 state.apply laminar-stop 2>&1 |
                     tee -filepath $($PSScriptRoot)\output1.txt | Out-String -stream | Out-Host";
                  Invoke-Expression "$($PSScriptRoot)\saltcall.ps1 state.apply laminar-clean 2>&1 |
                     tee -filepath $($PSScriptRoot)\output2.txt | Out-String -stream | Out-Host";
                  echo "" > $PSScriptRootNSE\output3.txt;
                }
  "remove"      { 
                  Invoke-Expression "$($PSScriptRoot)\saltcall.ps1 state.apply laminar-stop 2>&1 |
                     tee -filepath $($PSScriptRoot)\output1.txt | Out-String -stream | Out-Host";
                  Invoke-Expression "$($PSScriptRoot)\saltcall.ps1 state.apply laminar-clean 2>&1 |
                     tee -filepath $($PSScriptRoot)\output2.txt | Out-String -stream | Out-Host";
                  Invoke-Expression "$($PSScriptRoot)\saltcall.ps1 state.apply laminar-remove 2>&1 |
                     tee -filepath $($PSScriptRoot)\output3.txt | Out-String -stream | Out-Host";

                  # Remove the Laminar directory from the User and current Process paths
                  $userPath        = [Environment]::GetEnvironmentVariable('Path', 'User') -split ';'
                  $newUserPath     = @()
	          foreach ($dir in $userPath){
		    if($dir -match [Regex]::escape($PSScriptRoot)){
			#Do not Add to $newUserPath
		    }
		    else {
			$newUserPath += $dir
                    }
	          }
                  [Environment]::SetEnvironmentVariable('Path', $newUserPath -join ';', 'User')
                  $machinePaths    = [Environment]::GetEnvironmentVariable('Path', 'Machine') -split ';'
                  $newProcessPaths = $userPaths + $machinePaths 
                  [Environment]::SetEnvironmentVariable('Path', $newProcessPaths -join ';', 'Process')
                }
  default       { & get-help $PSScriptRootNSE\laminar.ps1; $runningNoLogOutput = $TRUE }
}


if ( -not $runningNoLogOutput ) {

  cat $PSScriptRootNSE\output0.txt, $PSScriptRootNSE\output1.txt, 
     $PSScriptRootNSE\output2.txt, $PSScriptRootNSE\output3.txt | 
     out-file -encoding ascii -filepath $PSScriptRootNSE\output.txt

  rm $PSScriptRootNSE\output0.txt, $PSScriptRootNSE\output1.txt, $PSScriptRootNSE\output2.txt, $PSScriptRootNSE\output3.txt

  less $PSScriptRootNSE\output.txt 

} else {
  rm $PSScriptRootNSE\output0.txt  # Always created upon Laminar invocation
}
