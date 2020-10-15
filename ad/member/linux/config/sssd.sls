# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_join = tplroot ~ ".member.linux.join" %}
{%- set sls_sssd_service = tplroot ~ ".member.linux.service.running" %}
{%- from tplroot ~ "/map.jinja" import mapdata as ad with context %}

include:
  - {{ sls_join }}
  - {{ sls_sssd_service }}

{%- set sssd_config = ad.sssd.get('config', {}) %}

{%- if sssd_config %}
ad/member/linux/config/sssd/ini.options_present:
  ini.options_present:
    - name: {{ ad.sssd.config_file }}
    - sections:
        {{ "domain/" ~ ad.realm }}: {{ sssd_config }}
    - require:
      - sls: {{ sls_join }}
    - watch_in:
      - sls: {{ sls_sssd_service }}
{%- endif %}
