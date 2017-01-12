# Laminar
Quick setup of Git, SaltStack, Vagrant, Docker, Docker Toolbox and Minikube for a Windows machine targeting Linux development.

#### Objectives: 
* Reduce the turbulence in getting started with Linux/Salt/Docker when developing on a Windows machine.
* Ease the transition of introducing SaltStack in support of Production Configuration.

Laminar will bootstrap by installing Salt and Git on Windows.  The Salt Winrepo will then be downloaded,
and based on Winrepo definitions, VirtualBox and Vagrant will be installed on Windows.  Vagrant will
bring up VirtualBox with a Ubuntu image as a Docker host.  Salt will be installed in that Ubuntu image and
then Salt and Git will provision Docker. Both the Windows and Linux Salt installations will be masterless minions.

Docker Toolbox will be installed (on Windows) and a private, local, insecure registry will be configured.  
The Vagrant Dockerhost will be configured with an environment variable REG_IP that references the registry IP address and port to ease "docker pushes" to the registry from the Docker host.

A "lite" version of Kubernetes can also be installed - Minikube.  It requires the Kubernetes
command line utility as well.  Minikube will be configured to pull from the private registry also using the registry IP and port.

A "lite" version of Kubernetes can also be installed - Minikube.  It requires the Kubernetes
command line utility as well - Kubectl. Laminar boot.ps1 will ask if you want them installed.

#### Download
* Clone or download and extract project into a local directory, e.g. c:\Laminar or c:\Users\albert

#### Usage: To get started...

1. *Open a Powershell in Windows run as administrator*
2. *Enter:* Set-ExecutionPolicy Unrestricted
3. *Enter:* cd \Laminar
4. *Enter:* .\laminar bootstrap

##### Powershell
* *To open a Powershell, use the Start menu Search entering:* Powershell
* *Right click on the* Windows Powershell *choice and select:* Run as administrator.

When Git is installing, choose the defaults provided.

VirtualBox will require enabling Hardware Virtualization support in the Bios settings of the host machine.

The Ubuntu image loaded will be Trusty64 from Hashicorp provided without a Desktop GUI.  The directory shared between Windows and the Ubuntu image is vagrantShare.   
* *Windows -* c:\Laminar\vagrantShare
* *Linux -* /vagrantShare

The vagrant user credentials are the defaults - User: vagrant ; Password: vagrant

The VirtualBox console GUI will be initiated during the running of the boot script.  A container running bash in Ubuntu will be running in Docker. Upon completion of the boot script, Docker can be tested with the Docker hello-world image:
* *Enter:* sudo docker run hello-world
or 
* *Enter"* sudo docker attach Ubunto 

There will be two Vagrant providers running: one for Docker and one for the Ubuntu host.  To destroy them, two Vagrant Destroy commands will be needed:
* *At the Window prompt, enter:* vagrant destroy *- will tear down the Docker provider "myService"*
* *and then, enter:* vagrant global-status *- to find the ID of the VirtualBox provider "dockerhost"*
* *and then, enter:* vagrant destroy {dockerhost ID} 

Tested on Windows 7 and Windows 10.

For sessions subsequent to the initial running of the boot script, the Ubuntu image can be started in the standard Vagrant fashion:
* *In a CMD shell, enter:* cd c:\Laminar\vagrantShare
* *Enter:* vagrant up

### Laminar Help

NAME
    C:\users\tim\documents\laminar\laminar.ps1
    
SYNOPSIS
    Dispatches a Laminar request to seven sub-commands.
    
    Sub-commands include:
    	- bootstrap
    	- up
    	- start
    	- env
    	- stop
    	- down
    	- remove
    
    
SYNTAX
    C:\users\tim\documents\laminar\laminar.ps1 [<CommonParameters>]
    
    
DESCRIPTION
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
    

RELATED LINKS
    http://github.com/trochford/Laminar


