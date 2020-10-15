# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import mapdata as ad with context %}

ad/member/windows/clean/module.run/system.unjoin_domain:
  module.run:
    - name: system.unjoin_domain
    - domain: {{ ad.realm }}
    - username: {{ ad.join_username }}
    - password: {{ ad.join_password }}
    - disable: True
    - restart: False

# Manually reboot since we can't set a timeout on system.unjoin_domain
# Trigger only `onchanges` to the join since `only_on_pending_reboot`
# could be true for other reasons (like updates)
ad/member/windows/clean/system.reboot:
  system.reboot:
    - message: Leaving the AD realm {{ ad.realm }}
    - timeout: 10
    - in_seconds: True
    - only_on_pending_reboot: True
    - onchanges:
        - system: ad/member/windows/clean/module.run/system.unjoin_domain
