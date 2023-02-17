# vim: ft=sls


{#-
    Stops the bibliogram container services
    and disables them at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as bibliogram with context %}

bibliogram service is dead:
  compose.dead:
    - name: {{ bibliogram.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if bibliogram.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ bibliogram.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if bibliogram.install.rootless %}
    - user: {{ bibliogram.lookup.user.name }}
{%- endif %}

bibliogram service is disabled:
  compose.disabled:
    - name: {{ bibliogram.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if bibliogram.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ bibliogram.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if bibliogram.install.rootless %}
    - user: {{ bibliogram.lookup.user.name }}
{%- endif %}
