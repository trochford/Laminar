#{% set PROGRAM_FILES = "%ProgramFiles%" %}
{% set PROGRAM_FILES = "C:\Program%20Files" %}
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
        - name: '"{{ PROGRAM_FILES }}\dockertb\dockertb_install.exe" /SILENT /COMPONENTS=docker,dockermachine,dockercompose'
    dvm_install:
      cmd.run:
        - name: powershell.exe -ExecutionPolicy ByPass -File {{ PROGRAM_FILES }}\dockertb\dvm_install.ps1
    dockertb_path:
      win_path.exists:
        - name: '{{ PROGRAM_FILES }}\dockertb'
        - index: -1
    restart_minion_for_dockertb:
      service.running:
        - name: salt-minion
        - watch:
          - win_path: dockertb_path
  {% endfor %}
