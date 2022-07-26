# -*- coding: utf-8 -*-
# vim: ft=yaml
---
bibliogram:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    compose:
      create_pod: null
      pod_args: null
      project_name: bibliogram
      remove_orphans: true
      service:
        container_prefix: null
        ephemeral: true
        pod_prefix: null
        restart_policy: on-failure
        restart_sec: 2
        separator: null
        stop_timeout: null
    paths:
      base: /opt/containers/bibliogram
      compose: docker-compose.yml
      config_bibliogram: bibliogram.env
      config: config.js
      db: db
    user:
      groups: []
      home: null
      name: bibliogram
      shell: /usr/sbin/nologin
      uid: null
      gid: null
    containers:
      bibliogram:
        image: quay.io/pussthecatorg/bibliogram:latest
  install:
    rootless: true
    remove_all_data_for_sure: false
  config:
    port: 10407
    tor:
      enabled: false
    website_origin: http://localhost:10407

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://bibliogram/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   bibliogram-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      Bibliogram environment file is managed:
      - bibliogram.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
