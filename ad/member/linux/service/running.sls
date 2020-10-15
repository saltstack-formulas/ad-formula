# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_join = tplroot ~ ".member.linux.join" %}
{%- from tplroot ~ "/map.jinja" import mapdata as ad with context %}

include:
  - {{ sls_join }}

ad/member/linux/service/running/service.running/{{ ad.sssd.service }}:
  service.running:
    - name: {{ ad.sssd.service }}
    - enable: True
    - watch:
      - sls: {{ sls_join }}
