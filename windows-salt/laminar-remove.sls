{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR =  pillar['LAMINAR_DIR'] %}
{% set HOME_PATH     =  pillar['HOME_PATH'] %}
  {% for version_mk, version_kc in [('v0.12.2', 'v1.4.0')] %}
    minikube_exe:
      file.absent:
        - name: '{{ HOME_PATH }}\minikube\minikube.exe'
    kubectl_exe: 
      file.absent:
        - name: '{{ HOME_PATH }}\minikube\kubectl.exe'
    minikube_dir:
      file.absent:
        - name: '{{ HOME_PATH }}\minikube'
    minikube_path:
      win_path.absent:
        - name: '{{ HOME_PATH }}\minikube'
  {% endfor %}
  {% for version_dtb, version_dvm in [('1.12.3', 'latest')] %}
    dockertb_uninstall:
      cmd.run:
        - name: 'unins000.exe /SILENT' 
        - cwd: '{{ PROGRAM_FILES }}\Docker Toolbox'
    dockertb_remove:
      file.absent:
        - name: '{{ HOME_PATH }}\dockertb\dockertb_install.exe'
    dvm_remove: 
      file.absent:
        - name: '{{ HOME_PATH }}\dockertb\dvm_install.ps1'
    dockertb_dir_remove:
      file.absent:
        - name: '{{ HOME_PATH }}\dockertb'
    dockertb_path:
      win_path.absent:
        - name: '{{ HOME_PATH }}\dockertb'
  {% endfor %}
  
    vagrant:
      pkg.removed
    virtualbox:
      pkg.removed
