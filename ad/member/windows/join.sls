# -*- mode: salt; coding: utf-8 -*-
# -*- coding: utf-8 -*-

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import mapdata as ad with context %}

ad/member/windows/join/system.join_domain:
  system.join_domain:
    - name: {{ ad.realm }}
    - username: {{ ad.join_username }}
    - password: {{ ad.join_password }}
    - restart: False

# Manually reboot since we can't set a timeout on system.join_domain
# Trigger only `onchanges` to the join since `only_on_pending_reboot`
# could be true for other reasons (like updates)
ad/member/windows/join/system.reboot:
  system.reboot:
    - message: Joining the AD realm {{ ad.realm }}
    - timeout: 10
    - in_seconds: True
    - only_on_pending_reboot: True
    - onchanges:
        - system: ad/member/windows/join/system.join_domain
