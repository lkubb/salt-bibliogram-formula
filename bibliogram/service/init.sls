# vim: ft=sls

{#-
    Starts the bibliogram container services
    and enables them at boot time.
    Has a dependency on `bibliogram.config`_.
#}

include:
  - .running
