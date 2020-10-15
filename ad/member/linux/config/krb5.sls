# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ ".member.linux.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as ad with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

ad/member/linux/config/krb5/file.managed:
  file.managed:
    - name: {{ ad.krb5.config }}
    - source: {{ files_switch(["krb5.conf.jinja", "krb5.conf"],
                 lookup="ad/member/linux/config/krb5/file.managed"
                 )
              }}
    - template: jinja
    - context:
        ad: {{ ad | json }}
    - require:
      - sls: {{ sls_package_install }}
