<# 
.SYNOPSIS 
	Installs the toolsets to support Laminar and instantiates and wires together the different tools.
	Tools include:
		- Git
		- Salt
		- Virtualbox
		- Vagrant
		- Docker
		- Docker Toolbox
		- Minikube and Kubectl
                - Kompose

.DESCRIPTION 
	Laminar will begin by installing Salt and Git.  The Salt Winrepo will then be downloaded,   
	and based on Winrepo definitions, VirtualBox and Vagrant will be installed.  Vagrant will  
	bring up VirtualBox with a Ubuntu image.  Salt will be installed in that image and then Salt
	will provision Docker in that image as well. Both Salt installations will be masterless    
	minions. Docker Toolbox will be installed and a container created containing a "registry".
	A "lite" version of Kubernetes can also be installed - Minikube.  It requires the Kubernetes
	command line utility as well - Kubectl.                                                    
.EXAMPLE
	cd <Laminar root directory>  - e.g. cd c:\Laminar
	.\bootstrap.ps1

.NOTES
	Author     : Tim Rochford - trochford-gh@gmail.com
.LINK 
	http://github.com/trochford/Laminar
#> 

##
# Provide a general description of the Laminar installation process

Write-Host "                                                                                                  "
Write-Host "                                                                                                  "
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "~~ Laminar will begin by installing Salt and Git.  The Salt Winrepo will then be downloaded,    ~~"
Write-Host "~~ and based on Winrepo definitions, VirtualBox and Vagrant will be installed.  Vagrant will    ~~"
Write-Host "~~ bring up VirtualBox with a Ubuntu image.  Salt will be installed in that image and then Salt ~~"
Write-Host "~~ will provision Docker in that image as well. Both Salt installations will be masterless      ~~"
Write-Host "~~ minions. Docker Toolbox will be installed and a container created containing a "registry".   ~~"
Write-Host "~~ A "lite" version of Kubernetes can also be installed - Minikube.  It requires the Kubernetes ~~"
Write-Host "~~ command line utility as well - Kubectl.                                                      ~~"
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "                                                                                                  "


##
# Assume the Powershell version is not compatible and prove it is..
$isCompatibleWithSaltstack = $FALSE
foreach ( $v in $PSVersionTable.PSCompatibleVersions ) {
    if ( $v.Major -eq 3 ) {
        $isCompatibleWithSaltstack = $TRUE
    }
}
if ( -not $isCompatibleWithSaltstack ) {
    Write-Host ""
    Write-Host "Saltstack has some modules that depend on Powershell version 3 or greater.  Probably wise to upgrade."
    #return
}

$ans_cont = Read-Host -Prompt 'Continue - [Y]es or [N]?'
if ( $ans_cont -ne 'Y' ) { Return }


##
# program files - the conventional Windows Program Files directory 
$programFiles = $Env:PROGRAMFILES
if ( -not $programFiles ) { $programFiles = "C:\Program Files" }

$homePath = $Env:HOMEDRIVE+$Env:HOMEPATH

