# vim: ft=sls

{#-
    Removes the bibliogram containers
    and the corresponding user account and service units.
    Has a depency on `bibliogram.config.clean`_.
    If ``remove_all_data_for_sure`` was set, also removes all data.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as bibliogram with context %}

include:
  - {{ sls_config_clean }}

{%- if bibliogram.install.autoupdate_service %}

Podman autoupdate service is disabled for Bibliogram:
{%-   if bibliogram.install.rootless %}
  compose.systemd_service_disabled:
    - user: {{ bibliogram.lookup.user.name }}
{%-   else %}
  service.disabled:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}

Bibliogram is absent:
  compose.removed:
    - name: {{ bibliogram.lookup.paths.compose }}
    - volumes: {{ bibliogram.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if bibliogram.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ bibliogram.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if bibliogram.install.rootless %}
    - user: {{ bibliogram.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

Bibliogram compose file is absent:
  file.absent:
    - name: {{ bibliogram.lookup.paths.compose }}
    - require:
      - Bibliogram is absent

{%- if bibliogram.install.podman_api %}

Bibliogram podman API is unavailable:
  compose.systemd_service_dead:
    - name: podman.socket
    - user: {{ bibliogram.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ bibliogram.lookup.user.name }}

Bibliogram podman API is disabled:
  compose.systemd_service_disabled:
    - name: podman.socket
    - user: {{ bibliogram.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ bibliogram.lookup.user.name }}
{%- endif %}

Bibliogram user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ bibliogram.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ bibliogram.lookup.user.name }}

Bibliogram user account is absent:
  user.absent:
    - name: {{ bibliogram.lookup.user.name }}
    - purge: {{ bibliogram.install.remove_all_data_for_sure }}
    - require:
      - Bibliogram is absent
    - retry:
        attempts: 5
        interval: 2

{%- if bibliogram.install.remove_all_data_for_sure %}

Bibliogram paths are absent:
  file.absent:
    - names:
      - {{ bibliogram.lookup.paths.base }}
    - require:
      - Bibliogram is absent
{%- endif %}
