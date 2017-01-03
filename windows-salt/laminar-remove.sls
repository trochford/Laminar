{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR =  pillar['LAMINAR_DIR'] %}
  {% for version_mk, version_kc in [('v0.12.2', 'v1.4.0')] %}
    minikube_exe:
      file.absent:
        - name: '{{ PROGRAM_FILES }}\minikube\minikube.exe'
    kubectl_exe: 
      file.absent:
        - name: '{{ PROGRAM_FILES }}\minikube\kubectl.exe'
    minikube_dir:
      file.absent:
        - name: '{{ PROGRAM_FILES }}\minikube'
    minikube_path:
      win_path.absent:
        - name: '{{ PROGRAM_FILES }}\minikube'
  {% endfor %}
  {% for version_dtb, version_dvm in [('1.12.3', 'latest')] %}
    dockertb_uninstall:
      cmd.run:
        - name: 'unins000.exe /SILENT' 
        - cwd: '{{ PROGRAM_FILES }}\Docker Toolbox'
    dockertb_remove:
      file.absent:
        - name: '{{ PROGRAM_FILES }}\dockertb\dockertb_install.exe'
    dvm_remove: 
      file.absent:
        - name: '{{ PROGRAM_FILES }}\dockertb\dvm_install.ps1'
    dockertb_dir_remove:
      file.absent:
        - name: '{{ PROGRAM_FILES }}\dockertb'
    dockertb_path:
      win_path.absent:
        - name: '{{ PROGRAM_FILES }}\dockertb'
  {% endfor %}
 vagrant:
   pkg:
    - removed
 virtualbox:
   pkg:
    - removed
