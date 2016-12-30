$regIpOut = & docker-machine ip registry
$regIp = $regIpOut.split('\n')[0].Trim()

[Environment]::SetEnvironmentVariable("REG_IP", "$( $regIp ):80", "User")
