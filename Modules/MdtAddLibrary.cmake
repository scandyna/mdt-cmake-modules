# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtAddLibrary
# -------------
#
# Add a library
# ^^^^^^^^^^^^^
#
# .. command:: mdt_add_library
#
# Add a library::
#
#   mdt_add_library(
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
# TODO: document LIBRARY_NAME property
#
# Note: each dependency passed to ``PUBLIC_DEPENDENCIES`` and ``PRIVATE_DEPENDENCIES`` must be a target.
#
# Export headers will be genarated using :command:`generate_export_header()`:
#
# .. code-block:: cmake
#
#   generate_export_header(target)
#
#
# ``target`` is the one created above, of the form ``NameSpace_LibraryName``.
#
#
# Example:
#
# .. code-block:: cmake
#
#   # This should be set at the top level CMakeLists.txt
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
#
# Add a "Multi-Dev-Tools" library
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_add_mdt_library
#
# Add a "Multi-Dev-Tools" library::
#
#   mdt_add_mdt_library(
#     LIBRARY_NAME LibraryName
#     [PUBLIC_DEPENDENCIES <dependencies>]
#     [PRIVATE_DEPENDENCIES <dependencies>]
#     SOURCE_FILES
#       file1.cpp
#       file2.cpp
#   )
#
# This will create a target ``Mdt_LibraryName`` and a alias target ``Mdt::LibraryName`` .
#
# Will also set the ``LIBRARY_NAME`` target property to the value ``${LIBRARY_NAME}``.
#
# TODO: document export headers.
#
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
#   mdt_add_mdt_library(
#     LIBRARY_NAME ItemEditor
#     PUBLIC_DEPENDENCIES
#       Mdt::ItemModel Qt5::Widgets
#     SOURCE_FILES
#       Mdt/ItemEditor/SortSetupWidget.cpp
#   )
#
# This will create a target ``Mdt_ItemEditor`` and a alias target ``Mdt::ItemEditor`` .
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

include(GenerateExportHeader)


function(mdt_add_library)

  set(options)
  set(oneValueArgs NAMESPACE LIBRARY_NAME TARGET)
  set(multiValueArgs PUBLIC_DEPENDENCIES PRIVATE_DEPENDENCIES SOURCE_FILES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_NAMESPACE)
    message(FATAL_ERROR "mdt_add_library(): mandatory argument NAMESPACE missing")
  endif()
  if(NOT ARG_LIBRARY_NAME)
    message(FATAL_ERROR "mdt_add_library(): mandatory argument LIBRARY_NAME missing")
  endif()
  if(NOT ARG_SOURCE_FILES)
    message(FATAL_ERROR "mdt_add_library(): at least one source file expected")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_add_library(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(target ${ARG_NAMESPACE}_${ARG_LIBRARY_NAME})

  add_library(${target} ${ARG_SOURCE_FILES})
  add_library(${ARG_NAMESPACE}::${ARG_LIBRARY_NAME} ALIAS ${target})

  set(publicDependenciesArguments)
  if(ARG_PUBLIC_DEPENDENCIES)
    set(publicDependenciesArguments PUBLIC ${ARG_PUBLIC_DEPENDENCIES})
  endif()

  set(privateDependenciesArguments)
  if(ARG_PRIVATE_DEPENDENCIES)
    set(privateDependenciesArguments PRIVATE ${ARG_PRIVATE_DEPENDENCIES})
  endif()

  target_link_libraries(${target}
    ${publicDependenciesArguments}
    ${privateDependenciesArguments}
  )

  target_include_directories(${target}
    PUBLIC
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
      $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
  )

  generate_export_header(${target})

  set_target_properties(${target}
    PROPERTIES
      LIBRARY_NAME ${ARG_LIBRARY_NAME}
  )

endfunction()
