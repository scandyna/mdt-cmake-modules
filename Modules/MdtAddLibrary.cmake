# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtAddLibrary
# ---------------------
#
# TODO should create a page that explains the various target properties used in Mdt modules.
#
# Target various names
# ^^^^^^^^^^^^^^^^^^^^
#
# Add a library:
#
# .. code-block:: cmake
#
#   add_library(Led led.cpp)
#
# Here the name of the target is ``Led``.
# Such name is too generic, and it can clash with names from other project.
#
# It is better to prefix the project name to the library target name,
# for example: Qt_Led or Kf_Led or Mdt_Led:
#
# .. code-block:: cmake
#
#   add_library(Mdt_Led led.cpp)
#
# It is also good practice to add a alias target:
#
# .. code-block:: cmake
#
#   add_library(Mdt::Led ALIAS Mdt_Led)
#
# Here, ``Mdt::Led`` is a read only alias target to ``Mdt_Led``.
#
# In a other part of the same project, this alias should be used,
# enforcing that we not modify its properties:
#
# .. code-block:: cmake
#
#   add_executable(Mdt_Led_Test test.cpp)
#   target_link_libraries(Mdt_Led_Test Mdt::Led)
#
# Note: it is attempting to directly create Mdt::Led:
#
# .. code-block:: cmake
#
#   add_library(Mdt::Led led.cpp)
#
# CMake will not allow above add_library() statement.
#
# At some point, the project (composed of several targets) should be installed.
# It shouls also be taken ito account that the project can be installed in directories shared with other projects.
# This is typically the case for a system wide installation on Linux.
# In such case, the library so name should be unique::
#
#   libQtLed.so
#   libKfLed.so
#   libMdtLed.so
#
# The headers should also be installed into a project specific directory::
#
# /usr/include/Qt
# /usr/include/KF
# /usr/include/Mdt
#
# A other good practice is also to be able to install
# incompatible versions of the project on the same system without clashes::
#
# /usr/include/Qt4
# /usr/include/Qt5
# /usr/include/KF5
# /usr/include/Mdt0
# /usr/include/Mdt1
#
# For this purpose, the concept of ``INSTALL_NAMESPACE`` will be used:
#
# .. code-block:: cmake
#
#   install(TARGETS Mdt_Led EXPORT MdtLedTargets)
#   install(EXPORT MdtLedTargets NAMESPACE Mdt0:: FILE Mdt0LedTargets.cmake)
#
# Above code will generate and install the ``Mdt0LedTargets.cmake`` file.
# This file is ment to be used by the consumer of the project,
# and it will define a Imported Target:
#
# .. code-block:: cmake
#
#   # Content of Mdt0LedTargets.cmake
#   add_library(Mdt0::Mdt_Led SHARED IMPORTED)
#
# Notice the name of the imported target: ``Mdt0::Mdt_Led``.
# To avoid this, CMake provides a way to define a EXPORT_NAME property:
#
# .. code-block:: cmake
#
#   set_target_properties(Mdt_Led PROPERTIES EXPORT_NAME Led)
#
# The install/export becomes:
#
# .. code-block:: cmake
#
#   set_target_properties(Mdt_Led PROPERTIES EXPORT_NAME Led)
#   install(TARGETS Mdt_Led EXPORT MdtLedTargets)
#   install(EXPORT MdtLedTargets NAMESPACE Mdt0:: FILE Mdt0LedTargets.cmake)
#
# And the generated ``Mdt0LedTargets.cmake`` file will create the expected target:
#
# .. code-block:: cmake
#
#   # Content of Mdt0LedTargets.cmake
#   add_library(Mdt0::Led SHARED IMPORTED)
#
#
# Set RPATH properties
# ^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_set_target_install_rpath_property
#
# Set a ``INSTALL_RPATH`` property to a target::
#
#   mdt_set_target_install_rpath_property(
#     TARGET <target>
#     PATHS path1 [path2 ...]
#   )
#
# Assumes that each given path is relative.
# Will create a path of the form ``$ORIGIN/path``.
# If the path is ``.``, the resulting path will be ``$ORIGIN``.
#
# Examples:
#
# .. code-block:: cmake
#
#   mdt_set_target_install_rpath_property(
#     TARGET myLib
#     PATHS .
#   )
#   # myLib will have the INSTALL_RPATH property set to $ORIGIN
#
#   mdt_set_target_install_rpath_property(
#     TARGET myLib
#     PATHS . ../lib
#   )
#   # myLib will have the INSTALL_RPATH property set to $ORIGIN;$ORIGIN/../lib
#
#
# .. command:: mdt_set_target_default_library_rpath_property
#
# Set the RPATH property to a tagret reagrding some environment::
#
#   mdt_set_target_default_library_install_rpath_property(
#     TARGET <target>
#     [INSTALL_IS_UNIX_SYSTEM_WIDE <true>]
#   )
#
# NOTE: currently only UNIX is supported.
#
# Add a library
# ^^^^^^^^^^^^^
#
# Add a library::
#
#   mdt_add_library(
#     TARGET_NAME ?
#     NAMESPACE NameSpace
#     LIBRARY_NAME LibraryName
#     [PUBLIC_DEPENDENCIES <dependencies>]
#     [PRIVATE_DEPENDENCIES <dependencies>]
#     SOURCE_FILES
#       file1.cpp
#       file2.cpp
#   )
#
# This will create a target ``NameSpace_LibraryName`` and also a ALIAS target ``NameSpace::LibraryName`` .
# To define other properties to the target, use ``NameSpace_LibraryName``
# (CMake will trow errors if ``NameSpace::LibraryName`` is used).
#
# TODO: add export headers.
#
# TODO: add includes
#
# Note: each dependency passed to ``PUBLIC_DEPENDENCIES`` and ``PRIVATE_DEPENDENCIES`` must be a target.
#
# Example:
#
# .. code-block:: cmake
#
#   # This should be set at the top level CMakeLists.txt
#   include(GenerateExportHeader)
#   set(CMAKE_CXX_VISIBILITY_PRESET hidden)
#   set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)
#
#   mdt_add_library(
#     NAMESPACE Mdt
#     LIBRARY_NAME Led
#     PUBLIC_DEPENDENCIES Mdt::Core Qt5::Widgets
#     SOURCE_FILES
#       Mdt/Led.cpp
#   )
#
# This will create a target ``Mdt_Led`` and a alias target ``Mdt::Led`` .
#
# Add a "Multi-Dev-Tools" library::
#
#   mdt_add_mdt_library(
#     LIBRARY_NAME LibraryName
#     SOURCE_FILES
#       file1.cpp
#       file2.cpp
#   )
#
# This will create a target ``Mdt_LibraryName`` and a alias target ``Mdt::LibraryName`` .
#
# Install a library
# ^^^^^^^^^^^^^^^^^
#
# TODO Public and Private dependencies
#
# Install a library::
#
#   mdt_install_library(
#     TARGET <target>
#     RUNTIME_DESTINATION <dir>
#     LIBRARY_DESTINATION <dir>
#     ARCHIVE_DESTINATION <dir>
#     INCLUDES_DESTINATION <dir>
#     [INCLUDES_FILES_MATCHING_PATTERN <pattern>]
#     EXPORT_NAME <export-name>
#     EXPORT_NAMESPACE <export-namespace>
#     INSTALL_NAMESPACE <install-namespace>
#     [FIND_PACKAGE_PATHS path1 [path2 ...]]
#     [INSTALL_IS_UNIX_SYSTEM_WIDE <true>]
#     [VERSION <version>]
#     [SOVERSION <version>]
#     [VERSION_COMPATIBILITY <AnyNewerVersion|SameMajorVersion|ExactVersion>]
#     [RUNTIME_COMPONENT <component-name>]
#     [DEVELOPMENT_COMPONENT <component-name>]
#   )
#
# Install ``target`` using :command:`install(TARGETS)` to the various given destinations.
#
# Will also install the headers to the destination specified by ``INCLUDES_DESTINATION`` using :command:`install(DIRECTORY)`.
# The headers of all directories specified in the ``INTERFACE_INCLUDE_DIRECTORIES`` property of ``target`` will be installed.
# By default, à pattern matching ``*.h`` and ``*.hpp`` is used to filter which files must be copied.
# An alternate pattern can be passed as ``INCLUDES_FILES_MATCHING_PATTERN`` argument.
#
# The ``EXPORT_NAME`` and ``EXPORT_NAMESPACE`` will be set as properties to ``target``:
#
# .. code-block:: cmake
#
#   set_target_properties(${target} PROPERTIES EXPORT_NAME ${EXPORT_NAME} EXPORT_NAMESPACE ${EXPORT_NAMESPACE})
#
# As result, the export name of ``target`` (which will be the name of the IMPORTED target for the consumer of the package)
# will be ``${EXPORT_NAMESPACE}${EXPORT_NAME}``.
#
# Package config files will also be generated using :command:`install(TARGETS ... EXPORT ...)`.
# Those files will contain the definition of the imported target, named ``${EXPORT_NAMESPACE}${EXPORT_NAME}``.
# Those files will also be installed using :command:`install(EXPORT)`.
#
# A package config file named ``${INSTALL_NAMESPACE}${EXPORT_NAME}Config.cmake`` is also generated
# and installed using :command:`mdt_install_package_config_file()`.
#
# If a VERSION, and maybe a SOVERSION, is specified, it will be set as properties to ``target``:
#
# .. code-block:: cmake
#
#   # Only called if the VERSION argument is set
#   set_target_properties(${target} PROPERTIES VERSION ${VERSION})
#
#   # Only called if the SOVERSION argument is set
#   set_target_properties(${target} PROPERTIES SOVERSION ${SOVERSION})
#
# If a VERSION is specified, a package config version file named ``${INSTALL_NAMESPACE}${EXPORT_NAME}ConfigVersion.cmake``
# is also generated and installed using :command:`mdt_install_package_config_version_file()`.
#
# All generated package configuration files will be installed to ``${LIBRARY_DESTINATION}/cmake/${INSTALL_NAMESPACE}${EXPORT_NAME}``,
# which is a standard location for :command:`find_package()`.
#
# Some package informations will also be attached as properties of ``target``.
# Those properties will be reused when a other target, that depends on ``target``, is installed.
# For more informations of package properties, see :command:`mdt_install_package_config_file()`.
# The following package properties are defined:
#
#  - ``INTERFACE_FIND_PACKAGE_NAME``: set to ``${INSTALL_NAMESPACE}${EXPORT_NAME}``
#  - ``INTERFACE_FIND_PACKAGE_VERSION``: set to ``${VERSION}`` if ``VERSION`` argument was specified, otherwise it is not defined
#  - ``INTERFACE_FIND_PACKAGE_PATHS``: set to ``${FIND_PACKAGE_PATHS}`` if ``FIND_PACKAGE_PATHS`` argument was specified, otherwise it is not defined
#
# If ``INSTALL_IS_UNIX_SYSTEM_WIDE`` is not set, or set to ``FALSE``,
# the ``INSTALL_RPATH`` property will be attached to ``target`` using :command:`mdt_set_target_install_rpath_property()`.
# On UNIX, the ``INSTALL_RPATH`` value will be set to ``$ORIGIN``.
#
#
# Example:
#
# .. code-block:: cmake
#
#   add_library(Mdt_ItemEditor
#     sourc1.cpp sourc2.cpp ...
#   )
#
#   target_link_libraries(Mdt_ItemEditor
#     PUBLIC Mdt_ItemModel Qt5::Widgets
#   )
#
#   target_include_directories(Mdt_ItemEditor
#     PUBLIC
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
#     PRIVATE
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Impl>
#   )
#
#   # This should be set at the top level CMakeLists.txt
#   set(MDT_INSTALL_PACKAGE_NAME Mdt0)
#   include(GNUInstallDirs)
#   include(MdtInstallDirs)
#
#   mdt_install_library(
#     TARGET Mdt_ItemEditor
#     RUNTIME_DESTINATION ${CMAKE_INSTALL_BINDIR}
#     LIBRARY_DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     ARCHIVE_DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     INCLUDES_DESTINATION ${MDT_INSTALL_INCLUDEDIR}
#     EXPORT_NAME ItemEditor
#     EXPORT_NAMESPACE Mdt0::
#     INSTALL_NAMESPACE ${MDT_INSTALL_PACKAGE_NAME}
#     FIND_PACKAGE_PATHS ..
#     INSTALL_IS_UNIX_SYSTEM_WIDE ${MDT_INSTALL_IS_UNIX_SYSTEM_WIDE}
#     VERSION ${PROJECT_VERSION}
#     SOVERSION ${PROJECT_VERSION_MAJOR}
#     VERSION_COMPATIBILITY ExactVersion
#     RUNTIME_COMPONENT Mdt_ItemEditor_Runtime
#     DEVELOPMENT_COMPONENT Mdt_ItemEditor_Dev
#   )
#
# Notice the usage of ``MDT_INSTALL_PACKAGE_NAME`` and ``MDT_INSTALL_INCLUDEDIR``.
# Those variable are used and provided by the :module:`MdtInstallDirs`
# and will help install the includes in a appropriate subdirectory.
#
# On a non system wide Linux installation, the result will be::
#
#   ${CMAKE_INSTALL_PREFIX}
#     |-include
#     |   |-Mdt
#     |     |-ItemEditor
#     |       |-TableEditor.h
#     |       |-ItemEditorExport.h
#     |-lib
#       |-libMdt0ItemEditor.so
#       |-libMdt0ItemEditor.so.0
#       |-libMdt0ItemEditor.so.0.1.2
#       |-cmake
#         |-Mdt0ItemEditor
#           |-Mdt0ItemEditorTargets.cmake
#           |-Mdt0ItemEditorConfig.cmake
#           |-Mdt0ItemEditorConfigVersion.cmake
#
#
# Example of a system wide install on a Debian MultiArch (``CMAKE_INSTALL_PREFIX=/usr``)::
#
#   /usr
#     |-include
#     | |-x86_64-linux-gnu
#     |   |-Mdt0
#     |     |-Mdt
#     |       |-ItemEditor
#     |         |-TableEditor.h
#     |         |-ItemEditorExport.h
#     |-lib
#       |-x86_64-linux-gnu
#         |-libMdt0ItemEditor.so
#         |-libMdt0ItemEditor.so.0
#         |-libMdt0ItemEditor.so.0.1.2
#         |-cmake
#           |-Mdt0ItemEditor
#             |-Mdt0ItemEditorTargets.cmake
#             |-Mdt0ItemEditorConfig.cmake
#             |-Mdt0ItemEditorConfigVersion.cmake
#
#
#
# Once the library is installed, the user should be able to find it using CMake ``find_package()`` in its ``CMakeLists.txt``:
#
# .. code-block:: cmake
#
#   find_package(Mdt0ItemEditor 0.1.2 REQUIRED)
#   add_executable(myApp source.cpp)
#   target_link_libraries(myApp Mdt0::ItemEditor)
#
# To support the component syntax of :command:`find_package()`
# see :command:`mdt_install_namespace_package_config_file()`
# and :command:`mdt_install_namespace_package_config_version_file()`.
#
#
#
# TODO Several components will be created:
#  - Mdt_Led_Runtime: lib, cmake, ..................
#  - Mdt_Led_Dev: headers, cmake ?? ................
#
#
# Example of a system wide install of MdtLed on a Debian MultiArch (`CMAKE_INSTALL_PREFIX=/usr`)::
#
#   /usr/include/x86_64-linux-gnu/Mdt0/Mdt/Led.h
#   /usr/lib/x86_64-linux-gnu/libMdt0Led.so.0.x.y
#   /usr/lib/x86_64-linux-gnu/cmake/Mdt0/Mdt0Config.cmake
#   /usr/lib/x86_64-linux-gnu/cmake/Mdt0Led/Mdt0LedConfig.cmake
#
# The ``/usr/lib/x86_64-linux-gnu/cmake/Mdt0/Mdt0Config.cmake`` will be installed
# by the ``Mdt0`` package, which will be a dependency of ``Mdt0Led`` package
# (A distribution will to allow that the same file is handled by diffrent packages).
#
# Example of a stand-alone install on Linux (`CMAKE_INSTALL_PREFIX=~/opt/MdtLed`)::
#
#   ~/opt/MdtLed/include/Mdt/Led.h
#   ~/opt/MdtLed/lib/libMdt0Led.so.0.x.y
#   ~/opt/MdtLed/lib/cmake/Mdt0/Mdt0Config.cmake
#   ~/opt/MdtLed/lib/cmake/Mdt0Led/Mdt0LedConfig.cmake
#
# Here, ``~/opt/MdtLed/lib/cmake/Mdt0/Mdt0Config.cmake`` will be generated automatically,
# allowing the usage of the component syntax of ``find_package()`` .
#
# Install a "Multi-Dev-Tools" library
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# Usage::
#
#   mdt_install_mdt_library(
#     TARGET <target>
#   )
#
# Will export ``target`` as ``Mdt${PROJECT_VERSION_MAJOR}::LibraryName`` import target.
# The ``LibraryName`` is the target property ``LIBRARY_NAME`` that have been set by mdt_add_mdt_library() .
#
#
# Install a executable
# ^^^^^^^^^^^^^^^^^^^^
#
# Usage::
#
#   mdt_install_executable(
#     TARGET <target>
#     [INSTALL_IS_UNIX_SYSTEM_WIDE <true>]
#   )
#
# TODO copy dependencies ?
#
# TODO RPATH to $ORIGIN/../lib  if not INSTALL_IS_UNIX_SYSTEM_WIDE
#

function(mdt_set_target_install_rpath_property)

  set(options)
  set(oneValueArgs TARGET)
  set(multiValueArgs PATHS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_TARGET)
    message(FATAL_ERROR "mdt_set_target_install_rpath_property(): mandatory argument TARGET missing")
  endif()
  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_set_target_install_rpath_property(): ${ARG_TARGET} is not a valid target")
  endif()
  if(NOT ARG_PATHS)
    message(FATAL_ERROR "mdt_set_target_install_rpath_property(): PATHS argument requires at least 1 path")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_set_target_install_rpath_property(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(rpathPathList)
  foreach(path ${ARG_PATHS})
    set(rpathPath)
    if("${path}" STREQUAL ".")
      set(rpathPath "$ORIGIN")
    else()
      set(rpathPath "$ORIGIN/${path}")
    endif()
    list(APPEND rpathPathList "${rpathPath}")
  endforeach()

  set_target_properties(${ARG_TARGET} PROPERTIES INSTALL_RPATH "${rpathPathList}")

endfunction()
