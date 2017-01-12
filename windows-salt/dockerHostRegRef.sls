{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR =  pillar['LAMINAR_DIR'] %}

##
## States
##

    # makes SSH available for "vagrant ssh"
    git-user-bin-on-path:
      win_path.exists:
        - name: '{{ PROGRAM_FILES }}\git\usr\bin'
        - index: -1
    reference-registry:
      cmd.script:
        - name: 'vagrantSshCall.ps1'
        - source: {{ LAMINAR_DIR }}\windows-salt\vagrantSshCall.ps1
        - shell: powershell
        - env: 
          - ExecutionPolicy: ByPass
        - cwd: {{ LAMINAR_DIR }}/windows-salt

