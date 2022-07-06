# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as bibliogram with context %}

include:
  - {{ sls_config_file }}

Bibliogram service is enabled:
  compose.enabled:
    - name: {{ bibliogram.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if bibliogram.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ bibliogram.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - Bibliogram is installed
{%- if bibliogram.install.rootless %}
    - user: {{ bibliogram.lookup.user.name }}
{%- endif %}

Bibliogram service is running:
  compose.running:
    - name: {{ bibliogram.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if bibliogram.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ bibliogram.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if bibliogram.install.rootless %}
    - user: {{ bibliogram.lookup.user.name }}
{%- endif %}
    - watch:
      - Bibliogram is installed
