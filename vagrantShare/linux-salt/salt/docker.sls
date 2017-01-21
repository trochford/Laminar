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