$vboxDir  = $Env:VBOX_MSI_INSTALL_PATH
if ( -not $vboxDir ) { # not installed, set to VB install default
   $vboxDir = "C:\Program Files\Oracle\VirtualBox" 
} else {
   $vboxDir = $vboxDir.TrimEnd( '\' ).TrimEnd( '/' ) 
}


##
# Source directory will contain initial package downloads
$source = 'C:\source'
If (!(Test-Path -Path $source -PathType Container)) {New-Item -Path $source -ItemType Directory | Out-Null} 

$packages = @( 
@{title='Salt Minion';url='https://repo.saltstack.com/windows/Salt-Minion-2016.11.0-x86-Setup.exe';Arguments=' /s /start-service=0';Destination=$source;phase=1}, 
@{title='Git for Windows';url='https://github.com/git-for-windows/git/releases/download/v2.10.2.windows.1/Git-2.10.2-64-bit.exe';Arguments=' /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-';Destination=$source;phase=1} 
)
 
# Inquire which packages should be installed - only choices are currently Git and Salt
foreach ($package in $packages) { 
    $packageName = $package.title
    Write-Host " "
    $ans_pkg = Read-Host -Prompt "Download and install $packageName - [Y]es or [N]o?"
    if ( $ans_pkg.ToLower().StartsWith('y') ) {
        $package.selected = $TRUE
    } else {
        $package.selected = $FALSE
    }
}


##
# This script was invoked from the Laminar diretory - so $PSScriptRoot will reference the Laminar directory
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition


##
# Download the selected packages
foreach ($package in $packages) { 
    if ( $package.selected ) {
        $packageName = $package.title 
        $fileName = [System.IO.Path]::GetFileName($package.url)  
        $destinationPath = $package.Destination + "\" + $fileName 

        If (!(Test-Path -Path $destinationPath -PathType Leaf)) { 
            Write-Host "Downloading $packageName" 
            $webClient = New-Object System.Net.WebClient 
            $webClient.DownloadFile($package.url,$destinationPath)
        }
    } 
}

## 
# Once we've downloaded our initial packages, lets install them. 
foreach ($package in $packages) { 
    if ( $package.selected -and ( $package.phase -eq 1 ) ) {
        $packageName = $package.title 
        $fileName = [System.IO.Path]::GetFileName($package.url) 
        $destinationPath = $package.Destination + "\" + $fileName 
        $Arguments = $package.Arguments 
        Write-Output "Installing $packageName" 
        Invoke-Expression -Command "$destinationPath $Arguments | Write-Output"
    }
}

##
# The Windows Salt sls files and associated Powershell scripts can be found here:
# "$PSScriptRoot/windows-salt"

# Salt assumed to be installed in c:\salt which is the default of the SaltStack package installation
$saltDir = "c:\salt"
Set-Location $saltDir

# The Salt minion configuration file is here
$confRoot = "$PSScriptRoot/windows-salt/conf"

# Adjust the slashes of these 2 directory references for salt compatible syntax
$saltPSScriptRoot    = $PSScriptRoot.Replace('\','/')
$saltSaltDir         = $saltDir.Replace('\','/')
$saltProgramFiles    = $programFiles.Replace('\','/')
$saltHomePath        = $homePath.Replace('\','/')
$saltVboxDir         = $vboxDir.Replace('\','/')

##
# Create a parameterized version of the Windows standalone client minion file
# "$minionText" will contain the contents of the client minion file

$minionText = @"
file_client: local
winrepo_remotes:
  - https://github.com/saltstack/salt-winrepo.git
winrepo_remotes_ng:
  - https://github.com/saltstack/salt-winrepo-ng.git
# can add another line to this creating another target remote winrepo

file_roots:
 base:
  - $saltPSScriptRoot/windows-salt
  - $saltSaltDir/srv/salt
"@

# Now save the minion config contents out creating a Salt minion file
$minionText | Out-File -filepath $confRoot\minion -encoding ASCII

##
# Retrieve the winrepo into --- (These 3 salt-calls can be moved to a Salt SLS file)
Write-Host ""
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "~~~ Retrieving SaltStack's Winrepo resources"
Write-Host "~~~"
Invoke-Expression -Command ".\salt-call.bat --config-dir=$confRoot winrepo.update_git_repos | Out-Null"
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host ""

# Update the Winrepo Database
Write-Host ""
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "~~~ Gen Winrepo"
Write-Host "~~~"
Invoke-Expression -Command ".\salt-call.bat --config-dir=$confRoot winrepo.genrepo | Out-Null"
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host ""

# Refresh the pkg DB
Write-Host ""
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "~~~ Refreshing Winrepo Package DB "
Write-Host "~~~  (expecting some 'intellij' Package DB compile errors)"
Write-Host "~~~"
Invoke-Expression -Command ".\salt-call.bat --config-dir=$confRoot pkg.refresh_db | Out-Null"
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host ""

##
# Invoke Salt to do the rest of the bootstrap....

Write-Host ""
Write-Host ""
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "~~~ Running Salt states to ensure VirtualBox, Vagrant, etc. are installed & wired on Windows"
Write-Host "~~~"
Write-Host "~~~ These SaltStack states will take about 20 minutes to run..."
Write-Host "~~~"
Write-Host "~~~ The salt-call command completing the bootstrap: "
Write-Host "~~~"
Write-Host ""
echo ".\salt-call.bat --config-dir=$confRoot --metadata state.highstate pillar=`"{'PROGRAM_FILES': '$saltProgramFiles', 'LAMINAR_DIR': '$saltPSScriptRoot', 'HOME_PATH': '$saltHomePath', 'VBOX_DIR': '$saltVboxDir' }`" -l warning"
Write-Host ""
Write-Host "~~~"
Write-Host "~~~"
Write-Host "~~~ Starting the run now..."
Write-Host "~~~  - Expecting Salt Winrepo package errors - 'duplicati' not defined as a dictionary and 'intellij' again"
Write-Host "~~~  - The Virtualbox Winrepo package indicates an error for a successful install status"
Write-Host "~~~  - If you are running Powershell less than version 4, there will be an error on the instal of 'dvm'"
Write-Host "~~~     This refers to Docker Version Manager which has not been needed to date,"
Write-Host "~~~     but is provided as a possible convenience."
Write-Host "~~~"
Write-Host ""
Write-Host ""
Invoke-Expression -Command ".\salt-call.bat --config-dir=$confRoot --metadata state.highstate pillar=`"{'PROGRAM_FILES': '$saltProgramFiles', 'LAMINAR_DIR': '$saltPSScriptRoot', 'HOME_PATH': '$saltHomePath', 'VBOX_DIR': '$saltVboxDir' }`" -l warning"


##
# After Salt work completes, return to the Laminar diretory 
Set-Location "$PSScriptRoot"

