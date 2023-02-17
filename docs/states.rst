Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``bibliogram``
^^^^^^^^^^^^^^
*Meta-state*.

This installs the bibliogram containers,
manages their configuration and starts their services.


``bibliogram.package``
^^^^^^^^^^^^^^^^^^^^^^
Installs the bibliogram containers only.
This includes creating systemd service units.


``bibliogram.config``
^^^^^^^^^^^^^^^^^^^^^
Manages the configuration of the bibliogram containers.
Has a dependency on `bibliogram.package`_.


``bibliogram.service``
^^^^^^^^^^^^^^^^^^^^^^
Starts the bibliogram container services
and enables them at boot time.
Has a dependency on `bibliogram.config`_.


``bibliogram.clean``
^^^^^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``bibliogram`` meta-state
in reverse order, i.e. stops the bibliogram services,
removes their configuration and then removes their containers.


``bibliogram.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the bibliogram containers
and the corresponding user account and service units.
Has a depency on `bibliogram.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``bibliogram.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the bibliogram containers
and has a dependency on `bibliogram.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``bibliogram.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops the bibliogram container services
and disables them at boot time.


