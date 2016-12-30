{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR =  pillar['LAMINAR_DIR'] %}
{# % set PROGRAM_FILES = "C:\Program Files" % #}
  {% for version_dtb, version_dvm in [('1.12.3', 'latest')] %}
    dockertb_dir:
      file.directory:
        - name: '{{ PROGRAM_FILES }}\dockertb'
        - makedirs: True
    dockertb_download:
      file.managed:
        - name: '{{ PROGRAM_FILES }}\dockertb\dockertb_install.exe'
        - source: 'https://github.com/docker/toolbox/releases/download/v{{ version_dtb }}/DockerToolbox-{{ version_dtb }}.exe'
        - skip_verify: True
    dvm_download: 
      file.managed:
        - name: '{{ PROGRAM_FILES }}\dockertb\dvm_install.ps1'
        - source: 'https://download.getcarina.com/dvm/{{ version_dvm }}/install.ps1'
        - skip_verify: True
    dockertb_install:
      cmd.run:
        - name: 'dockertb_install.exe /SILENT /COMPONENTS=docker,dockermachine,dockercompose'
        - cwd: '{{ PROGRAM_FILES }}\dockertb'
    # Convert the powershell install script
    # to salt states so we are not dependent on the script itself which requires powershell v4
    dvm_install:
      cmd.run:
        - name: powershell.exe -ExecutionPolicy ByPass -File dvm_install.ps1
        - cwd: '{{ PROGRAM_FILES }}\dockertb'
        - shell: powershell
    dockertb_path:
      win_path.exists:
        - name: '{{ PROGRAM_FILES }}\dockertb'
        - index: -1
    restart_minion_for_dockertb:
      service.running:
        - name: salt-minion
        - watch:
          - win_path: dockertb_path
    create_registry:
      cmd.run:
        - name: 'docker-machine create -d virtualbox registry'
    registry_data:
      cmd.run:
        - name: 'docker-machine ssh registry "mkdir ~/data"'
    pull_registry_image:
      cmd.run:
        # Commented out line below is the bash analog of the invoked powershell line below that (up thru Invoke-Expression)...
        #- name: 'eval $("{{ PROGRAM_FILES }}\Docker` Toolbox\docker-machine.exe" env registry)' 
        - name: '& docker-machine env --shell=powershell registry | Invoke-Expression; docker-machine active; docker run -d -p 80:5000 --restart=always --name=registry -v /home/docker/data:/var/lib/registry registry:2'
        - shell: powershell
  {% endfor %}
