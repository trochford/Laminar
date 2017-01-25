# Laminar Lab
Quick setup of Git, SaltStack, Vagrant, Docker, Docker Toolbox and Minikube for a Windows machine targeting Linux development. The components are configured to work together providing a single machine lab to gain practical experience with DevOps technologies.

#### Objective: 
* Ease the process of getting started with Docker, Docker Toolbox, Vagrant and Kubernetes on a Windows machine.


Laminar will bootstrap by installing Salt and Git on Windows after prompting.  The Salt Winrepo holding Windows package defintions will then be downloaded,
and based on Winrepo definitions, VirtualBox and Vagrant will be installed on Windows.  Vagrant will
bring up VirtualBox with a Ubuntu image as a Docker host.  Salt will be installed in that Ubuntu image and
then Salt and Git will provision Docker on the host. Both the Windows and Linux Salt installations will be masterless minions.

A "lite", single node cluster version of Kubernetes is installed called Minikube along with the Kubernetes
command line utility - Kubectl.  Minikube will be configured to pull from the private registry also using the registry IP and port.

Docker Toolbox will be installed (on Windows) and a private, local, insecure registry will be configured.  
Both the Vagrant Dockerhost and Windows will be configured with an environment variable $myReg that references the registry IP address and port to ease "docker pushes and pulls" to the registry to and from the Docker host and Minikube.


#### Download
* Clone or download and extract project into a local directory, e.g. c:\Laminar or c:\Users\Alice.

#### Usage: To get started...

1. *Open a Powershell in Windows run as administrator*
2. *Enter:* Set-ExecutionPolicy Unrestricted
3. *Enter:* cd [where you want Laminar to live]
4. *Enter:* git clone https://github.com/trochford/Laminar
5. *Enter:* cd [the Laminar cloned directory]
6. *Enter:* .\laminar bootstrap

##### Powershell
* *To open a Powershell, use the Start menu Search entering:* Powershell
* *Right click on the* Windows Powershell *choice and select:* Run as administrator.

When Git is installing, choose the defaults provided.

VirtualBox will require enabling Hardware Virtualization support in the Bios settings of the host machine.

The Ubuntu image loaded will be Trusty64 from Hashicorp provided without a Desktop GUI.  The directory shared between Windows and the Ubuntu image is vagrantShare.   
* *Windows -* \<Laminar Dir\>\vagrantShare
* *Linux -* /vagrantShare

The vagrant user credentials are the defaults - User: vagrant ; Password: vagrant

The VirtualBox console GUI will be initiated during the running of the boot script.  A container running bash in the light-weight Phusion container (optimzed Ubuntu for Docker) will be running in a Docker container inside vagrant-dockerhost. Upon completion of the boot script, Docker can be tested with the Docker hello-world image:
* *Enter:* sudo docker run hello-world
or 
* *Enter:* sudo docker attach Phusion 

There will be two Vagrant providers running: one for Docker and one for the Ubuntu host.  To destroy both of them, two Vagrant destroy commands will be needed. In the Laminar directory:
* cd vagrantShare/myService 
* vagrant destroy *- will tear down the Docker provider "myService"*
* cd ..           *- up to vagrantShare*
* vagrant destroy *- will tear down "vagrant-dockerhost"* 

Tested on Windows 7 and Windows 10.

For sessions subsequent to the initial running of the boot script, the "vagrant-dockerhost" image can be started in the standard Vagrant fashion:
* *In a CMD shell, enter:* cd [...]\vagrantShare
* *Enter:* vagrant up

### Laminar Help

SYNOPSIS
    Dispatches a Laminar request to nine sub-commands.

    Sub-commands include:
        - bootstrap
        - up
        - kubeup
        - start
        - env
        - status
        - stop
        - down
        - remove


SYNTAX
    ...\laminar\laminar.ps1 [<CommonParameters>]


DESCRIPTION
    Laminar commands include:

     - bootstrap
       Download and install toolsets (listed below in Notes section) and wire together and activate them.

     - up
       Typically used after "laminar down" - restarts the toolsets reinstantiating as needed.

     - kubeup
       Starts just the minikube cluster with Laminar config parameters.  Alias for "minikube up".

     - start
       Typically used after "laminar stop" - restarts the toolsets.

     - env
       Sets the shell variable $myReg .

     - status
       Provides the status of Vagrant, Docker Machine and Minikube.

     - stop
       Deactivates the underlying Laminar toolsets - used to free up compute resources on your physical machine.

     - down
       Deactivated underlying Laminar toolsets and destroys any instances created. The Docker registry is stopped
       but contents are not removed.

     - remove
       Uninstalls the Laminar toolsets.

    Laminar should be run in a Powershell with Administrator privileges with ExecutionPolicy set to Unrestricted.


