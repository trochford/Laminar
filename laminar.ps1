<# 
.SYNOPSIS 
	
	Dispatches a Laminar request to six sub-commands.

	Sub-commands include:
		- bootstrap
		- up
		- start
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
	.\laminar.ps1 < bootstrap | up | down | clean | remove >

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

$runningHelp = $FALSE  # Assume false and prove true

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
                  # Set REG_IP to be available in the shell calling this script
                  & { $global:REG_IP = [Environment]::GetEnvironmentVariable("REG_IP", "User") }
                }
  "up"          { 
                  Invoke-Expression ".\saltcall.ps1 state.apply laminar-up *>&1 | 
                     tee -filepath $($PSScriptRoot)\output1.txt" ;
                  echo "" > output2.txt;
                  echo "" > output3.txt;
                  # Set REG_IP to be available in the shell calling this script
                  & { $global:REG_IP = [Environment]::GetEnvironmentVariable("REG_IP", "User") }
                }
  "start"       { Invoke-Expression ".\saltcall.ps1 state.apply laminar-start *>&1 |
                     tee -filepath $($PSScriptRoot)\output1.txt";
                  echo "" > output2.txt;
                  echo "" > output3.txt;
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
  default       { & get-help .\laminar.ps1; $runningHelp = $TRUE }
}

if ( -not $runningHelp ) {

  cat output0.txt, output1.txt, output2.txt, output3.txt > output.txt

  rm output0.txt, output1.txt, output2.txt, output3.txt

  cat output.txt | out-host -paging 

}
