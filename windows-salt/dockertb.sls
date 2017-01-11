{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set HOME_PATH     =  pillar['HOME_PATH'] %}
{% set LAMINAR_DIR   =  pillar['LAMINAR_DIR'] %}
{% set VBOX_DIR      =  pillar['VBOX_DIR'] %}
  {% for version_dtb, version_dvm in [('1.12.3', 'latest')] %}
    dockertb_dir:
      file.directory:
        - name: '{{ HOME_PATH }}\dockertb'
        - makedirs: True
    dockertb_download:
      file.managed:
        - name: '{{ HOME_PATH }}\dockertb\dockertb_install.exe'
        - source: 'https://github.com/docker/toolbox/releases/download/v{{ version_dtb }}/DockerToolbox-{{ version_dtb }}.exe'
        - skip_verify: True
    dvm_download: 
      file.managed:
        - name: '{{ HOME_PATH }}\dockertb\dvm_install.ps1'
        - source: 'https://download.getcarina.com/dvm/{{ version_dvm }}/install.ps1'
        - skip_verify: True
    dockertb_install:
      cmd.run:
        - name: 'dockertb_install.exe /SILENT /COMPONENTS=docker,dockermachine,dockercompose'
        - cwd: '{{ HOME_PATH }}\dockertb'
    # Convert the powershell install script
    # to salt states so we are not dependent on the script itself which requires powershell v4
    dvm_install:
      cmd.run:
        - name: powershell.exe -ExecutionPolicy ByPass -File dvm_install.ps1
        - cwd: '{{ HOME_PATH }}\dockertb'
        - shell: powershell
    dockertb_path:
      win_path.exists:
        - name: '{{ HOME_PATH }}\dockertb'
        - index: -1
    restart_minion_for_dockertb:
      service.running:
        - name: salt-minion
        - watch:
          - win_path: dockertb_path
    create_registry:
      cmd.run:
        - name: 'docker-machine create -d virtualbox registry'
    stop_registry:
      cmd.run:
        - name: 'docker-machine stop registry'
    add_vbox_sharedfolder:
      cmd.run: 
        - name: '"{{ VBOX_DIR }}/VBoxManage.exe" sharedfolder add registry --name /var/lib/registry --hostpath {{ LAMINAR_DIR }}/registry --automount'
    start_registry:
      cmd.run:
        - name: 'docker-machine start registry'
    registry_root:
      cmd.run:
        - name: 'docker-machine ssh registry "sudo chmod -R 777 /mnt/sda1/var/lib/boot2docker ; echo \"mkdir -p /var/lib/registry ; mount -t vboxsf -o defaults,uid=`id -u docker`,gid=`id -g docker` reg_data /var/lib/registry\" >> /mnt/sda1/var/lib/boot2docker/bootlocal.sh"'
    registry_data:
      cmd.run:
        - name: 'docker-machine ssh registry "mkdir ~/data"'
    pull_registry_image:
      cmd.run:
        # Replaced the "bash" line below is the powershell analog line below that (up thru Invoke-Expression)...
        #- name: 'eval $("location of docker-machine.exe" env registry)' 
        - name: '& docker-machine env --shell=powershell registry | Invoke-Expression; docker-machine active; docker run -d -p 80:5000 --restart=always --name=registry -v /home/docker/data:/var/lib/registry registry:2'
        - shell: powershell
  {% endfor %}
