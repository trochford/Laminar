{% set VAGRANT_DIR = "C:\HashiCorp\Vagrant" %}
vagrant:
 pkg:
  - installed
 cmd.run:
  - name: '{{ VAGRANT_DIR }}\bin\vagrant up --debug'
  - cwd: '{{ pillar['LAMINAR_DIR'] }}\vagrantShare\myService'
