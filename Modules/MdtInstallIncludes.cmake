# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtInstallIncludes
# ------------------
#
# Headers in various project layouts
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# Some examples of source tree.
# Some are inspired from `The Pitchfork Layout (PFL) <https://github.com/vector-of-bool/pitchfork>`_
#
# Separate Header Placement::
#
#   ${CMAKE_SOURCE_DIR}
#     |-CMakeLists.txt
#     |-include
#     |   |-Mdt
#     |      |-LedPainter.h
#     |      |-LedWidget.h
#     |-src
#        |-CMakeLists.txt
#        |-Mdt
#           |-LedPainter.cpp
#           |-LedWidget.cpp
#
#
# For above example, in the ``CMakeLists.txt`` in ``src``, the include directory could be declared:
#
# .. code-block:: cmake
#
#   target_include_directories(Mdt_Led
#     PUBLIC
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../include>
#   )
#
# Merged Header Placement::
#
#   ${CMAKE_SOURCE_DIR}
#     |-CMakeLists.txt
#     |-src
#        |-CMakeLists.txt
#        |-Mdt
#           |-LedPainter.h
#           |-LedWidget.h
#           |-LedPainter.cpp
#           |-LedWidget.cpp
#
#
# For above example, in the ``CMakeLists.txt`` in ``src``, the include directory could be declared:
#
# .. code-block:: cmake
#
#   target_include_directories(Mdt_Led
#     PUBLIC
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
#   )
#
# Project using Submodules (with Merged Header Placement) ::
#
#   ${CMAKE_SOURCE_DIR}
#     |-CMakeLists.txt
#     |-libs
#        |-ItemModel
#            |-src
#               |-CMakeLists.txt
#               |-Mdt
#                  |-ItemModel
#                     |-SortProxyModel.h
#                     |-SortProxyModel.cpp
#
# For above example, in the ``CMakeLists.txt`` in ``src``, the include directory could be declared:
#
# .. code-block:: cmake
#
#   target_include_directories(Mdt_ItemModel
#     PUBLIC
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
#   )
#
# Some headers are generated during build time.
# Such an example are export headers, generated using :command:`generate_export_header()`.
# Taking the above example "Merged Header Placement", the build directory tree could be similar to::
#
#   ${CMAKE_BINARY_DIR}
#       |-CMakeFiles
#       |-CMakeCache.txt
#       |-OtherCmakeFilesAndDirectories
#       |-src
#          |-CMakeFiles
#          |-Mdt_SortProxyModel_autogen
#          |   |-include
#          |   |-moc_predefs.h
#          |-libMdt0ProxyModel.so
#          |-Makefile
#          |-mdt_sortproxymodel_export.h
#
# We can see that a lot of files and directories are generated in the build tree.
# In above example, only ``mdt_sortproxymodel_export.h`` has to be installed, but not ``moc_predefs.h``.
#
# Install headers with CMake
# ^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# Lets take the above example "Merged Header Placement" again to explore various
# possible ways to define and install headers.
#
# Example using :command:`install(DIRECTORY)`:
#
# .. code-block:: cmake
#
#   add_library(Mdt_Led
#     Mdt/LedPainter.cpp
#     Mdt/LedWidget.cpp
#   )
#
#   # Define the include directory we need to buil and those needed by the user of this target
#   # Do not define the INSTALL_INTERFACE here, see the install(TARGETS) below
#   target_include_directories(Mdt_Led
#     PUBLIC
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
#   )
#
#   set(MDT_INSTALL_PACKAGE_NAME Mdt0)
#   include(GNUInstallDirs)
#   include(MdtInstallDirs)
#
#   # Install the binary library of this target
#   # The INCLUDES DESTINATION specifies a list of directories
#   # which will be added to the INTERFACE_INCLUDE_DIRECTORIES target property of the <targets>
#   # when exported by the install(EXPORT) command
#   # But, the includes directories are not installed
#   install(
#     TARGETS Mdt_Led
#     EXPORT Mdt_LedTargets
#     RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#     LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     INCLUDES DESTINATION ${MDT_INSTALL_INCLUDEDIR}
#   )
#
#   install(
#     EXPORT Mdt_LedTargets
#     DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0Led
#     NAMESPACE Mdt0::
#     FILE Mdt0LedTargets.cmake
#   )
#
#   # Install the includes directory
#   install(
#     DIRECTORY Mdt
#     DESTINATION ${MDT_INSTALL_INCLUDEDIR}
#     FILES_MATCHING PATTERN *.h
#   )
#
# Once the above example is installed, it looks like::
#
#   ${CMAKE_INSTALL_PREFIX}
#       |-include
#       |   |-Mdt
#       |      |-LedPainter.h
#       |      |-LedWidget.h
#       |-lib
#          |-cmake
#          |   |-Mdt0Led
#          |       |-Mdt0LedTargets.cmake
#          |-libMdt_Led.so
#
# The genarated ``Mdt0LedTargets.cmake`` file will define the ``INTERFACE_INCLUDE_DIRECTORIES`` property to the IMPORTED target:
#
# .. code-block:: cmake
#
#   add_library(Mdt0::Led SHARED IMPORTED)
#
#   set_target_properties(Mdt0::Led PROPERTIES
#     INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include"
#   )
#
# If we do not specify the ``INCLUDES DESTINATION`` argument of :command:`install(TARGETS)`,
# the ``INTERFACE_INCLUDE_DIRECTORIES`` property will not be set to the IMPORTED target.
#
# CMake also provides the :variable:`PUBLIC_HEADER` and :variable:`PRIVATE_HEADER` target properties:
#
# .. code-block:: cmake
#
#   add_library(Mdt_Led
#     Mdt/LedPainter.cpp
#     Mdt/LedWidget.cpp
#   )
#
#   # We still have to define the includes directories to build this target,
#   # but also to for the user of this target in our project, for example unit tests
#   # Do not define the INSTALL_INTERFACE here, see the install(TARGETS) below
#   target_include_directories(Mdt_Led
#     PUBLIC
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
#   )
#
#   # Set the PUBLIC_HEADER property to this target
#   # Notice how multiple files have to be specified
#   # If we not provide the list in a quoted string,
#   # only the first header will be set to the property
#   set_target_properties(Mdt_Led
#     PROPERTIES
#       PUBLIC_HEADER "Mdt/LedPainter.h;Mdt/LedWidget.h"
#   )
#
#   set(MDT_INSTALL_PACKAGE_NAME Mdt0)
#   include(GNUInstallDirs)
#   include(MdtInstallDirs)
#
#   # Install the binary library of this target
#   # This time, the headers existing in the PUBLIC_HEADER property of this target
#   # will be installed to the location specified by the PUBLIC_HEADER DESTINATION argument
#   # We still have to provide the INCLUDES DESTINATION,
#   # else the INTERFACE_INCLUDE_DIRECTORIES property will not be set to the imported target
#   install(
#     TARGETS Mdt_Led
#     EXPORT Mdt_LedTargets
#     RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#     LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     PUBLIC_HEADER DESTINATION ${MDT_INSTALL_INCLUDEDIR}/Mdt
#     INCLUDES DESTINATION ${MDT_INSTALL_INCLUDEDIR}
#   )
#
#   install(
#     EXPORT Mdt_LedTargets
#     DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0Led
#     NAMESPACE Mdt0::
#     FILE Mdt0LedTargets.cmake
#   )
#
# Notice that ``PUBLIC_HEADER DESTINATION`` points to ``Mdt`` subdirectory.
# Here the directory structure is not copied, but each file specified
# in the ``PUBLIC_HEADER`` property is copied to ``PUBLIC_HEADER DESTINATION``.
# The ``INCLUDES DESTINATION`` has also to be specified,
# so that the :variable:`INTERFACE_INCLUDE_DIRECTORIES` is defined in the IMPORTED target.
# Notice also that we not specify the ``Mdt`` subdirectory to ``INCLUDES DESTINATION``.
#
# Helper functions to install headers
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_install_include_directory
#
# Install a include directory::
#
#   mdt_install_include_directory(
#     DIRECTORY <dir>
#     DESTINATION <dir>
#     [FILE_EXTENSIONS ext1 [ext2 ...]]
#     [FILE_WITHOUT_EXTENSION]
#     [COMPONENT <component>]
#   )
#
# The headers in ``DIRECTORY`` will be installed.
#
# By default, files with extensions ``.h``, ``.hh``, ``.h++``, ``.hpp`` will be installed.
# A alternate list of file extensions can be passed as ``FILE_EXTENSIONS``.
# If the ``FILE_WITHOUT_EXTENSION`` option is set, files without extensions will also be installed.
#

