# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as ad with context %}

{%- set conflicts = ad.pkg.conflicts %}

ad/member/linux/package/conflicts/pkg.purged:
  pkg.purged:
    - pkgs: {{ conflicts | json }}
