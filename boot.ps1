
Write-Host "                                                                                                  "
Write-Host "                                                                                                  "
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "~~ Laminar will initiate by installing Salt and Git.  The Salt Winrepo will then be downloaded, ~~"
Write-Host "~~ and based on Winrepo definitions, VirtualBox and Vagrant will be installed.  Vagrant will    ~~"
Write-Host "~~ bring up VirtualBox with a Ubuntu image.  Salt will be installed in that image and then Salt ~~"
Write-Host "~~ will provision Docker in that image as well. Both Salt installations will be masterless      ~~"
Write-Host "~~ minions.                                                                                     ~~"
Write-Host "~~ A "lite" version of Kubernetes can also be installed - Minikube.  It requires the Kubernetes ~~"
Write-Host "~~ command line utility as well - Kubectl. Laminar boot will as if you want them installed.     ~~"
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "                                                                                                  "

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


$source = 'C:\source' 

If (!(Test-Path -Path $source -PathType Container)) {New-Item -Path $source -ItemType Directory | Out-Null} 

$packages = @( 
@{title='Salt Minion';url='https://repo.saltstack.com/windows/Salt-Minion-2016.3.4-AMD64-Setup.exe';Arguments=' /s /start-service=0';Destination=$source;phase=1}, 
@{title='Git for Windows';url='https://github.com/git-for-windows/git/releases/download/v2.10.2.windows.1/Git-2.10.2-64-bit.exe';Arguments=' /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-';Destination=$source;phase=1}, 
@{title='Minikube';url='https://storage.googleapis.com/minikube/releases/v0.12.2/minikube-windows-amd64.exe';Arguments=' start --vm-driver="virtualbox" --show-libmachine-logs --alsologtostderr';Destination=$source;phase=2},
@{title='Kubectl - Kubernetes Command Line Interface';url='http://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/windows/amd64/kubectl.exe';Arguments=' cluster-info';Destination=$source;phase=2}
) 

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

 
#Once we've downloaded all our files lets install them. 
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

# This script was invoked from the Laminar diretory
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# The top, virtualbox and vagrant Salt sls files can be found here
$fileRoot = "$PSScriptRoot/windows-salt"

# The minion configuration file is here
$confRoot = "$PSScriptRoot/windows-salt/conf"

# Salt assumed to be installed in c:\salt
Set-Location "c:\salt"

# Retrieve the winrepo into
Write-Host ""
Write-Host "Retrieving winrepo"
Invoke-Expression -Command ".\salt-call.bat --config-dir=$confRoot winrepo.update_git_repos"

# Update the winrepo database
Write-Host ""
Write-Host "Gen winrepo"
Invoke-Expression -Command ".\salt-call.bat --config-dir=$confRoot winrepo.genrepo"

# Refresh the pkg DB
Write-Host ""
Write-Host "Refreshing Package DB"
Invoke-Expression -Command ".\salt-call.bat --config-dir=$confRoot pkg.refresh_db"

Write-Host ""
Write-Host "Executing Salt states to ensure VirtualBox and Vagrant are installed on Windows"
Invoke-Expression -Command ".\salt-call.bat --config-dir=$confRoot state.highstate"

# Pop back to the Laminar sub-directory where the vagrantFile can be found
Set-Location "$PSScriptRoot/vagrantShare"

Write-Host ""
Write-Host "Invoking ""vagrant up"" command with vagrantFile ensuring Salt is installed on Linux"
#Invoke-Expression -Command "vagrant up" - doesn't work because the %path% varibles have not been refreshed
Invoke-Expression -Command "C:\HashiCorp\Vagrant\bin\vagrant.exe up" 


foreach ($package in $packages) { 
    if ( $package.selected -and ( $package.phase -eq 2 ) ) {
        $packageName = $package.title 
        $fileName = [System.IO.Path]::GetFileName($package.url) 
        $destinationPath = $package.Destination + "\" + $fileName 
        $Arguments = $package.Arguments 
        Write-Output "Installing $packageName" 
        Invoke-Expression -Command "$destinationPath $Arguments | Write-Output"
    }
}

