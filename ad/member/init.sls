# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{%- set sls_join = "." ~ grains["kernel"] | lower %}

include:
  - {{ sls_join }}
