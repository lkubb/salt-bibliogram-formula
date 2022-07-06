# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as bibliogram with context %}

include:
  - {{ sls_service_clean }}

# This does not lead to the containers/services being rebuilt
# and thus differs from the usual behavior
Bibliogram environment files are absent:
  file.absent:
    - names:
      - {{ bibliogram.lookup.paths.config_bibliogram }}
      - {{ bibliogram.lookup.paths.config }}
    - require:
      - sls: {{ sls_service_clean }}
