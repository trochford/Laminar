{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR   =  pillar['LAMINAR_DIR'] %}
{% set HOME_PATH     =  pillar['HOME_PATH'] %}

#
# Clean out prior vagrant-dockerhost VM and rebuild vagrant-dockerhost
# Create and start registry and export registry address shell variables
# Create the minikube cluster
#

    myService-up:
      file.absent:
        - name: '{{ HOME_PATH }}\VirtualBox VMs\vagrant-dockerhost'
      cmd.run:
        - name: 'vagrant up'
        - cwd: '{{ LAMINAR_DIR }}/vagrantShare/myService'
    registry-create:
      cmd.run:
        - name: 'docker-machine create -d virtualbox registry'
        - cwd: '{{ LAMINAR_DIR }}'
    registry-up:
      cmd.run:
        - name: 'docker-machine start registry'
        - cwd: '{{ LAMINAR_DIR }}'
    gen-registry-certs:
      cmd.run:
        - name: 'docker-machine regenerate-certs -f registry'
        - cwd: '{{ LAMINAR_DIR }}'
        - onfail:
          - cmd: registry-up
    set_registry_ip:
      cmd.script:
        - name: 'saveRegIpInEnvVar.ps1'
        - source: '{{ LAMINAR_DIR }}/windows-salt/saveRegIpInEnvVar.ps1'
        - cwd: '/' # actually directory will be reset in the called script
        - args: '{{ LAMINAR_DIR }}'
        - shell: powershell
        - env: 
          - ExecutionPolicy: ByPass
    reference-registry:
      cmd.script:
        - name: 'vagrantSshCall.ps1'
        - source: '{{ LAMINAR_DIR }}/windows-salt/vagrantSshCall.ps1'
        - cwd: '/' # actually directory will be reset in the script to vagrantShare
        - args: '{{ LAMINAR_DIR }}'
        - shell: powershell
        - env: 
          - ExecutionPolicy: ByPass
    minikube-up:
      cmd.script:
        - name: 'minikube.ps1 up'
        - source: '{{ HOME_PATH }}/minikube/minikube.ps1'
        - cwd: "{{ HOME_PATH }}/minikube"
        - shell: powershell
        - env: 
          - ExecutionPolicy: ByPass
    myService-re-up:
      # myService has not started consistently so re-up to ensure myService is started
      cmd.run:
        - name: 'vagrant up'
        - cwd: '{{ LAMINAR_DIR }}/vagrantShare/myService'
    v-global-status:
      cmd.run:
        - name: 'vagrant global-status'
        - cwd: '{{ LAMINAR_DIR }}'
    y-docker-machine-status:
      cmd.run:
        - name: 'docker-machine ls'
        - cwd: '{{ LAMINAR_DIR }}'
    z-minikube-status:
      cmd.script:
        - name: 'minikube.ps1 status'
        - source: '{{ HOME_PATH }}/minikube/minikube.ps1'
        - cwd: "{{ HOME_PATH }}/minikube"
        - shell: powershell
        - env: 
          - ExecutionPolicy: ByPass
