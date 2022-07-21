MdtTargetDependenciesHelpers
----------------------------

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

See also:
 - https://cmake.org/cmake/help/latest/prop_tgt/LINK_LIBRARIES.html
 - https://cmake.org/cmake/help/latest/command/target_link_libraries.html

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

As example, see an extract of the generated `Qt5-debug-x86_64-data.cmake`:

.. code-block:: cmake

  list(APPEND qt_COMPONENT_NAMES Qt5::Core Qt5::Gui Qt5::EventDispatcherSupport Qt5::FontDatabaseSupport Qt5::ThemeSupport Qt5::AccessibilitySupport Qt5::ServiceSupport Qt5::EdidSupport Qt5::XkbCommonSupport Qt5::XcbQpa Qt5::QXcbIntegrationPlugin Qt5::QSQLiteDriverPlugin Qt5::QPSQLDriverPlugin Qt5::QMySQLDriverPlugin Qt5::QODBCDriverPlugin Qt5::Network Qt5::Sql Qt5::Test Qt5::Widgets Qt5::PrintSupport Qt5::OpenGL Qt5::OpenGLExtensions Qt5::Concurrent Qt5::Xml Qt5::SerialPort)
  set(qt_Qt5_Core_OBJECTS_DEBUG )
  set(qt_PACKAGE_FOLDER_DEBUG "~/.conan/data/qt/5.15.2/_/_/package/1a2b3c4d5e6fetc")
  set(qt_Qt5_Core_LIB_DIRS_DEBUG "${qt_PACKAGE_FOLDER_DEBUG}/lib")
  set(qt_Qt5_Core_LIBS_DEBUG Qt5Core)
  set(qt_Qt5_Core_SYSTEM_LIBS_DEBUG )
  set(qt_Qt5_Core_DEPENDENCIES_DEBUG ZLIB::ZLIB pcre2::pcre2 double-conversion::double-conversion icu::icu zstd::libzstd_static)

Extract of the generated `Qt5Targets.cmake`:

.. code-block:: cmake

  # Create the targets for all the components
  foreach(_COMPONENT ${qt_COMPONENT_NAMES} )
      if(NOT TARGET ${_COMPONENT})
          add_library(${_COMPONENT} INTERFACE IMPORTED)
          conan_message(STATUS "Conan: Component target declared '${_COMPONENT}'")
      endif()
  endforeach()


Extract of the generated `Qt5-Target-debug.cmake`:

.. code-block:: cmake

  set(qt_Qt5_Core_LIB_TARGETS_DEBUG "")
  set(qt_Qt5_Core_NOT_USED_DEBUG "")
  set(qt_Qt5_Core_LIBS_FRAMEWORKS_DEPS_DEBUG ${qt_Qt5_Core_FRAMEWORKS_FOUND_DEBUG} ${qt_Qt5_Core_SYSTEM_LIBS_DEBUG} ${qt_Qt5_Core_DEPENDENCIES_DEBUG})
  conan_package_library_targets("${qt_Qt5_Core_LIBS_DEBUG}"     # libraries
                                "${qt_Qt5_Core_LIB_DIRS_DEBUG}" # package_libdir
                                "${qt_Qt5_Core_LIBS_FRAMEWORKS_DEPS_DEBUG}" # deps
                                qt_Qt5_Core_NOT_USED_DEBUG      # out_libraries 
                                qt_Qt5_Core_LIB_TARGETS_DEBUG   # out_libraries_target
                                "_DEBUG"                        # config_suffix
                                "qt_Qt5_Core")                  # package_name

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

If we substitute some variables:

