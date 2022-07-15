sandbox
-------

.. contents:: Summary
  :local:

Related
^^^^^^^

This module is used by other ones.

See :command:`mdt_target_libraries_to_library_env_path()`
from :module:`MdtRuntimeEnvironment` module.

Functions
^^^^^^^^^

.. command:: mdt_collect_shared_libraries_targets_target_depends_on

Collect a list of targets, defined as shared libraries,
a given target depends on::

  mdt_collect_shared_libraries_targets_target_depends_on(<out_var> TARGET <target>)

Example
^^^^^^^

As example, we have 2 libraries and a application project.

The libraries, MdtItemModel and MdtItemEditor, are 2 different projects.

MdtItemModel library:

.. code-block:: cmake

  add_library(Mdt_ItemModel
    <source-files>
  )

  target_link_libraries(Mdt_ItemModel
    PUBLIC Qt5::Core
  )

  # Install details not listed here
  # Once the library is installed,
  # the Mdt0::ItemModel imported target will be defined


MdtItemEditor library:

.. code-block:: cmake

  add_library(Mdt_ItemEditor
    <source-files>
  )

  target_link_libraries(Mdt_ItemEditor
    PUBLIC Qt5::Widgets
  )

  # Install details not listed here
  # Once the library is installed,
  # the Mdt0::ItemEditor imported target will be defined


myApp is one project that defines a library and a executable.

myApp library:

.. code-block:: cmake

  add_library(myAppLibrary
    <source-files>
  )

  target_link_libraries(myAppLibrary
    PUBLIC Mdt0::ItemEditor
  )


myApp application:

.. code-block:: cmake

  add_executable(myApp
    <source-files>
  )

  target_link_libraries(myApp
    PRIVATE myAppLibrary
  )

  mdt_collect_shared_libraries_targets_target_depends_on(sharedLibrariesTargets TARGET myApp)

  # sharedLibrariesTargets should at least contain:
  # myAppLibrary Mdt0::ItemModel Mdt0::ItemEditor Qt5::Core Qt5::Widgets


mdt_collect_shared_libraries_dependecies_targets...


mdt_find_shared_libraries_targets_target_depends_on

mdt_collect_shared_libraries_targets_target_depends_on

Describe once installed

Internal, imports
Conan example

collect targets by deps

limitations

link to issue https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/4

Define that supports only targets defined as SH libs
GENEX no 
Note: are there targets defined as genex ??
 or are genex link flags ?

