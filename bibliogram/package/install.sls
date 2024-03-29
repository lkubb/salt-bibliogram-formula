# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as bibliogram with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

Bibliogram user account is present:
  user.present:
{%- for param, val in bibliogram.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ bibliogram.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false
  file.append:
    - names:
      - {{ bibliogram.lookup.user.home | path_join(".bashrc") }}:
        - text:
          - export XDG_RUNTIME_DIR=/run/user/$(id -u)
          - export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus

      - {{ bibliogram.lookup.user.home | path_join(".bash_profile") }}:
        - text: |
            if [ -f ~/.bashrc ]; then
              . ~/.bashrc
            fi

    - require:
      - user: {{ bibliogram.lookup.user.name }}

Bibliogram user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ bibliogram.lookup.user.name }}
    - enable: {{ bibliogram.install.rootless }}
    - require:
      - user: {{ bibliogram.lookup.user.name }}

Bibliogram paths are present:
  file.directory:
    - names:
      - {{ bibliogram.lookup.paths.base }}
    - user: {{ bibliogram.lookup.user.name }}
    - group: {{ bibliogram.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ bibliogram.lookup.user.name }}

{%- if bibliogram.install.podman_api %}

Bibliogram podman API is enabled:
  compose.systemd_service_enabled:
    - name: podman.socket
    - user: {{ bibliogram.lookup.user.name }}
    - require:
      - Bibliogram user session is initialized at boot

Bibliogram podman API is available:
  compose.systemd_service_running:
    - name: podman.socket
    - user: {{ bibliogram.lookup.user.name }}
    - require:
      - Bibliogram user session is initialized at boot
{%- endif %}

Bibliogram compose file is managed:
  file.managed:
    - name: {{ bibliogram.lookup.paths.compose }}
    - source: {{ files_switch(
                    ["docker-compose.yml", "docker-compose.yml.j2"],
                    config=bibliogram,
                    lookup="Bibliogram compose file is present",
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ bibliogram.lookup.rootgroup }}
    - makedirs: true
    - template: jinja
    - makedirs: true
    - context:
        bibliogram: {{ bibliogram | json }}

Bibliogram is installed:
  compose.installed:
    - name: {{ bibliogram.lookup.paths.compose }}
{%- for param, val in bibliogram.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in bibliogram.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ bibliogram.lookup.paths.compose }}
{%- if bibliogram.install.rootless %}
    - user: {{ bibliogram.lookup.user.name }}
    - require:
      - user: {{ bibliogram.lookup.user.name }}
{%- endif %}

{%- if bibliogram.install.autoupdate_service is not none %}

Podman autoupdate service is managed for Bibliogram:
{%-   if bibliogram.install.rootless %}
  compose.systemd_service_{{ "enabled" if bibliogram.install.autoupdate_service else "disabled" }}:
    - user: {{ bibliogram.lookup.user.name }}
{%-   else %}
  service.{{ "enabled" if bibliogram.install.autoupdate_service else "disabled" }}:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}
