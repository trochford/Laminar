<# 
.SYNOPSIS 
	
	Dispatches a Laminar request to seven sub-commands.

	Sub-commands include:
		- bootstrap
		- up
		- start
		- env
		- stop
		- down
		- remove

.DESCRIPTION 
	 Laminar commands include:

	  - bootstrap 
	    Download and install toolsets (listed below in Notes section) and wire together and activate them

	  - up
	    Typically used after "laminar down" - restarts the toolsets reinstantiating toolsets as needed

	  - start
	    Typically used after "laminar stop" - restarts the toolsets

	  - env
	    Sets the shell variable $myReg in the Powershell console 

	  - stop
	    Deactivates the underlying Laminar toolsets - used to free up compute resources on your physical machine

	  - down
	    Deactivated underlying Laminar toolsets and destroys any instances created. The Docker registry is stopped 
	    but not removed.

	  - remove
	    Uninstalls the Laminar toolsets

	Laminar should be run in a Powershell with Administrator privileges with ExecutionPolicy set to Unrestricted.

.EXAMPLE
	In a Powershell with Admin privileges...

	cd <Laminar root directory>  - e.g. cd c:\Laminar
	.\laminar < bootstrap | up | start | env | stop | down | remove >

.NOTES
	Laminar Toolsets:
	- Git
	- Salt
	- Virtualbox
	- Vagrant
	- Docker
	- Docker Toolbox
	- Minikube and Kubectl

	Author     : Tim Rochford - trochford-gh@gmail.com
.LINK 
	http://github.com/trochford/Laminar
#> 

$runningHelpOrEnv = $FALSE  # Assume false and prove true

$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

echo "Running Laminar.... " $args[0] *>&1 |
  tee -filepath "$($PSScriptRoot)\output0.txt" ;


# Dispatch the sub-command
switch ($args[0]) {

  "bootstrap"   { 
                  Invoke-Expression ".\bootstrap.ps1 *>&1 |
                    tee -filepath $($PSScriptRoot)\output1.txt" ;
                  echo "" > output2.txt;
                  echo "" > output3.txt;
                  # Set myReg to be available in the shell calling this script
                  & { $global:myReg = [Environment]::GetEnvironmentVariable("myReg", "User") }
                }
  "up"          { 
                  Invoke-Expression ".\saltcall.ps1 state.apply laminar-up *>&1 | 
                     tee -filepath $($PSScriptRoot)\output1.txt" ;
                  echo "" > output2.txt;
                  echo "" > output3.txt;
                  # Set myReg to be available in the shell calling this script
                  & { $global:myReg = [Environment]::GetEnvironmentVariable("myReg", "User") }
                }
  "start"       { Invoke-Expression ".\saltcall.ps1 state.apply laminar-start *>&1 |
                     tee -filepath $($PSScriptRoot)\output1.txt";
                  echo "" > output2.txt;
                  echo "" > output3.txt;
                }
  "env"         { $runningHelpOrEnv = $TRUE; 
                  & { $global:myReg = [Environment]::GetEnvironmentVariable("myReg", "User") }
                }
  "stop"        { Invoke-Expression ".\saltcall.ps1 state.apply laminar-stop *>&1 |
                     tee -filepath $($PSScriptRoot)\output1.txt";
                  echo "" > output2.txt;
                  echo "" > output3.txt;
                }
  "down"        { 
                  Invoke-Expression ".\saltcall.ps1 state.apply laminar-stop *>&1 |
                     tee -filepath $($PSScriptRoot)\output1.txt";
                  Invoke-Expression ".\saltcall.ps1 state.apply laminar-clean *>&1 |
                     tee -filepath $($PSScriptRoot)\output2.txt";
                  echo "" > output3.txt;
                }
  "remove"      { 
                  Invoke-Expression ".\saltcall.ps1 state.apply laminar-stop *>&1 |
                     tee -filepath $($PSScriptRoot)\output1.txt";
                  Invoke-Expression ".\saltcall.ps1 state.apply laminar-clean *>&1 |
                     tee -filepath $($PSScriptRoot)\output2.txt";
                  Invoke-Expression ".\saltcall.ps1 state.apply laminar-remove *>&1 |
                     tee -filepath $($PSScriptRoot)\output3.txt";
                }
  default       { & get-help .\laminar.ps1; $runningHelpOrEnv = $TRUE }
}


if ( -not $runningHelpOrEnv ) {

  cat output0.txt, output1.txt, output2.txt, output3.txt | 
     out-file -encoding ascii -filepath output.txt

  rm output1.txt, output2.txt, output3.txt

  #cat output.txt | out-host -paging 
  less output.txt 

}

rm output0.txt  # Always created upon Laminar invocation