function(mdt_install_include_directory)

  set(options FILE_WITHOUT_EXTENSION)
  set(oneValueArgs DIRECTORY DESTINATION COMPONENT)
  set(multiValueArgs FILE_EXTENSIONS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_DIRECTORY)
    message(FATAL_ERROR "mdt_install_include_directory(): mandatory argument DIRECTORY missing")
  endif()
  if(NOT ARG_DESTINATION)
    message(FATAL_ERROR "mdt_install_include_directory(): mandatory argument DESTINATION missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_install_include_directory(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(fileExtensions)
  if(ARG_FILE_EXTENSIONS)
    set(fileExtensions ${ARG_FILE_EXTENSIONS})
  else()
    set(fileExtensions ".h" ".hh" ".h\\+\\+" ".hpp")
  endif()

  list(GET fileExtensions 0 firstExtension)
  list(REMOVE_AT fileExtensions 0)
  set(regex "/.+\\${firstExtension}")
  foreach(extension ${fileExtensions})
    string(APPEND regex "|/.+\\${extension}")
  endforeach()

  if(ARG_FILE_WITHOUT_EXTENSION)
    string(APPEND regex "|/[^.]+$")
  endif()

  set(componentArguments)
  if(ARG_COMPONENT)
    set(componentArguments COMPONENT ${ARG_COMPONENT})
  endif()

  install(
    DIRECTORY "${ARG_DIRECTORY}"
    DESTINATION "${ARG_DESTINATION}"
    ${componentArguments}
    FILES_MATCHING
      REGEX "${regex}"
  )

endfunction()
