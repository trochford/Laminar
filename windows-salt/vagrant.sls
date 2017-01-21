{% set VAGRANT_DIR = "C:\HashiCorp\Vagrant" %}
{% set PROGRAM_FILES =  pillar['PROGRAM_FILES'] %}
{% set LAMINAR_DIR =  pillar['LAMINAR_DIR'] %}
{% set HOME_PATH   =  pillar['HOME_PATH'] %}

#
# Install Vagrant, plugins; Clean old vagrant-dockerhost image; Start up Vagrant
#

  vagrant:
    pkg.installed
#   pkg.installed:
#     - version: 1.8.4
  vagrant_auto_network:
    cmd.run:
      - name: '{{ VAGRANT_DIR }}\bin\vagrant plugin install vagrant-auto_network' # --debug'
  vagrant_hostmanager:
    cmd.run:
      - name: '{{ VAGRANT_DIR }}\bin\vagrant plugin install vagrant-hostmanager' # --debug'
  clean_out_old_vagrant_dockerhost:
    file.absent:
      - name: '{{ HOME_PATH }}\VirtualBox VMs\vagrant-dockerhost'
  vagrant_up:
    cmd.run:
      - name: '{{ VAGRANT_DIR }}\bin\vagrant up' # --debug'
      - cwd: '{{ pillar['LAMINAR_DIR'] }}\vagrantShare\myService'
