MdtTargetProperties
-------------------

.. contents:: Summary
  :local:

Target various names
^^^^^^^^^^^^^^^^^^^^

Add a library:

.. code-block:: cmake

  add_library(Led led.cpp)

Here the name of the target is ``Led``.
Such name is too generic, and it can clash with names from other project.

It is better to prefix the project name to the library target name,
for example: Qt_Led or Kf_Led or Mdt_Led:

.. code-block:: cmake

  add_library(Mdt_Led led.cpp)

It is also good practice to add a alias target:

.. code-block:: cmake

  add_library(Mdt::Led ALIAS Mdt_Led)

Here, ``Mdt::Led`` is a read only alias target to ``Mdt_Led``.

In a other part of the same project, this alias should be used,
enforcing that we not modify its properties:

.. code-block:: cmake

  add_executable(Mdt_Led_Test test.cpp)
  target_link_libraries(Mdt_Led_Test Mdt::Led)

Note: it is attempting to directly create Mdt::Led:

.. code-block:: cmake

  add_library(Mdt::Led led.cpp)

CMake will not allow above add_library() statement.

At some point, the project (composed of several targets) should be installed.
It shouls also be taken ito account that the project can be installed in directories shared with other projects.
This is typically the case for a system wide installation on Linux.
In such case, the library so name should be unique::

  libQtLed.so
  libKfLed.so
  libMdtLed.so

The headers should also be installed into a project specific directory::

/usr/include/Qt
/usr/include/KF
/usr/include/Mdt

A other good practice is also to be able to install
incompatible versions of the project on the same system without clashes::

/usr/include/Qt4
/usr/include/Qt5
/usr/include/KF5
/usr/include/Mdt0
/usr/include/Mdt1

For this purpose, the concept of ``INSTALL_NAMESPACE`` will be used:

.. code-block:: cmake

  install(TARGETS Mdt_Led EXPORT MdtLedTargets)
  install(EXPORT MdtLedTargets NAMESPACE Mdt0:: FILE Mdt0LedTargets.cmake)

Above code will generate and install the ``Mdt0LedTargets.cmake`` file.
This file is ment to be used by the consumer of the project,
and it will define a Imported Target:

.. code-block:: cmake

  # Content of Mdt0LedTargets.cmake
  add_library(Mdt0::Mdt_Led SHARED IMPORTED)

Notice the name of the imported target: ``Mdt0::Mdt_Led``.
To avoid this, CMake provides a way to define a EXPORT_NAME property:

.. code-block:: cmake

  set_target_properties(Mdt_Led PROPERTIES EXPORT_NAME Led)

The install/export becomes:

.. code-block:: cmake

  set_target_properties(Mdt_Led PROPERTIES EXPORT_NAME Led)
  install(TARGETS Mdt_Led EXPORT MdtLedTargets)
  install(EXPORT MdtLedTargets NAMESPACE Mdt0:: FILE Mdt0LedTargets.cmake)

And the generated ``Mdt0LedTargets.cmake`` file will create the expected target:

.. code-block:: cmake

  # Content of Mdt0LedTargets.cmake
  add_library(Mdt0::Led SHARED IMPORTED)

Get some properties of a target
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. command:: mdt_target_is_shared_library

Check if a target is a shared library::

  mdt_target_is_shared_library(<out_var> TARGET <target>)

Example:

.. code-block:: cmake

  add_library(myLib myLib.cpp)

  mdt_target_is_shared_library(myLibIsSharedLibrary TARGET myLib)


In above code, ``myLibIsSharedLibrary`` will be true if ``myLib`` is a shared library.
Because it was not specified at the call to :command:`add_library()`,
it would depend on :variable:`BUILD_SHARED_LIBS`.

Internally, the ``TYPE`` property of the target is used to check if it is a shared library or not.

Get the file location of a target
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. command:: mdt_target_file_genex

Please note that this command is not reliable.
The workaround it tries to solve seems to be tricky to be done correctly.
For more informations, see this issue: https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/12

Get a generator expression to get the full path to `target`'s binary file::

  mdt_target_file_genex(<out_var> TARGET <target>)

A good way to get the full path to a target that is a binary
is to use the $<TARGET_FILE:tgt> generator expression.

As example, assume that we have to inspect a shared library in a test:

.. code-block:: cmake

  target_compile_definitions(someTest PRIVATE QT5_CORE_FILE_PATH="$<TARGET_FILE:Qt5::Core>")

