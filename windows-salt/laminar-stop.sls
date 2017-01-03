{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR =  pillar['LAMINAR_DIR'] %}
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
      cmd.run:
        - name: '.\minikube stop'
        - cwd: '{{ PROGRAM_FILES }}/minikube'
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
