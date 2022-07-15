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


Limitations
^^^^^^^^^^^

For the dependencies, only targets defined as shared libraries are supported.

See also https://cmake.org/cmake/help/latest/prop_tgt/TYPE.html

Any generator expression present in the `LINK_LIBRARIES` or `INTERFACE_LINK_LIBRARIES` property of a target
will be ignored.

See also https://cmake.org/cmake/help/latest/command/target_link_libraries.html

It can happen that some dependencies are missing.
This is because some targets are not yet defined
when calling :command:`mdt_collect_shared_libraries_targets_target_depends_on()`.

See also https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/4


Some details
^^^^^^^^^^^^

Using Conan with CMakeDeps
""""""""""""""""""""""""""

When using the Conan package manager with the CMakeDeps generator,
targets are defined, but they are not imported shared libraries targets.

As example, see generated `Qt5-debug-x86_64-data.cmake`:

.. code-block:: cmake

  set(qt_Qt5_Core_LIB_TARGETS_DEBUG "")
  set(qt_Qt5_Core_NOT_USED_DEBUG "")
  set(qt_Qt5_Core_LIBS_FRAMEWORKS_DEPS_DEBUG ${qt_Qt5_Core_FRAMEWORKS_FOUND_DEBUG} ${qt_Qt5_Core_SYSTEM_LIBS_DEBUG} ${qt_Qt5_Core_DEPENDENCIES_DEBUG})
  conan_package_library_targets("${qt_Qt5_Core_LIBS_DEBUG}"
                                "${qt_Qt5_Core_LIB_DIRS_DEBUG}"
                                "${qt_Qt5_Core_LIBS_FRAMEWORKS_DEPS_DEBUG}"
                                qt_Qt5_Core_NOT_USED_DEBUG
                                qt_Qt5_Core_LIB_TARGETS_DEBUG
                                "_DEBUG"
                                "qt_Qt5_Core")

  set(qt_Qt5_Core_LINK_LIBS_DEBUG ${qt_Qt5_Core_LIB_TARGETS_DEBUG} ${qt_Qt5_Core_LIBS_FRAMEWORKS_DEPS_DEBUG})

  set_property(TARGET Qt5::Core PROPERTY INTERFACE_LINK_LIBRARIES
              $<$<CONFIG:Debug>:${qt_Qt5_Core_OBJECTS_DEBUG}
              ${qt_Qt5_Core_LINK_LIBS_DEBUG}> APPEND)




`cmakedeps_macros.cmake`:

.. code-block:: cmake

  function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target config_suffix package_name)
      set(_out_libraries "")
      set(_out_libraries_target "")
      set(_CONAN_ACTUAL_TARGETS "")

      foreach(_LIBRARY_NAME ${libraries})
          find_library(CONAN_FOUND_LIBRARY NAMES ${_LIBRARY_NAME} PATHS ${package_libdir}
                      NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
          if(CONAN_FOUND_LIBRARY)
              conan_message(DEBUG "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
              list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})

              # Create a micro-target for each lib/a found
              # Allow only some characters for the target name
              string(REGEX REPLACE "[^A-Za-z0-9.+_-]" "_" _LIBRARY_NAME ${_LIBRARY_NAME})
              set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${config_suffix})
              if(NOT TARGET ${_LIB_NAME})
                  # Create a micro-target for each lib/a found
                  add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                  set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                  list(APPEND _CONAN_ACTUAL_TARGETS ${_LIB_NAME})
              else()
                  conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
              endif()
              list(APPEND _out_libraries_target ${_LIB_NAME})
              conan_message(DEBUG "Found: ${CONAN_FOUND_LIBRARY}")
          else()
              conan_message(FATAL_ERROR "Library '${_LIBRARY_NAME}' not found in package. If '${_LIBRARY_NAME}' is a system library, declare it with 'cpp_info.system_libs' property")
          endif()
          unset(CONAN_FOUND_LIBRARY CACHE)
      endforeach()

      # Add all dependencies to all targets
      string(REPLACE " " ";" deps_list "${deps}")
      foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
          set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${deps_list}" APPEND)
      endforeach()

      set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
      set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
  endfunction()



TODO: document



Internal, imports
Conan example

collect targets by deps

Define that supports only targets defined as SH libs
GENEX no 
Note: are there targets defined as genex ??
 or are genex link flags ?

