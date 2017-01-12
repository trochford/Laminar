{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR   =  pillar['LAMINAR_DIR'] %}
{% set HOME_PATH     =  pillar['HOME_PATH'] %}
  {% for version_mk, version_kc in [('v0.12.2', 'v1.4.0')] %}
    minikube_dir:
      file.directory:
        - name: "{{ HOME_PATH }}/minikube"
        - makedirs: True
    minikube_exe:
      file.managed:
        - name: '{{ HOME_PATH }}\minikube\minikube.exe'
        - source: 'https://storage.googleapis.com/minikube/releases/{{ version_mk }}/minikube-windows-amd64.exe'
        - skip_verify: True
    kubectl_exe: 
      file.managed:
        - name: '{{ HOME_PATH }}\minikube\kubectl.exe'
        - source: 'http://storage.googleapis.com/kubernetes-release/release/{{ version_kc }}/bin/windows/amd64/kubectl.exe'
        - skip_verify: True
    minikube_path:
      win_path.exists:
        - name: '{{ HOME_PATH }}\minikube'
        - index: -1
    restart_minion_for_minikube:
      service.running:
        - name: salt-minion
        - watch:
          - win_path: minikube_path
    minikube-up:
      cmd.script:
        - name: 'genMinikubeUp.ps1'
        - source: '{{ LAMINAR_DIR }}/windows-salt/genMinikubeUp.ps1'
        - cwd: "{{ HOME_PATH }}/minikube"
        - shell: powershell
        - env: 
          - ExecutionPolicy: ByPass
  {% endfor %}
