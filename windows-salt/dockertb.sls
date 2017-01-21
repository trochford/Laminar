{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set HOME_PATH     =  pillar['HOME_PATH'] %}
{% set LAMINAR_DIR   =  pillar['LAMINAR_DIR'] %}
{% set VBOX_DIR      =  pillar['VBOX_DIR'] %}
{% set MY_REG_PORT   =  86 %}

#
# Set up Docker Tool Box
# Create a local, private Docker registry
# 

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
    # To do: Convert the powershell install script
    # to salt states so we are not dependent on the script itself which requires powershell v4
    # So far dvm (Docker Version Manager) has not been needed.
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
          - cmd: dockertb_install
    create_registry:
      cmd.run:
        - name: 'docker-machine create -d virtualbox registry'
        - cwd: '{{ PROGRAM_FILES }}\Docker Toolbox'
    stop_registry:
      cmd.run:
        - name: 'docker-machine stop registry'
        - cwd: '{{ PROGRAM_FILES }}\Docker Toolbox'
    add_vbox_sharedfolder:
      cmd.run: 
        - name: '"{{ VBOX_DIR }}/VBoxManage.exe" sharedfolder add registry --name /var/lib/registry --hostpath {{ LAMINAR_DIR }}/registry --automount'
    start_registry:
      cmd.run:
        - name: 'docker-machine start registry'
        - cwd: '{{ PROGRAM_FILES }}\Docker Toolbox'
    registry_root:
      cmd.run:
        - name: 'docker-machine ssh registry "mkdir -p /var/lib/registry ; sudo mount -t vboxsf -o defaults,uid=`id -u docker`,gid=`id -g docker` /var/lib/registry /var/lib/registry"'
        - cwd: '{{ PROGRAM_FILES }}\Docker Toolbox'
    registry_root_bootlocal:
      cmd.run:
        - name: 'docker-machine ssh registry "echo \"mount -t vboxsf -o defaults,uid=`id -u docker`,gid=`id -g docker` /var/lib/registry /var/lib/registry\" | sudo tee -a /mnt/sda1/var/lib/boot2docker/bootlocal.sh > /dev/null; sudo chmod +x /mnt/sda1/var/lib/boot2docker/bootlocal.sh"'
        - cwd: '{{ PROGRAM_FILES }}\Docker Toolbox'
    registry_data:
      cmd.run:
        - name: 'docker-machine ssh registry "mkdir ~/data"'
        - cwd: '{{ PROGRAM_FILES }}\Docker Toolbox'
    pull_registry_image:
      cmd.run:
        # Replaced the "bash" line below with the powershell analog line below that (up thru Invoke-Expression)...
        #- name: 'eval $("location of docker-machine.exe" env registry)' 
        #- name: '& .\docker-machine env --shell=powershell registry | Invoke-Expression; .\docker-machine active; .\docker run -d -p {{ MY_REG_PORT}}:5000 --restart=always --name=registry -v /home/docker/data:/var/lib/registry registry:2'
        - name: '& .\docker-machine env --shell=powershell registry | Invoke-Expression; .\docker-machine active; .\docker run -d -p {{ MY_REG_PORT }}:5000 --restart=always --name=registry -v /var/lib/registry:/var/lib/registry registry:2'
        - cwd: '{{ PROGRAM_FILES }}\Docker Toolbox'
        - shell: powershell
  {% endfor %}
