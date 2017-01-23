{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR =  pillar['LAMINAR_DIR'] %}

##
## Make sure Git's SSH is accessible to vagrant
## Export the registry address to the vagrant-dockerhost
##

    # makes SSH available for "vagrant ssh"
    git-user-bin-on-path:
      win_path.exists:
        - name: '{{ PROGRAM_FILES }}\git\usr\bin'
        - index: -1
    reference-registry:
      cmd.script:
        - name: 'vagrantSshCall.ps1'
        - source: '{{ LAMINAR_DIR }}/windows-salt/vagrantSshCall.ps1'
        - cwd: '/' # actually directory will be reset in the script to vagrantShare
        - args: '{{ LAMINAR_DIR }}'
        - shell: powershell
        - env: 
          - ExecutionPolicy: ByPass

