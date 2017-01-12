{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR =  pillar['LAMINAR_DIR'] %}
  {% for version_mk, version_kc in [('v0.12.2', 'v1.4.0')] %}
    set_registry_ip:
      cmd.script:
        - name: 'saveRegIpInEnvVar.ps1'
        - source: '{{ LAMINAR_DIR }}/windows-salt/saveRegIpInEnvVar.ps1'
        - shell: powershell
        - cwd: {{ LAMINAR_DIR }}/windows-salt
        - env: 
          - ExecutionPolicy: ByPass
  {% endfor %}
