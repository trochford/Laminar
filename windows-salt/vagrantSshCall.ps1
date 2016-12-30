
##
# Point the Vagrant Dockerhost to the container registry using 
# an environment variable in dockerhost
# $id = the Vagrant Id of the dockerhost
# $ip = the IP address of the container registry

$id = PowerShell '.\getDockerhostId.ps1'
$ip = [Environment]::GetEnvironmentVariable( "REG_IP", "User" )


$bashCmd = 'echo DOCKER_OPTS="--insecure-registry=' + $ip + '" >> /etc/default/docker'
$vagrantCmd = "sudo bash -c '" + $bashCmd + "'"

vagrant ssh $id -c  $vagrantCmd

vagrant ssh $id -c "sudo restart docker"

vagrant ssh $id -c "/bin/bash -x /vagrantShare/exportRegIP.sh $ip"

