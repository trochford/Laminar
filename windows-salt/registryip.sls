{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR =  pillar['LAMINAR_DIR'] %}

#
# Export the Registry address to the myReg environment varable
# 

    set_registry_ip:
      cmd.script:
        - name: 'saveRegIpInEnvVar.ps1'
        - source: '{{ LAMINAR_DIR }}/windows-salt/saveRegIpInEnvVar.ps1'
        - cwd: '/' # actually directory will be reset in the called script
        - args: '{{ LAMINAR_DIR }}'
        - shell: powershell
        - env: 
          - ExecutionPolicy: ByPass
