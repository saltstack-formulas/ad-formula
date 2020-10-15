# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_krb5 = tplroot ~ ".member.linux.config.krb5" %}
{%- from tplroot ~ "/map.jinja" import mapdata as ad with context %}

include:
  - {{ sls_config_krb5 }}

{%- set test_join_cmd = "realm discover " ~ ad.realm | upper ~ " | grep -qs 'configured: kerberos-member'" %}

{#- Do not use password on command lines #}
{#- Serialize `test_join_cmd` to avoid `mapping values are not allowed in this context` #}
ad/member/linux/join/passwd-file/file.managed:
  file.managed:
    - name: {{ ad.krb5.kinit_password_tmpfile }}
    - contents: {{ ad.join_password }}
    - contents_newline: False
    - unless: {{ test_join_cmd | json }}
    - require:
      - sls: {{ sls_config_krb5 }}

ad/member/linux/join/kinit/cmd.run:
  cmd.run:
    - name: kinit --password-file={{ ad.krb5.kinit_password_tmpfile }} {{ ad.join_username }}
    - onchanges:
      - file: ad/member/linux/join/passwd-file/file.managed

ad/member/linux/join/join/cmd.run:
  cmd.run:
    - name: realm -v join --unattended "{{ ad.realm }}"
    - onchanges:
      - cmd: ad/member/linux/join/kinit/cmd.run

ad/member/linux/join/kdestroy/cmd.run:
  cmd.run:
    - name: kdestroy
    - onchanges:
      - cmd: ad/member/linux/join/kinit/cmd.run

{#- Don't leak password #}
ad/member/linux/join/passwd-file/file.absent:
  file.absent:
    - name: {{ ad.krb5.kinit_password_tmpfile }}
