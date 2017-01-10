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

# Echo out the requested sub-command
echo "Running Laminar... " $args[0]

# Dispatch the sub-command
switch ($args[0]) {
  "bootstrap"   { 
                  Invoke-Expression ".\bootstrap.ps1" 
                  # Set REG_IP to be available in the shell calling this script
                  & { $global:REG_IP = [Environment]::GetEnvironmentVariable("REG_IP", "User") }
                }
  "up"          { 
                  Invoke-Expression ".\saltcall.ps1 state.apply laminar-up";
                  # Set REG_IP to be available in the shell calling this script
                  & { $global:REG_IP = [Environment]::GetEnvironmentVariable("REG_IP", "User") }
                }
  "start"       { Invoke-Expression ".\saltcall.ps1 state.apply laminar-start" }
  "stop"        { Invoke-Expression ".\saltcall.ps1 state.apply laminar-stop" }
  "down"        { 
                  Invoke-Expression ".\saltcall.ps1 state.apply laminar-stop";
                  Invoke-Expression ".\saltcall.ps1 state.apply laminar-clean" 
                }
  "remove"      { 
                  Invoke-Expression ".\saltcall.ps1 state.apply laminar-stop";
                  Invoke-Expression ".\saltcall.ps1 state.apply laminar-clean"; 
                  Invoke-Expression ".\saltcall.ps1 state.apply laminar-remove" 
                }
  default       { & get-help .\laminar.ps1 }
}

