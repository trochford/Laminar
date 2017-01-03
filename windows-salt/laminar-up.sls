{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR =  pillar['LAMINAR_DIR'] %}
    myService-up:
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
    set_registry_ip:
      cmd.script:
        - name: 'saveRegIpInEnvVar.ps1'
        - source: '{{ LAMINAR_DIR }}/windows-salt/saveRegIpInEnvVar.ps1'
        - shell: powershell
        - cwd: {{ LAMINAR_DIR }}/windows-salt
        - env: 
          - ExecutionPolicy: ByPass
    reference-registry:
      cmd.script:
        - name: 'vagrantSshCall.ps1'
        - source: {{ LAMINAR_DIR }}\windows-salt\vagrantSshCall.ps1
        - shell: powershell
        - env: 
          - ExecutionPolicy: ByPass
        - cwd: {{ LAMINAR_DIR }}/windows-salt
    minikube-up:
      cmd.script:
        - name: 'minikube-up.ps1'
        - source: '{{ PROGRAM_FILES }}/minikube/minikube-up.ps1'
        - cwd: '{{ PROGRAM_FILES }}/minikube'
        - shell: 'powershell'
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
      cmd.run:
        - name: 'minikube status'
        - cwd: '{{ LAMINAR_DIR }}'
