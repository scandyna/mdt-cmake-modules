# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtTargetProperties
# -------------------
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
