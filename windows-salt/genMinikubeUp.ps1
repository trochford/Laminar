
##
# Create Powershell and CMD shell scripts to start Minikube (minikube-up)
# with the correct parameters.  These can be used in later sessions..

$mups1 = @"
`$regIpVar = [Environment]::GetEnvironmentVariable('REG_IP','User')
minikube.exe start --vm-driver='virtualbox' --insecure-registry=`$(`$regIpVar):80
"@

$mups1 | Out-File -filepath minikube-up.ps1 -encoding ASCII

$mucmd = "powershell.exe -noexit -file 'minikube-up.ps1' `$`*"
$mucmd | Out-File -filepath minikube-up.cmd -encoding ASCII

##
# Then start minikube...
        
$regIpVar = [Environment]::GetEnvironmentVariable('REG_IP','User')
& minikube.exe start --vm-driver="virtualbox" --insecure-registry=$( $regIpVar ):80