.. code-block:: cmake

  function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target config_suffix package_name)
      set(_out_libraries "")
      set(_out_libraries_target "")
      set(_CONAN_ACTUAL_TARGETS "")

      find_library(CONAN_FOUND_LIBRARY NAMES Qt5Core PATHS "~/.conan/data/qt/5.15.2/_/_/package/1a2b3c4d5e6fetc/lib"
                  NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)

      list(APPEND _out_libraries "~/.conan/data/qt/5.15.2/_/_/package/1a2b3c4d5e6fetc/lib/libQt5Core.so")

      # Create a micro-target for each lib/a found
      add_library(CONAN_LIB::qt_Qt5_Core_DEBUG UNKNOWN IMPORTED)
      set_target_properties(CONAN_LIB::qt_Qt5_Core_DEBUG PROPERTIES IMPORTED_LOCATION "~/.conan/data/qt/5.15.2/_/_/package/1a2b3c4d5e6fetc/lib/libQt5Core.so")
      list(APPEND _CONAN_ACTUAL_TARGETS CONAN_LIB::qt_Qt5_Core_DEBUG)

      list(APPEND _out_libraries_target CONAN_LIB::qt_Qt5_Core_DEBUG)

      unset(CONAN_FOUND_LIBRARY CACHE)

      # Add all dependencies to all targets
      string(REPLACE " " ";" deps_list "ZLIB::ZLIB pcre2::pcre2 double-conversion::double-conversion icu::icu zstd::libzstd_static")

      set_property(TARGET CONAN_LIB::qt_Qt5_Core_DEBUG PROPERTY INTERFACE_LINK_LIBRARIES "ZLIB::ZLIB;pcre2::pcre2;double-conversion::double-conversion;icu::icu;zstd::libzstd_static" APPEND)

      set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
      set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
  endfunction()

Result:

.. code-block:: cmake

  add_library(Qt5::Core INTERFACE IMPORTED)

  add_library(CONAN_LIB::qt_Qt5_Core_DEBUG UNKNOWN IMPORTED)
  set_target_properties(CONAN_LIB::qt_Qt5_Core_DEBUG PROPERTIES IMPORTED_LOCATION "~/.conan/data/qt/5.15.2/_/_/package/1a2b3c4d5e6fetc/lib/libQt5Core.so")
  set_property(TARGET CONAN_LIB::qt_Qt5_Core_DEBUG PROPERTY INTERFACE_LINK_LIBRARIES "ZLIB::ZLIB;pcre2::pcre2;double-conversion::double-conversion;icu::icu;zstd::libzstd_static" APPEND)

  set(qt_Qt5_Core_LINK_LIBS_DEBUG CONAN_LIB::qt_Qt5_Core_DEBUG ZLIB::ZLIB pcre2::pcre2 double-conversion::double-conversion icu::icu zstd::libzstd_static)

  set_property(TARGET Qt5::Core PROPERTY INTERFACE_LINK_LIBRARIES
              $<$<CONFIG:Debug>:
              ${qt_Qt5_Core_LINK_LIBS_DEBUG}> APPEND)


As we can see, the Conan CMakeDeps generator creates Qt5::Core as a `INTERFACE` imported target.
Then, it creates CONAN_LIB::qt_Qt5_Core_DEBUG as a `UNKNOWN` imported target.
Finally, Qt5::Core depends on CONAN_LIB::qt_Qt5_Core_DEBUG when running the Debug build.

Here we have 2 difficulties to use those generated targets:
 - Qt5::Core is declared as a `INTERFACE` imported target
 - Its `INTERFACE_LINK_LIBRARIES` contains a generator expression

Using those informations seems not possible in a reasonable way.

Conan CMakeToolchain to the rescue
""""""""""""""""""""""""""""""""""

When using the Conan `CMakeToolchain` generator,
the generated `conan_toolchain.cmake` contains some interresting thing:

.. code-block:: cmake

  list(PREPEND CMAKE_LIBRARY_PATH
        "~/.conan/data/qt/5.15.2/_/_/package/1a2b3c4d5e6fetc/lib"
        "~/.conan/data/qt/5.15.2/_/_/package/1a2b3c4d5e6fetc/bin/archdatadir/plugins/sqldrivers"
        "~/.conan/data/qt/5.15.2/_/_/package/1a2b3c4d5e6fetc/bin/archdatadir/plugins/platforms"
        "~/.conan/data/zlib/1.2.12/_/_/package/zu1a2b3c4d5e6fetc/lib"
        "other paths"
  )

If we need to collect paths to shared libraries directories,
we should probably use `CMAKE_LIBRARY_PATH` for the Conan dependencies.
