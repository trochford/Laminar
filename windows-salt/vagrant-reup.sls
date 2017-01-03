 cmd.run:
  - name: '{{ VAGRANT_DIR }}\bin\vagrant up --debug'
  - cwd: '{{ pillar['LAMINAR_DIR'] }}\vagrantShare\myService'
