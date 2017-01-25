python-pip:
  pkg.installed:
    - name: python-pip
  pip.installed:
    - name: pip
    - upgrade: True

urllib-update:
  pip.installed:
    - name: urllib3==1.14
python-path:
   environ.setenv:
     - name: PYTHONPATH
     - value: /usr/local/lib/python2.7/dist-packages:/usr/lib/python2.7/dist-packages
     - update_minion: True
import-docker-key:  
  cmd.run:
    - name: apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    - creates: /etc/apt/sources.list.d/docker.list
/etc/apt/sources.list.d/docker.list:
  file.managed:
    - source: salt://docker.list

docker:  
  pkg.installed:
    - name: docker-engine
  service.running:  
    - name: docker
    - require:
      - pkg: docker-engine

compose-pip:
  pkg.installed:
    - name: python-pip
  pip.installed:
    - name: pip
    - upgrade: True

compose:
  pip.installed:
    - name: docker-compose