Above example works, unless we use Conan with the
`CMakeDeps <https://docs.conan.io/en/latest/reference/conanfile/tools/cmake/cmakedeps.html>`_
generator.

This command will try to work around the Conan issue:

.. code-block:: cmake

  mdt_target_file_genex(qt5CoreFilePathGenex TARGET Qt5::Core)
  target_compile_definitions(someTest PRIVATE QT5_CORE_FILE_PATH="${qt5CoreFilePathGenex}")

Technical
"""""""""

When using some modern Conan CMake generators, like
`CMakeDeps <https://docs.conan.io/en/latest/reference/conanfile/tools/cmake/cmakedeps.html>`_ ,
the generated package config files do not create the proper IMPORTED targets.

As good example, the ``Qt5CoreConfig.cmake`` package config file shipped by Qt does this:

.. code-block:: cmake

  add_library(Qt5::Core SHARED IMPORTED)
  # Then attach every required properties to this target

On the other hand, Conan's CMakeDeps generator does something else.

Example of ``Qt5Targets.cmake``, that takes component names from ``Qt5-*-data.cmake``,
once resolved:

.. code-block:: cmake

  add_library(Qt5::Core INTERFACE IMPORTED)

In, for example, ``Qt5-Target-debug.cmake`` (which is included by ``Qt5Targets.cmake``):

.. code-block:: cmake

  set_property(TARGET Qt5::Core
               PROPERTY INTERFACE_LINK_LIBRARIES
               $<$<CONFIG:Debug>:${qt_Qt5_Core_OBJECTS_DEBUG}>
               $<$<CONFIG:Debug>:${qt_Qt5_Core_LIBRARIES_TARGETS}>
               APPEND)

Above will be resolved to something like:

.. code-block:: cmake

  set_property(TARGET Qt5::Core
               PROPERTY INTERFACE_LINK_LIBRARIES
               $<$<CONFIG:Debug>:>
               $<$<CONFIG:Debug>:CONAN_LIB::qt_Qt5_Core_Qt5Core_DEBUG>
               # Could also have the same for each config, like Release, etc...
               # On some generators, like MSVC, othe entries also here
               APPEND)

Here, ``CONAN_LIB::qt_Qt5_Core_Qt5Core_DEBUG`` is the "real" target, for the Debug config, with properties
like its import location, dependencies, etc...

We should end up with a generator expression like:

.. code-block:: cmake

  set(debugTargetGenex   $<$<CONFIG:Debug>:CONAN_LIB::qt_Qt5_Core_Qt5Core_DEBUG>)
  set(releaseTargetGenex $<$<CONFIG:Release>:CONAN_LIB::qt_Qt5_Core_Qt5Core_RELEASE>)
  set(targetGenex ${debugTargetGenex}${releaseTargetGenex})
  set(targetFileGenex $<TARGET_FILE:${targetGenex}>)

Here are some issues about this problem:
 - `Why does the CMake generator define INTERFACE IMPORTED targets rather than only IMPORTED? #8448 <https://github.com/conan-io/conan/issues/8448>`_
 - `how to enable TARGET_FILE cmake generator expression #13058 <https://github.com/conan-io/conan-center-index/issues/13058>`_

Set RPATH properties
^^^^^^^^^^^^^^^^^^^^

.. command:: mdt_set_target_install_rpath_property

Set a ``INSTALL_RPATH`` property to a target::

  mdt_set_target_install_rpath_property(
    TARGET <target>
    PATHS path1 [path2 ...]
  )

Assumes that each given path is relative.
Will create a path of the form ``$ORIGIN/path``.
If the path is ``.``, the resulting path will be ``$ORIGIN``.

Examples:

.. code-block:: cmake

  mdt_set_target_install_rpath_property(
    TARGET myLib
    PATHS .
  )
  # myLib will have the INSTALL_RPATH property set to $ORIGIN

  mdt_set_target_install_rpath_property(
    TARGET myApp
    PATHS . ../lib
  )
  # myApp will have the INSTALL_RPATH property set to $ORIGIN;$ORIGIN/../lib


.. command:: mdt_set_target_default_library_rpath_property

Set the RPATH property to a tagret reagrding some environment::

  mdt_set_target_default_library_install_rpath_property(
    TARGET <target>
    [INSTALL_IS_UNIX_SYSTEM_WIDE <true>]
  )

NOTE: currently only UNIX is supported.
