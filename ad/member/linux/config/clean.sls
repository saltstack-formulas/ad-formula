# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as ad with context %}

ad/member/linux/config/clean/krb5/file.absent:
  file.absent:
    - name: {{ ad.krb5.config }}
