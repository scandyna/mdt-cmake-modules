MdtFindPathInList
-----------------

.. contents:: Summary
  :local:

Introduction
^^^^^^^^^^^^

Consider we have to add some path to ``CMAKE_MODULE_PATH`` if it does not already exists:

.. code-block:: cmake

  list(FIND CMAKE_MODULE_PATH "${MY_CMAKE_MODULE_PATH}" MY_CMAKE_MODULE_PATH_INDEX)
  if(${MY_CMAKE_MODULE_PATH_INDEX} LESS 0)
    list(APPEND CMAKE_MODULE_PATH "${MY_CMAKE_MODULE_PATH}")
  endif()

above code could work, but have good chances to finally add ``MY_CMAKE_MODULE_PATH``
to ``CMAKE_MODULE_PATH``, despite it allready exists.

Example of the content of ``CMAKE_MODULE_PATH``:

.. code-block:: cmake

  /home/me/opt/LibA/cmake/Modules;/home/me/opt/MyCMakeModules/cmake/Modules

If above code runs, and ``MY_CMAKE_MODULE_PATH`` contains ``/home/me/opt/MyCMakeModules/cmake/Modules``,
then all is fine.
But, if ``MY_CMAKE_MODULE_PATH`` contains ``/home/me/opt/MyCMakeModules/cmake/Modules/``,
``CMAKE_MODULE_PATH`` will ending with our path 2 times:

.. code-block:: cmake

  /home/me/opt/LibA/cmake/Modules;/home/me/opt/MyCMakeModules/cmake/Modules;/home/me/opt/MyCMakeModules/cmake/Modules/

And why ?
This is just due to a trailing slash.

We should not have to care about such detail,
and this is what this module tries to solve.

Usage
^^^^^

.. command:: mdt_find_path_in_list

Find a path in a list::

  mdt_find_path_in_list(<list> <path> <index-output-variable>)

Returns the index of the element specified in the list or -1 if it wasn't found.

Given path does not have to be a real or existing path.

Example:

.. code-block:: cmake

  mdt_find_path_in_list(CMAKE_MODULE_PATH "${MY_CMAKE_MODULE_PATH}" MY_CMAKE_MODULE_PATH_INDEX)
  if(${MY_CMAKE_MODULE_PATH_INDEX} LESS 0)
    list(APPEND CMAKE_MODULE_PATH "${MY_CMAKE_MODULE_PATH}")
  endif()


Usage for package config files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:command:`mdt_find_path_in_list()` could be used in a CMake package config file.
To avoid any function name clash, it should be named in a project specific way
(the reason is explained below).

As example, install cmake modules for a project, named ``MyLib``.

``MyLibConfig.cmake.in`` could look like this:

.. code-block:: cmake

  @PACKAGE_INIT@

  include("${CMAKE_CURRENT_LIST_DIR}/MyLibMdtFindPathInList.cmake")

  # Add to CMAKE_MODULE_PATH if not allready
  MyLib_mdt_find_path_in_list(CMAKE_MODULE_PATH "${PACKAGE_PREFIX_DIR}/@MY_CMAKE_MODULES_INSTALL_DIR@" MY_CMAKE_MODULES_PATH_INDEX)
  if(${MY_CMAKE_MODULES_PATH_INDEX} LESS 0)
    list(APPEND CMAKE_MODULE_PATH "${PACKAGE_PREFIX_DIR}/@MY_CMAKE_MODULES_INSTALL_DIR@")
  endif()

  unset(MY_CMAKE_MODULES_PATH_INDEX)

In the (main) ``CMakeLists.txt``, some steps have to be done.

First, generate the project specific ``MyLib_mdt_find_path_in_list()``:

.. code-block:: cmake

  set(MdtFindPathInList_FUNCTION_NAME MyLib_mdt_find_path_in_list)
  configure_file("${MDT_CMAKE_MODULES_PATH}/MdtFindPathInList.cmake.in" MyLibMdtFindPathInList.cmake @ONLY)

Then, generate ``MyLibConfig.cmake``:

.. code-block:: cmake

  include(CMakePackageConfigHelpers)
  configure_package_config_file(
    MyLibConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/MyLibConfig.cmake
    INSTALL_DESTINATION "lib/cmake"
    NO_SET_AND_CHECK_MACRO
    NO_CHECK_REQUIRED_COMPONENTS_MACRO
  )

Finally, install the package config files:

.. code-block:: cmake

  install(
    FILES
    "${CMAKE_CURRENT_BINARY_DIR}/MyLibConfig.cmake"
      "${CMAKE_BINARY_DIR}/MyLibMdtFindPathInList.cmake"
    DESTINATION "lib/cmake"
  )


TODO: also reference mdt_install_cmake_modules()

Deploy details
^^^^^^^^^^^^^^

:command:`mdt_find_path_in_list()` will be used in some CMake packages files we create.

In those packages files we don't want to depend on ``MdtCMakeModules``.

Example::

  ~/opt
    |-MdtCMakeModules
    |        |-Modules
    |           |-MdtFindPathInList.cmake
    |-LibA
    |   |-lib
    |      |-cmake
    |          |-LibA
    |          |   |-MdtFindPathInList.cmake
    |          |   |-LibAConfig.cmake
    |          |-Modules
    |-LibB
    |   |-lib
    |      |-cmake
    |          |-LibB
    |          |   |-MdtFindPathInList.cmake
    |          |   |-LibBConfig.cmake
    |          |-Modules


Example using ``MdtCMakeModules`` and ``LibA``

.. code-block:: cmake

  find_package(MdtCMakeModules REQUIRED)
  find_package(LibA REQUIRED)

  include(MdtFindPathInList)


First call to :command:`find_package()` will add ``~/opt/MdtCMakeModules/Modules`` to ``CMAKE_MODULE_PATH``.

Second call to :command:`find_package()` will include ``MdtFindPathInList.cmake`` from ``LibA``.

In the user project, we then include ``MdtFindPathInList``.
Question: which is implementation that will be available in the user project ?
Will it be the version from ``LibA`` or the one from ``MdtCMakeModules`` ?

Example using ``LibA`` and ``LibB``

.. code-block:: cmake

  find_package(LibA REQUIRED)
  find_package(LibB REQUIRED)

Question: which implementation of ``mdt_find_path_in_list()`` will be used in ``LibB`` ?
The one from ``LibA`` or the one from ``LibB`` ?

To be safe, we could do it this way::

  ~/opt
    |-MdtCMakeModules
    |        |-Modules
    |           |-MdtFindPathInList.cmake
    |-LibA
    |   |-lib
    |      |-cmake
    |          |-LibA
    |          |   |-LibAMdtFindPathInList.cmake
    |          |   |-LibAConfig.cmake
    |          |-Modules
    |-LibB
    |   |-lib
    |      |-cmake
    |          |-LibB
    |          |   |-LibBMdtFindPathInList.cmake
    |          |   |-LibBConfig.cmake
    |          |-Modules


As example, ``LibAMdtFindPathInList.cmake`` will provide :command:`LibA_mdt_find_path_in_list()`,
so we know that each part will use its proper implementation.

Why care which version is used ?
""""""""""""""""""""""""""""""""

If ``LibA`` was installed using a old version of ``MdtCMakeModules``,
which contains a bug in the implementation of ``LibA_mdt_find_path_in_list()``,
it will not impact all other parts.

It would be sufficient to rebuild and install ``LibA``
with a newer version of ``MdtCMakeModules``, that fixes the bug.
The newly generated ``LibAMdtFindPathInList.cmake`` will then also have a correct implementation of :command:`LibA_mdt_find_path_in_list()`.
