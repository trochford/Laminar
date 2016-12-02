{% set VAGRANT_DIR = "C:\HashiCorp\Vagrant" %}
vagrant:
 pkg:
  - installed
 cmd.run:
  - name: '{{ VAGRANT_DIR }}\bin\vagrant.exe up'
  - cwd: '{{ pillar['LAMINAR_DIR'] }}\vagrantShare'
