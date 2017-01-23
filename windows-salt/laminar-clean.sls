{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR =  pillar['LAMINAR_DIR'] %}
{% set HOME_PATH     =  pillar['HOME_PATH'] %}

#
# Clean up Vagrant vagrant-dockerhost and myService instances, 
# the Docker registry instance (but the user's saved images are retained)  
# and the minikube cluster
#

    myService-clean:
      cmd.run:
        - name: 'vagrant destroy -f'
        - cwd: '{{ LAMINAR_DIR }}/vagrantShare/myService'
    dockerhost-clean:
      cmd.run:
        - name: 'vagrant destroy -f'
        - cwd: '{{ LAMINAR_DIR }}/vagrantShare'
    registry-clean:
      cmd.run:
        - name: 'docker-machine rm registry -f'
        - cwd: '{{ LAMINAR_DIR }}'
    minikube-clean:
      cmd.script:
        - name: 'minikube.ps1 delete'
        - source: '{{ HOME_PATH }}/minikube/minikube.ps1'
        - cwd: "{{ HOME_PATH }}/minikube"
        - shell: powershell
        - env: 
          - ExecutionPolicy: ByPass
    x-global-status:
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
