{% set VAG_DOCK_IP   =  pillar['VAG_DOCK_IP'] %}

#
# Change the hosts file to reference the vagrant-dockerhost 
# [ Superceded by a more dynamic Vagrant plugin - auto_network ]
#
    vag_dock_host:
      host.present:
        - ip: {{ VAG_DOCK_IP }}
        - names:
          - myHost
