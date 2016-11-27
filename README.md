# Laminar
Quick setup of Git, SaltStack, Vagrant, Ubuntu and Docker for a Windows machine targeting Linux development.

#### Objectives: 
* Reduce the turbulence in getting started with Linux/Salt/Docker when developing on a Windows machine.
* Ease the transition of introducing SaltStack in support of Production Configuration.

Laminar will initiate by installing Salt and Git on Windows.  The Salt Winrepo will then be downloaded,
and based on Winrepo definitions, VirtualBox and Vagrant will be installed on Windows.  Vagrant will
bring up VirtualBox with a Ubuntu image.  Salt will be installed in that Ubuntu image and then Salt and Git
will provision Docker in that image as well. Both Salt installations will be masterless minions.

A "lite" version of Kubernetes can also be installed - Minikube.  It requires the Kubernetes
command line utility as well - Kubectl. Laminar boot.ps1 will ask if you want them installed.

#### Download
* Clone or download and extract project into c:\Laminar

#### Usage: 

1. *Open a Powershell in Windows run as administrator*
2. *Enter:* Set-ExecutionPolicy Unrestricted
3. *Enter:* cd \Laminar
4. *Enter:* ./boot.ps1

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

