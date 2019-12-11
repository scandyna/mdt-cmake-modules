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
