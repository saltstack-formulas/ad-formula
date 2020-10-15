# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{%- set sls_clean = "." ~ grains["kernel"] | lower ~ ".clean" %}

include:
  - {{ sls_clean }}
