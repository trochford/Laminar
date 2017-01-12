{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR =  pillar['LAMINAR_DIR'] %}
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
      cmd.run:
        - name: 'minikube delete'
        - cwd: '{{ LAMINAR_DIR }}'
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
