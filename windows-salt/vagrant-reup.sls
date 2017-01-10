{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR =  pillar['LAMINAR_DIR'] %}
{% set VAGRANT_DIR = "C:\HashiCorp\Vagrant" %}
vagrant-reup:
 cmd.run:
  - name: '{{ VAGRANT_DIR }}\bin\vagrant up --debug'
  - cwd: '{{ pillar['LAMINAR_DIR'] }}\vagrantShare\myService'
