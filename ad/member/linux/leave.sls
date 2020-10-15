# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as ad with context %}

{%- set test_join_cmd = "realm discover " ~ ad.realm | upper ~ " | grep -qs 'configured: kerberos-member'" %}

{#- Serialize `test_join_cmd` to avoid `mapping values are not allowed in this context` #}
ad/member/linux/leave/cmd.run:
  cmd.run:
    - name: realm leave {{ ad.realm }}
    - onlyif: {{ test_join_cmd | json }}
