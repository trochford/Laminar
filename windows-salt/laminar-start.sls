{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR   =  pillar['LAMINAR_DIR'] %}
{% set HOME_PATH     =  pillar['HOME_PATH'] %}

#
# Re-start Vagrant; Start the Registry and Minikube cluster
#

    myService-start:
      cmd.run:
        - name: 'vagrant reload'
        - cwd: '{{ LAMINAR_DIR }}/vagrantShare/myService'
    dockerhost-start:
      cmd.run:
        - name: 'vagrant reload'
        - cwd: '{{ LAMINAR_DIR }}/vagrantShare'
    registry-start:
      cmd.run:
        - name: 'docker-machine start registry'
        - cwd: '{{ LAMINAR_DIR }}'
    minikube-start:
      cmd.script:
        - name: 'minikube.ps1 up'
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
      cmd.script:
        - name: 'minikube.ps1 status'
        - source: '{{ HOME_PATH }}/minikube/minikube.ps1'
        - cwd: "{{ HOME_PATH }}/minikube"
        - shell: powershell
        - env: 
          - ExecutionPolicy: ByPass
