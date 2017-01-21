<# 
.SYNOPSIS 
	Gets the IP address of the Docker host running in Vagrant
.DESCRIPTION 
	The Host IP address is established through a Vagrant public network and is dynamically allocated.
	This utility function looks at the IP Configurations and extracts the VirtualBox Host address 
	using the third VirtualBox Host adapter.
.EXAMPLE
	cd <Laminar root directory>\windows-salt  - e.g. cd c:\Laminar\windows-salt 
	.\getVagrantDockerHostIp.ps1
.NOTES
	Powershell 2 compatible using a wrapper function around WMIObject.
        Function attribution: http://stackoverflow.com/questions/38883433/getting-ip-details-in-powershell 
 
	Author     : Tim Rochford - trochford-gh@gmail.com
.LINK 
	http://github.com/trochford/Laminar
#> 

function Get-NetworkInterface {
    param(
        [String]$Name = '*',

        [String]$ComputerName
    )

    $params = @{
        Class = 'Win32_NetworkAdapter'
    }
    if ($Name.IndexOf('*') -gt -1) {
        $Name = $Name -replace '\*', '%'
        $params.Add('Filter', "NetConnectionID LIKE '$Name'")
    } else {
        $params.Add('Filter', "NetConnectionID='$Name'")
    }
    if ($ComputerName -ne '') {
        $params.Add('ComputerName', $ComputerName)
    }

    Get-WmiObject @params | Select-Object NetConnectionID, `
        @{Name='IPAddress'; Expression={
            $_.GetRelated('Win32_NetworkAdapterConfiguration') | ForEach-Object {
                [IPAddress[]]$_.IPAddress | Where-Object { $_.AddressFamily -eq 'InterNetwork' }
            }
        }}
}

$ip = Get-NetworkInterface 'VirtualBox Host-Only Network #3' | 
        Select-Object IPAddress | 
        Select -exp IPAddress | 
        Select -exp IPAddressToString
$ip



