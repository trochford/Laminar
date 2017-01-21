<# 
.SYNOPSIS 
	Starts minikube and creates a minikube-up script for subsequent use.
.DESCRIPTION 
	Create Powershell and CMD shell scripts to start Minikube (as "minikube up") with added Laminar parameters.  
	These can be used in later sessions..  
	Then starts minikube.
.EXAMPLE
	cd <Laminar root directory>\windows-salt  - e.g. cd c:\Laminar\windows-salt 
	.\genMinikubeUp.ps1
.NOTES
	Generates "minikube.ps1" in the Program Files minikube directory.  Uses myReg environment variable.  
	Author     : Tim Rochford - trochford-gh@gmail.com
.LINK 
	http://github.com/trochford/Laminar
#> 

##
# Create Powershell and CMD shell scripts to start Minikube (minikube-up)
# with the correct parameters.  These can be used in later sessions..

$mups1 = @"
# Dispatch the sub-command
switch (`$args[0]) {
  "up"     { 
             `$regIpVar = [Environment]::GetEnvironmentVariable('myReg','User')
             minikubeOrig.exe start --vm-driver='virtualbox' --insecure-registry=`$(`$regIpVar)
           }
  default  { 
             minikubeOrig.exe `$args
           }
}
"@

$mups1 | Out-File -filepath minikube.ps1 -encoding ASCII

$mucmd = @"
@echo off
powershell.exe -NoLogo -File "%HOMEDRIVE%%HOMEPATH%\minikube\minikube.ps1" %*
"@

$mucmd | Out-File -filepath minikube.cmd -encoding ASCII

##
# Then start minikube...
        
$regIpVar = [Environment]::GetEnvironmentVariable('myReg','User')
& minikubeOrig.exe start --vm-driver="virtualbox" --insecure-registry=$( $regIpVar )
