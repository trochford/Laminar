FROM ubuntu:14.04
 
# Install dev tools: jdk, git etc...
RUN apt-get update
RUN apt-get install -y openjdk-7-jdk git wget
 
# jdk7 is the default jdk
RUN ln -fs /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java /etc/alternatives/java
 
WORKDIR /vagrantShare

 
CMD ["bash"]
