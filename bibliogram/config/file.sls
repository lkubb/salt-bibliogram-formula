# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as bibliogram with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Bibliogram environment files are managed:
  file.managed:
    - names:
      - {{ bibliogram.lookup.paths.config_bibliogram }}:
        - source: {{ files_switch(
                        ["bibliogram.env", "bibliogram.env.j2"],
                        config=bibliogram,
                        lookup="bibliogram environment file is managed",
                        indent_width=10,
                     )
                  }}
    - mode: '0640'
    - user: root
    - group: {{ bibliogram.lookup.user.name }}
    - makedirs: true
    - template: jinja
    - require:
      - user: {{ bibliogram.lookup.user.name }}
    - watch_in:
      - Bibliogram is installed
    - context:
        bibliogram: {{ bibliogram | json }}

Bibliogram config file is managed:
  file.managed:
    - name: {{ bibliogram.lookup.paths.config }}
    - source: {{ files_switch(
                    ["config.js", "config.js.j2"],
                    config=bibliogram,
                    lookup="Bibliogram config file is managed",
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ bibliogram.lookup.user.name }}
    - makedirs: True
    - template: jinja
    - require:
      - user: {{ bibliogram.lookup.user.name }}
    - watch_in:
      - Bibliogram is installed
    - context:
        bibliogram: {{ bibliogram | json }}
