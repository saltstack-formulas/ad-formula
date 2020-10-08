# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import ad with context %}

ad-service-clean-service-dead:
  service.dead:
    - name: {{ ad.service.name }}
    - enable: False
