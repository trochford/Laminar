{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR   =  pillar['LAMINAR_DIR'] %}
{% set HOME_PATH     =  pillar['HOME_PATH'] %}

#
# Halt Vagrant; Stop the Registry and Minikube cluster
#
 
    myService-down:
      cmd.run:
        - name: 'vagrant halt'
        - cwd: '{{ LAMINAR_DIR }}/vagrantShare/myService'
    dockerhost-down:
      cmd.run:
        - name: 'vagrant halt'
        - cwd: '{{ LAMINAR_DIR }}/vagrantShare'
    registry-down:
      cmd.run:
        - name: 'docker-machine stop registry'
        - cwd: '{{ LAMINAR_DIR }}'
    minikube-down:
      cmd.script:
        - name: 'minikube.ps1 stop'
        - source: '{{ HOME_PATH }}/minikube/minikube.ps1'
        - cwd: "{{ HOME_PATH }}/minikube"
        - shell: powershell
        - env: 
          - ExecutionPolicy: ByPass
    v-global-status:
      cmd.run:
        - name: 'vagrant global-status'
        - cwd: '{{ LAMINAR_DIR }}'
    y-docker-machine-status:
      cmd.run:
        - name: 'docker-machine ls'
        - cwd: '{{ LAMINAR_DIR }}'
    z-minikube-status:
      cmd.run:
        - name: 'minikube status'
        - cwd: '{{ LAMINAR_DIR }}'
