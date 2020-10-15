.. _readme:

ad-formula
==========

|img_travis| |img_sr| |img_pc|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/ad-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/ad-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release
.. |img_pc| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :alt: pre-commit
   :scale: 100%
   :target: https://github.com/pre-commit/pre-commit

A SaltStack formula that join GNU/Linux and Windows systems to an Active Directory.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please refer to:

- `how to configure the formula with map.jinja <map.jinja.rst>`_
- the ``pillar.example`` file
- the `Special notes`_ section


Contributing to this repo
-------------------------

Commit messages
^^^^^^^^^^^^^^^

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``. ::

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

Special notes
-------------

None

Available states
----------------

.. contents::
   :local:


``ad.join``
^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This state will join a system to an Active Directory with a login and password.

It depends on:

- `ad.member`_


``ad.member``
^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Take all steps required to make the system an Active Directory member.

It depends on states related to the `kernel`_, actually:

- `ad.member.linux`_
- `ad.member.windows`_


``ad.member.linux``
^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Join a GNU/Linux system to an Active Directory.

It depends on:

- `ad.member.linux.package`_
- `ad.member.linux.config`_
- `ad.member.linux.join`_
- `ad.member.linux.service`_


``ad.member.linux.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Manage packages required and conflicting with the join of the system to an Active Directory.

It depends on:

- `ad.member.linux.package.conflicts`_
- `ad.member.linux.package.install`_


``ad.member.linux.package.conflicts``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Remove any conflicting packages with the tools used to join the Active Directory.


``ad.member.linux.package.install``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install packages required to join the Active Directory.


``ad.member.linux.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Configure the system in preparation of the Active Directory join.

It depends on:

- `ad.member.linux.config.krb5`_
- `ad.member.linux.config.sssd`_


``ad.member.linux.config.krb5``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Configure ``krb5.conf`` for Active Directory.


``ad.member.linux.config.sssd``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Configure the `sssd`_ service for the ``ad.realm``, for example to enable or disable the `fully qualified names`_ and the pattern of home dirs fallback for users without the `unixHomeDirectory`_ LDAP attribute.

It `hooks`_ as `watch_in`_ to:

- `ad.member.linux.service.running`_

It depends on:

- `ad.member.linux.join`_


``ad.member.linux.join``
^^^^^^^^^^^^^^^^^^^^^^^^

Join a GNU/Linux system to an Active Directory using the `realm join`_ command.

It depends on:

- `ad.member.linux.config.krb5`_


``ad.member.linux.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Restart the `sssd`_ service.


``ad.member.linux.service.running``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Restart the `sssd`_ service.

It `watches`_:

- `ad.member.linux.join`_ to restart the service after joining the domain


``ad.member.windows``
^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Join a Microsoft Windows system to an Active Directory.

It depends on:

- `ad.member.windows.join`_


``ad.member.windows.join``
^^^^^^^^^^^^^^^^^^^^^^^^^^

Join a Microsoft Windows system to an Active Directory and restart the system if required.


``ad.leave``
^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Remove the system from an Active Directory with a login and password.

It depends on:

- `ad.member.clean`_


``ad.member.clean``
^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Take all steps required to make the system leave an Active Directory.

It depends on states related to the `kernel`_, actually:

- `ad.member.linux.clean`_
- `ad.member.windows.clean`_


``ad.member.linux.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Remove a GNU/Linux system from an Active Directory.

It depends on:

- `ad.member.linux.leave`_
- `ad.member.linux.config.clean`_
- `ad.member.linux.package.clean`_


``ad.member.linux.leave``
^^^^^^^^^^^^^^^^^^^^^^^^^

Remove a GNU/Linux system from an Active Directory using `realm leave`_.


``ad.member.linux.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Remove the configuration in place.


``ad.member.linux.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Remove required packages to join the Active Directory.


``ad.member.windows.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Remove a Microsoft Windows system from an Active Directory.

It depends on `ad.member.windows.leave`_

``ad.member.windows.leave``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Remove a Microsoft Windows system from an Active Directory and reboot the system if required.


Testing
-------

The testing requires a working Active Directory and is not actually automated.


.. _kernel: https://docs.saltstack.com/en/latest/topics/grains/index.html
.. _sssd: https://github.com/SSSD/sssd
.. _fully qualified names: https://sssd.io/docs/users/ad_provider.html#etcsssdsssdconf
.. _unixHomeDirectory: https://docs.microsoft.com/en-us/windows/win32/adschema/a-unixhomedirectory
.. _realm join:
.. _realm leave: https://www.freedesktop.org/software/realmd/
.. _hooks: https://docs.saltstack.com/en/latest/ref/states/requisites.html#the-in-version-of-requisites
.. _watches:
.. _watch_in: https://docs.saltstack.com/en/latest/ref/states/requisites.html#requisites-watch
