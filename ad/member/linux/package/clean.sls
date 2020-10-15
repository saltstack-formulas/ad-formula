# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as ad with context %}

{%- set dependencies = ad.pkg.dependencies %}

{%- if ad | traverse("pkg:clean_purge_deps", False) | to_bool %}
ad/member/linux/package/clean/pkg.purged:
  pkg.purged:
    - pkgs: {{ dependencies | json }}
{%- else %}
{%-   do salt["log.warning"](
        tpldot
        ~ ": the 'ad:pkg:clean_purge_deps = False' configuration prevent the purge of the following packages:\n"
        ~ dependencies | yaml(False)
      ) %}
{%- endif %}
