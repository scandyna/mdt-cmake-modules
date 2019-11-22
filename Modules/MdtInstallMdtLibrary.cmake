# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtInstallMdtLibrary
# --------------------
#
# Install a "Multi-Dev-Tools" library
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_install_mdt_library
#
# Usage::
#
#   mdt_install_mdt_library(
#     TARGET <target>
#     VERSION_COMPATIBILITY <AnyNewerVersion|SameMajorVersion|ExactVersion>
#   )
#
# This is similar to using :command:`mdt_install_library()` like this:
#
# .. code-block:: cmake
#
#   include(MdtInstallLibrary)
#
#   set(MDT_INSTALL_PACKAGE_NAME Mdt${PROJECT_VERSION_MAJOR})
#   include(GNUInstallDirs)
#   include(MdtInstallDirs)
#
#   get_target_property(libraryName ${TARGET} LIBRARY_NAME)
#
#   mdt_install_library(
#     TARGET ${TARGET}
#     RUNTIME_DESTINATION ${CMAKE_INSTALL_BINDIR}
#     LIBRARY_DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     ARCHIVE_DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     INCLUDES_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/"
#     INCLUDES_FILE_WITHOUT_EXTENSION
#     ADDITIONAL_INCLUDES_FILES "${CMAKE_CURRENT_BINARY_DIR}/mdt_${libraryName}_export.h"
#     INCLUDES_DESTINATION ${MDT_INSTALL_INCLUDEDIR}
#     EXPORT_NAME ${libraryName}
#     EXPORT_NAMESPACE Mdt${PROJECT_VERSION_MAJOR}::
#     INSTALL_NAMESPACE ${MDT_INSTALL_PACKAGE_NAME}
#     FIND_PACKAGE_PATHS ..
#     INSTALL_IS_UNIX_SYSTEM_WIDE ${MDT_INSTALL_IS_UNIX_SYSTEM_WIDE}
#     VERSION ${PROJECT_VERSION}
#     SOVERSION ${PROJECT_VERSION_MAJOR}
#     VERSION_COMPATIBILITY ${VERSION_COMPATIBILITY}
#     RUNTIME_COMPONENT Mdt_${libraryName}_Runtime
#     DEVELOPMENT_COMPONENT Mdt_${libraryName}_Dev
#   )
#
# Example:
#
# .. code-block:: cmake
#
#   add_library(Mdt_ItemModel
#     Mdt/ItemModel/SortProxyModel.cpp
#   )
#
#   generate_export_header(Mdt_ItemModel)
#
#   target_include_directories(Mdt_ItemModel
#     PUBLIC
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
#   )
#
#   set_target_properties(Mdt_ItemModel
#     PROPERTIES
#       LIBRARY_NAME ItemModel
#   )
#
#   # This should be set at the top level CMakeLists.txt
#   set(MDT_INSTALL_PACKAGE_NAME Mdt${PROJECT_VERSION_MAJOR})
#   include(GNUInstallDirs)
#   include(MdtInstallDirs)
#
#   include(MdtInstallMdtLibrary)
#
#   mdt_install_mdt_library(
#     TARGET Mdt_ItemModel
#     VERSION_COMPATIBILITY ExactVersion
#   )
#
# By using :command:`mdt_add_mdt_library()`,
# above example could be reduced to:
#
# .. code-block:: cmake
#
#   include(MdtAddMdtLibrary)
#   include(MdtInstallMdtLibrary)
#
#   mdt_add_mdt_library(
#     LIBRARY_NAME ItemModel
#     PUBLIC_DEPENDENCIES
#       Qt5::Core
#     SOURCE_FILES
#       Mdt/ItemModel/SortProxyModel.cpp
#   )
#
#   # This should be set at the top level CMakeLists.txt
#   set(MDT_INSTALL_PACKAGE_NAME Mdt${PROJECT_VERSION_MAJOR})
#   include(GNUInstallDirs)
#   include(MdtInstallDirs)
#
#   mdt_install_mdt_library(
#     TARGET Mdt_ItemModel
#     VERSION_COMPATIBILITY ExactVersion
#   )
#

include(MdtInstallLibrary)

function(mdt_install_mdt_library)

  set(options)
  set(oneValueArgs TARGET VERSION_COMPATIBILITY)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_TARGET)
    message(FATAL_ERROR "mdt_install_mdt_library(): mandatory argument TARGET missing")
  endif()
  if(NOT ARG_VERSION_COMPATIBILITY)
    message(FATAL_ERROR "mdt_install_mdt_library(): mandatory argument VERSION_COMPATIBILITY missing")
  endif()
    if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_install_mdt_library(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  get_target_property(libraryName ${ARG_TARGET} LIBRARY_NAME)
  if(NOT libraryName)
    message(FATAL_ERROR "mdt_install_mdt_library(): mandatory target property LIBRARY_NAME is missing for ${ARG_TARGET}")
  endif()

  string(TOLOWER ${libraryName} libraryNameLowerCase)

  mdt_install_library(
    TARGET ${ARG_TARGET}
    RUNTIME_DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY_DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE_DESTINATION ${CMAKE_INSTALL_LIBDIR}
    INCLUDES_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/"
    INCLUDES_FILE_WITHOUT_EXTENSION
    ADDITIONAL_INCLUDES_FILES "${CMAKE_CURRENT_BINARY_DIR}/mdt_${libraryNameLowerCase}_export.h"
    INCLUDES_DESTINATION ${MDT_INSTALL_INCLUDEDIR}
    EXPORT_NAME ${libraryName}
    EXPORT_NAMESPACE Mdt${PROJECT_VERSION_MAJOR}::
    INSTALL_NAMESPACE ${MDT_INSTALL_PACKAGE_NAME}
    FIND_PACKAGE_PATHS ..
    INSTALL_IS_UNIX_SYSTEM_WIDE ${MDT_INSTALL_IS_UNIX_SYSTEM_WIDE}
    VERSION ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION_MAJOR}
    VERSION_COMPATIBILITY ${ARG_VERSION_COMPATIBILITY}
    RUNTIME_COMPONENT Mdt_${libraryName}_Runtime
    DEVELOPMENT_COMPONENT Mdt_${libraryName}_Dev
  )

endfunction()
