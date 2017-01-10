{% set VAGRANT_DIR = "C:\HashiCorp\Vagrant" %}
{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR =  pillar['LAMINAR_DIR'] %}
{% set HOME_PATH   =  pillar['HOME_PATH'] %}

  vagrant:
    pkg:
      - installed
    file.absent:
      - name: '{{ HOME_PATH }}\VirtualBox VMs\vagrant-dockerhost'
    cmd.run:
      - name: '{{ VAGRANT_DIR }}\bin\vagrant up --debug'
      - cwd: '{{ pillar['LAMINAR_DIR'] }}\vagrantShare\myService'
