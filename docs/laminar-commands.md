

## Laminar Commands

Laminar commands fall into two categories - more complicated commands where the activity is logged and presented after execution in the terminal browser "less" versus simple commands with no logging.  The simple commands are: *status*, *kubeup* and *env*.  

Learning a few basic "less" commands is a worthwhile investment.  Fortunately, the commands are very similar to the familiar "vi" commands.
A quick list of typical commands:

* *g* - top of the file
* *G* - bottom of the file
* */* - search for the string following the slash
* *&* - search for string following the ampersand and show only lines containing the string
* *q* - exit "less"

All tools assembled by Laminar can be called directly as in stand-alone usage. Only Minikube has been "adjusted" - adding a command *up* to the standard Minikube command set. The *up* command translates into Minikube *start* but with Laminar configuration parameters set in the command line invocation.

The higher level Laminar commands ensure configuration alignment between tools and on occasion will conditionally perform various clean-up task when a tools command fails.  Essentially these clean-up tasks automate remediation steps recommended in the many "how-to" articles describing the stand-alone tool usage.

### bootstrap

Bootstrap starts by installing VirtualBox and Vagrant and then performs the *vagrant up* listed below.  Then Docker Toolbox is installed along with the convenience tool dvm (Docker Version Manager).  The dvm installation is contingent on have Powershell 4. The docker-machine create registry below is performed and the VirtualBox host mounts the persistent registry volume and the registry container is informed of that volume.  The standard registry image is then pulled. The $myReg variables are set in Windows and vagrant-dockerhost. Minikube, Kubectl and Kompose are installed. A minikube command wrappers is generated and the minikube up command listed below is performed.

 Tool  | Command   | Comment  
--|---|--
vagrant  | up   |  The example container myService and vagrant-dockerhost after cleaning up any old vagrant-dockerhost VirtualBox VM.
docker-machine  | create   |  Create the registry
minikube  | up (start)   |  The local Kubernetes cluster.

### up


 Tool  | Command   | Comment  
--|---|--
vagrant  | up   |  The example container myService and vagrant-dockerhost after cleaning up any old vagrant-dockerhost VirtualBox VM.
docker-machine  | create & start   |  Create & start the registry; Regenerate certs if necessary.
minikube  | up (start)   |  The local Kubernetes cluster.

### kubeup
The *kubeup* command performes a *minikube up* command.  It is provided largely for documentation.

### start

 Tool  | Command   | Comment  
--|---|--
vagrant  | reload   |   The example container *myService* and vagrant-dockerhost.
docker-machine  | start   |  The registry
minikube  | up (start)  |  The local Kubernetes cluster.

### env
The *env* command sets the Windows shell variable $myReg to the IP/Port of the registry.

### status
The *status* command runs:
* vagrant global-status
* docker-machine ls
* minikube status
as a quick status report.

### stop

 Tool  | Command   | Comment  
--|---|--
vagrant  | halt   | The example container myService and vagrant-dockerhost.  
docker-machine  | stop  | The registry.  
minikube  | stop   |  The local Kubernetes cluster.

### down
The *down* command starts by performing *Laminar stop* and then the following clean-up action are performed.

 Tool  | Command   | Comment  
--|---|--
vagrant  | destroy   | The example container myService and vagrant-dockerhost.  
docker-machine  | rm   | The registry.  Recall images pushed to the registry will be persisted in the directory [Laminar Dir]/vagrantShare/registry across registry container lifecycles.  
minikube  | delete   |  The local Kubernetes cluster.

### remove
The *remove* command performs the *Laminar down* tool commands listed below followed by uninstalling Minikube, Kubectl, Kompose, Docker Toolbox, Vagrant and Virtualbox.

 Tool  | Command   | Comment  
--|---|--
vagrant  | halt & destroy   |  The example container "myService" and vagrant-dockerhost.
docker-machine  | stop & rm   |  The registry
minikube  | stop & delete   |  The local Kubernetes cluster.

[Back to Overview](index.md)
