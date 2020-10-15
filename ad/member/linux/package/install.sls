# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as ad with context %}

{%- set dependencies = ad.pkg.dependencies %}

ad/member/linux/package/install/pkg.installed:
  pkg.installed:
    - pkgs: {{ dependencies | json }}
