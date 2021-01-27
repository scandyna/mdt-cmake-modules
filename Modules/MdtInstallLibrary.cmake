# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtInstallLibrary
# -----------------
#
# .. contents:: Summary
#    :local:
#
# Introduction
# ^^^^^^^^^^^^
#
# As example, we have 2 libraries that will be installed:
#
# - ItemModel: provide some models based on Qt's Item/View framework
# - ItemEditor: provide some helpers for edition in the ItemView framework
#
# Both libraries are separate projects.
#
# Finally, a application will use those libraries.
#
# To simplify the case, and also to expose some issue,
# both libraries depends on QtCore
# (in practice, ItemEditor will probably also depend on QtWidgets).
#
# The example are incomplete and only focuses on library installation.
#
# Here is ItemModel:
#
# .. code-block:: cmake
#
#   find_package(Qt5 COMPONENTS Core REQUIRED)
#
#   add_library(Mdt_ItemModel
#     Mdt/ItemModel/sourc1.cpp
#     Mdt/ItemModel/sourc2.cpp
#     ...
#   )
#
#   include(GenerateExportHeader)
#   generate_export_header(Mdt_ItemModel)
#
#   target_link_libraries(Mdt_ItemModel
#     PUBLIC
#       Qt5::Core
#   )
#
#   target_include_directories(Mdt_ItemModel
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
#     TARGET Mdt_ItemModel
#     RUNTIME_DESTINATION ${CMAKE_INSTALL_BINDIR}
#     LIBRARY_DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     ARCHIVE_DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     INCLUDES_DIRECTORY .
#     INCLUDES_FILE_WITHOUT_EXTENSION
#     ADDITIONAL_INCLUDES_FILES "${CMAKE_CURRENT_BINARY_DIR}/mdt_itemmodel_export.h"
#     INCLUDES_DESTINATION ${MDT_INSTALL_INCLUDEDIR}
#     EXPORT_NAME ItemModel
#     EXPORT_NAMESPACE Mdt0::
#     INSTALL_NAMESPACE ${MDT_INSTALL_PACKAGE_NAME}
#     FIND_PACKAGE_PATHS ..
#     INSTALL_IS_UNIX_SYSTEM_WIDE ${MDT_INSTALL_IS_UNIX_SYSTEM_WIDE}
#     VERSION ${PROJECT_VERSION}
#     SOVERSION ${PROJECT_VERSION_MAJOR}
#     VERSION_COMPATIBILITY ExactVersion
#     RUNTIME_COMPONENT ${PROJECT_NAME}_Runtime
#     DEVELOPMENT_COMPONENT ${PROJECT_NAME}_Dev
#   )
#
# Here is a extract of ItemEditor (not working):
#
# .. code-block:: cmake
#
#   find_package(Mdt0 COMPONENTS ItemModel REQUIRED)
#
#   add_library(Mdt_ItemEditor
#     Mdt/ItemEditor/sourc1.cpp
#     Mdt/ItemEditor/sourc2.cpp
#     ...
#   )
#
#   target_link_libraries(Mdt_ItemEditor
#     PUBLIC
#       Mdt0::ItemModel
#   )
#
# With above example, CMake will probably generate a error,
# because ItemEditor depends on ItemModel, which depends on Qt5::Core.
# The problem is that a call to ``find_package(Qt5 COMPONENTS Core REQUIRED)`` is missing.
#
# We will see later that transitive dependencies,
# including calls to :command:`find_package()`,
# are supported when using :command:`mdt_install_library()`,
# but some informations needs to be attached as target properties to make it work.
# Because the used mechanism is not standard CMake,
# Qt5 does not provide the meta informations to call :command:`find_package()` automatically.
# For more technical details, see below and also :command:`mdt_install_package_config_file()`.
#
# Here is ItemEditor:
#
# .. code-block:: cmake
#
#   # We have to call find_package() for Qt5 here
#   find_package(Qt5 COMPONENTS Core REQUIRED)
#   find_package(Mdt0 COMPONENTS ItemModel REQUIRED)
#
#   add_library(Mdt_ItemEditor
#     Mdt/ItemEditor/sourc1.cpp
#     Mdt/ItemEditor/sourc2.cpp
#     ...
#   )
#
#   include(GenerateExportHeader)
#   generate_export_header(Mdt_ItemEditor)
#
#   # We don't need to express the dependency to Qt5::Core here
#   # (at this level, transitive dependency is standard CMake)
#   target_link_libraries(Mdt_ItemEditor
#     PUBLIC
#       Mdt0::ItemModel
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
#     INCLUDES_DIRECTORY .
#     INCLUDES_FILE_WITHOUT_EXTENSION
#     ADDITIONAL_INCLUDES_FILES "${CMAKE_CURRENT_BINARY_DIR}/mdt_itemeditor_export.h"
#     INCLUDES_DESTINATION ${MDT_INSTALL_INCLUDEDIR}
#     EXPORT_NAME ItemEditor
#     EXPORT_NAMESPACE Mdt0::
#     INSTALL_NAMESPACE ${MDT_INSTALL_PACKAGE_NAME}
#     FIND_PACKAGE_PATHS ..
#     INSTALL_IS_UNIX_SYSTEM_WIDE ${MDT_INSTALL_IS_UNIX_SYSTEM_WIDE}
#     VERSION ${PROJECT_VERSION}
#     SOVERSION ${PROJECT_VERSION_MAJOR}
#     VERSION_COMPATIBILITY ExactVersion
#     RUNTIME_COMPONENT ${PROJECT_NAME}_Runtime
#     DEVELOPMENT_COMPONENT ${PROJECT_NAME}_Dev
#   )
#
# Here is the final application that uses ItemEditor:
#
# .. code-block:: cmake
#
#   find_package(Qt5 COMPONENTS Core REQUIRED)
#   find_package(Mdt0 COMPONENTS ItemEditor REQUIRED)
#
#   add_executable(myApp myApp.cpp)
#
#   target_link_libraries(myApp
#     PRIVATE
#       Mdt0::ItemEditor
#   )
#
# In above example, `myApp` cares about ItemEditor.
# There is no care to take about libraries
# `ItemEditor` depends on, as long as they are installed
# using :command:`mdt_install_library()`.
# But, as explained before,
# we have to explicitly call :command:`find_package()`
# for libraries, used by `ItemEditor`,
# like Qt5, Boost, etc..
#
#
# Install a interface library
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_install_interface_library
#
# Install a interface (typically a header only) library::
#
#   mdt_install_interface_library(
#     TARGET <target>
#     LIBRARY_DESTINATION <dir>
#     INCLUDES_DIRECTORY <dir>
#     [INCLUDES_FILE_EXTENSIONS ext1 [ext2 ...]]
#     [INCLUDES_FILE_WITHOUT_EXTENSION]
#     [ADDITIONAL_INCLUDES_FILES file1 [file2 ...]]
#     INCLUDES_DESTINATION <dir>
#     EXPORT_NAME <export-name>
#     EXPORT_NAMESPACE <export-namespace>
#     INSTALL_NAMESPACE <install-namespace>
#     [FIND_PACKAGE_PATHS path1 [path2 ...]]
#     [VERSION <version>]
#     [VERSION_COMPATIBILITY <AnyNewerVersion|SameMajorVersion|ExactVersion>]
#     [DEVELOPMENT_COMPONENT <component-name>]
#   )
#
# Will install the includes directory passed as ``INCLUDES_DIRECTORY`` argument
# to the destination specified by ``INCLUDES_DESTINATION`` using :command:`mdt_install_include_directory()`.
# For more informations about ``INCLUDES_FILE_EXTENSIONS`` and ``INCLUDES_FILE_WITHOUT_EXTENSION``
# see :command:`mdt_install_include_directory()`.
#
# Header files passed to ``ADDITIONAL_INCLUDES_FILES`` will also be installed,
# using :command:`install(FILES)`,
# to the location defined by the ``INCLUDES_DESTINATION`` argument.
#
# The ``INCLUDES_DESTINATION`` will also be passed to :command:`install(TARGETS)`
# as ``INCLUDES DESTINATION`` argument.
# This way, the ``INTERFACE_INCLUDE_DIRECTORIES`` will be set for the IMPORTED target.
#
# The ``EXPORT_NAME`` and ``EXPORT_NAMESPACE`` will be set as properties to ``target``:
#
# .. code-block:: cmake
#
#   set_target_properties(${target}
#     PROPERTIES
#       EXPORT_NAME ${EXPORT_NAME}
#       INTERFACE_EXPORT_NAMESPACE ${EXPORT_NAMESPACE}
#   )
#
# As result, the export name of ``target`` (which will be the name of the IMPORTED target for the consumer of the package)
# will be ``${EXPORT_NAMESPACE}${EXPORT_NAME}``.
# The library base name will also be ``${EXPORT_NAMESPACE}${EXPORT_NAME}``.
#
# Notice that the ``EXPORT_NAMESPACE`` argument will be set as ``INTERFACE_EXPORT_NAMESPACE`` target property.
# This is because CMake currently not allows ``EXPORT_NAMESPACE`` as property of a ``INTERFACE`` target.
#
# See also this issue: https://gitlab.kitware.com/cmake/cmake/issues/19145
#
# Package config files will also be generated using :command:`install(TARGETS ... EXPORT ...)`.
# Those files will contain the definition of the imported target, named ``${EXPORT_NAMESPACE}${EXPORT_NAME}``.
# Those files will also be installed using :command:`install(EXPORT)`.
#
# A package config file named ``${INSTALL_NAMESPACE}${EXPORT_NAME}Config.cmake`` is also generated
# and installed using :command:`mdt_install_package_config_file()`.
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
# If specified, the following parts will be associated to ``DEVELOPMENT_COMPONENT``:
#
#  - ``LIBRARY_DESTINATION`` : cmake subfolder with the genarated package config files and the namelink of a versionned library.
#  - ``INCLUDES_DESTINATION`` : the header files.
#
# Example:
#
# .. code-block:: cmake
#
#   add_library(Mdt_Algorithms INTERFACE)
#
#   include(GenerateExportHeader)
#   generate_export_header(Mdt_Algorithms)
#
#   target_link_libraries(Mdt_Algorithms
#     INTERFACE Boost::hana
#   )
#
#   target_include_directories(Mdt_Algorithms
#     INTERFACE
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
#   )
#
#   # This should be set at the top level CMakeLists.txt
#   set(MDT_INSTALL_PACKAGE_NAME Mdt0)
#   include(GNUInstallDirs)
#   include(MdtInstallDirs)
#
#   mdt_install_interface_library(
#     TARGET Mdt_Algorithms
#     LIBRARY_DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     INCLUDES_DIRECTORY .
#     INCLUDES_FILE_WITHOUT_EXTENSION
#     ADDITIONAL_INCLUDES_FILES "${CMAKE_CURRENT_BINARY_DIR}/mdt_algorithms_export.h"
#     INCLUDES_DESTINATION ${MDT_INSTALL_INCLUDEDIR}
#     EXPORT_NAME Algorithms
#     EXPORT_NAMESPACE Mdt0::
#     INSTALL_NAMESPACE ${MDT_INSTALL_PACKAGE_NAME}
#     FIND_PACKAGE_PATHS ..
#     VERSION ${PROJECT_VERSION}
#     VERSION_COMPATIBILITY ExactVersion
#     DEVELOPMENT_COMPONENT Mdt_Algorithms_Dev
#   )
#
# Notice the usage of ``MDT_INSTALL_PACKAGE_NAME`` and ``MDT_INSTALL_INCLUDEDIR``.
# Those variable are used and provided by the :module:`MdtInstallDirs` module
# and will help install the includes in a appropriate subdirectory.
#
# On a non system wide Linux installation, the result will be::
#
#   ${CMAKE_INSTALL_PREFIX}
#     |-include
#     |   |-mdt_algorithms_export.h
#     |   |-Mdt
#     |     |-Algorithms
#     |       |-Algorithms.h
#     |-lib
#       |-cmake
#         |-Mdt0ItemEditor
#           |-Mdt0AlgorithmsTargets.cmake
#           |-Mdt0AlgorithmsConfig.cmake
#           |-Mdt0AlgorithmsConfigVersion.cmake
#
# The generated ``Mdt0AlgorithmsTargets.cmake`` will define the IMPORTED target:
#
# .. code-block:: cmake
#
#   add_library(Mdt0::Algorithms IMPORTED)
#
#   set_target_properties(Mdt0::Algorithms PROPERTIES
#     INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include"
#     INTERFACE_LINK_LIBRARIES "Boost::hana"
#   )
#
# The generated ``Mdt0AlgorithmsConfig.cmake`` will look like:
#
# .. code-block:: cmake
#
#   include("${CMAKE_CURRENT_LIST_DIR}/Mdt0AlgorithmsTargets.cmake")
#   # Set package properties for target Mdt0::Algorithms
#   set_target_properties(Mdt0::Algorithms
#     PROPERTIES
#       INTERFACE_FIND_PACKAGE_NAME Mdt0Algorithms
#       INTERFACE_FIND_PACKAGE_VERSION 0.1.2
#       INTERFACE_FIND_PACKAGE_PATHS ..
#   )
#
# Example of a system wide install on a Debian MultiArch (``CMAKE_INSTALL_PREFIX=/usr``)::
#
#   /usr
#     |-include
#     | |-x86_64-linux-gnu
#     |   |-Mdt0
#     |     |-mdt_algorithms_export.h
#     |     |-Mdt
#     |       |-Algorithms
#     |         |-Algorithms.h
#     |-lib
#       |-x86_64-linux-gnu
#         |-cmake
#           |-Mdt0ItemEditor
#             |-Mdt0AlgorithmsTargets.cmake
#             |-Mdt0AlgorithmsConfig.cmake
#             |-Mdt0AlgorithmsConfigVersion.cmake
#
# Notice that the library is installed in the architecture dependent path.
#
# See this issue: https://gitlab.com/scandyna/mdt-cmake-modules/issues/6
#
#
# Install a library
# ^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_install_library
#
# Install a library::
#
#   mdt_install_library(
#     TARGET <target>
#     RUNTIME_DESTINATION <dir>
#     LIBRARY_DESTINATION <dir>
#     ARCHIVE_DESTINATION <dir>
#     INCLUDES_DIRECTORY <dir>
#     [INCLUDES_FILE_EXTENSIONS ext1 [ext2 ...]]
#     [INCLUDES_FILE_WITHOUT_EXTENSION]
#     [ADDITIONAL_INCLUDES_FILES file1 [file2 ...]]
#     INCLUDES_DESTINATION <dir>
#     EXPORT_NAME <export-name>
#     EXPORT_NAMESPACE <export-namespace>
#     INSTALL_NAMESPACE <install-namespace>
#     [FIND_PACKAGE_PATHS path1 [path2 ...]]
#     [INSTALL_IS_UNIX_SYSTEM_WIDE <TRUE|FALSE>]
#     [VERSION <version>]
#     [SOVERSION <version>]
#     [VERSION_COMPATIBILITY <AnyNewerVersion|SameMajorVersion|ExactVersion>]
#     [RUNTIME_COMPONENT <component-name>]
#     [DEVELOPMENT_COMPONENT <component-name>]
#   )
#
# Install ``target`` using :command:`install(TARGETS)` to the various given destinations.
#
# Will also install the includes directory passed as ``INCLUDES_DIRECTORY`` argument
# to the destination specified by ``INCLUDES_DESTINATION`` using :command:`mdt_install_include_directory()`.
# For more informations about ``INCLUDES_FILE_EXTENSIONS`` and ``INCLUDES_FILE_WITHOUT_EXTENSION``
# see :command:`mdt_install_include_directory()`.
#
# Header files passed to ``ADDITIONAL_INCLUDES_FILES`` will also be installed,
# using :command:`install(FILES)`,
# to the location defined by the ``INCLUDES_DESTINATION`` argument.
#
# The ``INCLUDES_DESTINATION`` will also be passed to :command:`install(TARGETS)`
# as ``INCLUDES DESTINATION`` argument.
# This way, the ``INTERFACE_INCLUDE_DIRECTORIES`` will be set for the IMPORTED target.
#
# The ``EXPORT_NAME``, ``EXPORT_NAMESPACE`` and ``INSTALL_NAMESPACE`` will be set as properties to ``target``:
#
# .. code-block:: cmake
#
#   set_target_properties(${target}
#     PROPERTIES
#       OUTPUT_NAME ${INSTALL_NAMESPACE}${EXPORT_NAME}
#       EXPORT_NAME ${EXPORT_NAME}
#       INTERFACE_EXPORT_NAMESPACE ${EXPORT_NAMESPACE}
#   )
#
# As result, the export name of ``target`` (which will be the name of the IMPORTED target for the consumer of the package)
# will be ``${EXPORT_NAMESPACE}${EXPORT_NAME}``.
# The library base name will also be ``${EXPORT_NAMESPACE}${EXPORT_NAME}``.
#
# Notice that the ``EXPORT_NAMESPACE`` argument will be set as ``INTERFACE_EXPORT_NAMESPACE`` target property.
# This is because CMake currently not allows ``EXPORT_NAMESPACE`` as property of a ``INTERFACE`` target.
#
# See also this issue: https://gitlab.kitware.com/cmake/cmake/issues/19145
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
# If specified, the following parts will be associated to ``RUNTIME_COMPONENT``:
#
#  - ``RUNTIME_DESTINATION`` : shared libraries on DLL platorms (Windows, Cygwin).
#  - ``LIBRARY_DESTINATION`` : shared libraries on UNIX platforms.
#
# If specified, the following parts will be associated to ``DEVELOPMENT_COMPONENT``:
#
#  - ``LIBRARY_DESTINATION`` : cmake subfolder with the genarated package config files and the namelink of a versionned library.
#  - ``ARCHIVE_DESTINATION`` : static libraries. On DLL platforms, also contains import library.
#  - ``INCLUDES_DESTINATION`` : the header files.
#
#
# Example:
#
# .. code-block:: cmake
#
#   add_library(Mdt_ItemEditor
#     Mdt/ItemEditor/sourc1.cpp
#     Mdt/ItemEditor/sourc2.cpp
#     ...
#   )
#
#   include(GenerateExportHeader)
#   generate_export_header(Mdt_ItemEditor)
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
#     INCLUDES_DIRECTORY .
#     INCLUDES_FILE_WITHOUT_EXTENSION
#     ADDITIONAL_INCLUDES_FILES "${CMAKE_CURRENT_BINARY_DIR}/mdt_itemeditor_export.h"
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
# Those variable are used and provided by the :module:`MdtInstallDirs` module
# and will help install the includes in a appropriate subdirectory.
#
# On a non system wide Linux installation, the result will be::
#
#   ${CMAKE_INSTALL_PREFIX}
#     |-include
#     |   |-mdt_itemeditor_export.h
#     |   |-Mdt
#     |     |-ItemEditor
#     |       |-TableEditor.h
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
# The generated ``Mdt0ItemEditorTargets.cmake`` will define the IMPORTED target:
#
# .. code-block:: cmake
#
#   add_library(Mdt0::ItemEditor SHARED IMPORTED)
#
#   set_target_properties(Mdt0::ItemEditor PROPERTIES
#     INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include"
#     INTERFACE_LINK_LIBRARIES "Mdt0::ItemModel"
#   )
#
# The generated ``Mdt0ItemEditorConfig.cmake`` will look like:
#
# .. code-block:: cmake
#
#   # Find dependencies for target Mdt0::ItemEditor
#   find_package(Mdt0ItemModel 0.1.2 QUIET CONFIG PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH)
#   if(NOT Mdt0ItemModel_FOUND)
#     find_package(Mdt0ItemModel 0.1.2 QUIET REQUIRED CONFIG)
#   endif()
#
#   include("${CMAKE_CURRENT_LIST_DIR}/Mdt0ItemEditorTargets.cmake")
#   # Set package properties for target Mdt0::ItemEditor
#   set_target_properties(Mdt0::ItemEditor
#     PROPERTIES
#       INTERFACE_FIND_PACKAGE_NAME Mdt0ItemEditor
#       INTERFACE_FIND_PACKAGE_VERSION 0.1.2
#       INTERFACE_FIND_PACKAGE_PATHS ..
#   )
#
#
# Example of a system wide install on a Debian MultiArch (``CMAKE_INSTALL_PREFIX=/usr``)::
#
#   /usr
#     |-include
#     | |-x86_64-linux-gnu
#     |   |-Mdt0
#     |     |-mdt_itemeditor_export.h
#     |     |-Mdt
#     |       |-ItemEditor
#     |         |-TableEditor.h
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
# To support the component syntax of :command:`find_package()`,
# see :command:`mdt_install_namespace_package_config_file()`
# and :command:`mdt_install_namespace_package_config_version_file()`.
#
# Above example should be fine to install a library.
# At runtime, some problems can occur.
# See the :module:`MdtRuntimeEnvironment` module for discussions about that.
#
#
# Install a executable
# """"""""""""""""""""
#
# .. command:: mdt_install_executable
#
# Install a executable::
#
#   mdt_install_executable(
#     TARGET <target>
#     RUNTIME_DESTINATION <dir>
#     [LIBRARY_DESTINATION <dir>]
#     [COPY_BINARY_DEPENDENCIES <TRUE|FALSE>]
#     [or COPY_SHARED_LIBRARY_DEPENDENCIES <TRUE|FALSE>]
#     [or COPY_DEPENDENT_SHARED_LIBRARIES <TRUE|FALSE>]
#     [INSTALL_IS_UNIX_SYSTEM_WIDE <true>]
#   )
#
# TODO RPATH to $ORIGIN/../lib  if not INSTALL_IS_UNIX_SYSTEM_WIDE
#

include(MdtTargetProperties)
include(MdtInstallIncludes)
include(MdtPackageConfigHelpers)

function(mdt_install_interface_library)

  set(options INCLUDES_FILE_WITHOUT_EXTENSION)
  set(oneValueArgs TARGET LIBRARY_DESTINATION
                  INCLUDES_DIRECTORY INCLUDES_DESTINATION INCLUDES_FILES_MATCHING_PATTERN
                  EXPORT_NAME EXPORT_NAMESPACE INSTALL_NAMESPACE
                  VERSION VERSION_COMPATIBILITY
                  DEVELOPMENT_COMPONENT)
  set(multiValueArgs INCLUDES_FILE_EXTENSIONS ADDITIONAL_INCLUDES_FILES FIND_PACKAGE_PATHS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_TARGET)
    message(FATAL_ERROR "mdt_install_interface_library(): no target provided")
  endif()
  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_install_interface_library(): ${ARG_TARGET} is not a valid target")
  endif()
  if(NOT ARG_LIBRARY_DESTINATION)
    message(FATAL_ERROR "mdt_install_interface_library(): mandatory argument LIBRARY_DESTINATION missing")
  endif()
  if(NOT ARG_INCLUDES_DIRECTORY)
    message(FATAL_ERROR "mdt_install_interface_library(): mandatory argument INCLUDES_DIRECTORY missing")
  endif()
  if(NOT ARG_INCLUDES_DESTINATION)
    message(FATAL_ERROR "mdt_install_interface_library(): mandatory argument INCLUDES_DESTINATION missing")
  endif()
  if(NOT ARG_EXPORT_NAME)
    message(FATAL_ERROR "mdt_install_interface_library(): mandatory argument EXPORT_NAME missing")
  endif()
  if(NOT ARG_EXPORT_NAMESPACE)
    message(FATAL_ERROR "mdt_install_interface_library(): mandatory argument EXPORT_NAMESPACE missing")
  endif()
  if(NOT ARG_INSTALL_NAMESPACE)
    message(FATAL_ERROR "mdt_install_interface_library(): mandatory argument INSTALL_NAMESPACE missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_install_interface_library(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  if(ARG_VERSION AND NOT ARG_VERSION_COMPATIBILITY)
    message(FATAL_ERROR "mdt_install_interface_library(): provided a VERSION argument, but no VERSION_COMPATIBILITY")
  endif()

  set_target_properties(${ARG_TARGET}
    PROPERTIES
      EXPORT_NAME ${ARG_EXPORT_NAME}
      INTERFACE_EXPORT_NAMESPACE ${ARG_EXPORT_NAMESPACE}
      INTERFACE_FIND_PACKAGE_NAME ${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}
  )

  if(ARG_FIND_PACKAGE_PATHS)
    set_target_properties(${ARG_TARGET}
      PROPERTIES
        INTERFACE_FIND_PACKAGE_PATHS "${ARG_FIND_PACKAGE_PATHS}"
    )
  endif()

  if(ARG_VERSION)
    set_target_properties(${ARG_TARGET}
      PROPERTIES
        INTERFACE_FIND_PACKAGE_VERSION ${ARG_VERSION}
    )
  endif()

  if(${ARG_FIND_PACKAGE_PATHS})
    set_target_properties(${ARG_TARGET}
      PROPERTIES
        INTERFACE_FIND_PACKAGE_PATHS "${ARG_FIND_PACKAGE_PATHS}"
    )
  endif()

  set(targetExportName ${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}Targets)

  set(developmentComponentArguments)
  if(ARG_DEVELOPMENT_COMPONENT)
    set(developmentComponentArguments COMPONENT ${ARG_DEVELOPMENT_COMPONENT})
  endif()

  install(
    TARGETS ${ARG_TARGET}
    EXPORT ${targetExportName}
    LIBRARY
      DESTINATION "${ARG_LIBRARY_DESTINATION}"
      ${developmentComponentArguments}
    INCLUDES
      DESTINATION "${ARG_INCLUDES_DESTINATION}"
  )

  set(fileWithoutExtensionArgument)
  if(ARG_INCLUDES_FILE_WITHOUT_EXTENSION)
    set(fileWithoutExtensionArgument FILE_WITHOUT_EXTENSION)
  endif()

  mdt_install_include_directory(
    DIRECTORY "${ARG_INCLUDES_DIRECTORY}"
    DESTINATION "${ARG_INCLUDES_DESTINATION}"
    FILE_EXTENSIONS ${ARG_INCLUDES_FILE_EXTENSIONS}
    ${fileWithoutExtensionArgument}
    ${developmentComponentArguments}
  )

  if(ARG_ADDITIONAL_INCLUDES_FILES)
    install(
      FILES "${ARG_ADDITIONAL_INCLUDES_FILES}"
      DESTINATION "${ARG_INCLUDES_DESTINATION}"
      ${developmentComponentArguments}
    )
  endif()

  install(
    EXPORT ${targetExportName}
    DESTINATION ${ARG_LIBRARY_DESTINATION}/cmake/${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}
    NAMESPACE ${ARG_EXPORT_NAMESPACE}
    FILE ${targetExportName}.cmake
    ${developmentComponentArguments}
  )

  mdt_install_package_config_file(
    TARGETS ${ARG_TARGET}
    TARGETS_EXPORT_FILE ${targetExportName}.cmake
    FILE ${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}Config.cmake
    DESTINATION ${ARG_LIBRARY_DESTINATION}/cmake/${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}
    ${developmentComponentArguments}
  )

  if(ARG_VERSION)
    # Taken from here: https://github.com/catchorg/Catch2/blob/master/CMakeLists.txt
    #
    # By default, FooConfigVersion is tied to architecture that it was generated on.
    # A INTERFACE (header only) library is arch-independent,
    # and thus the generated version file should not be tied to the architecture it was generated on.
    #
    # CMake does not provide a direct customization point for this in
    # `write_basic_package_version_file`, but it can be accomplished
    # indirectly by temporarily redefining `CMAKE_SIZEOF_VOID_P` to an empty string.
    # Note that just undefining the variable could be
    # insufficient in cases where the variable was already in CMake cache
    set(MDT_INITIAL_CMAKE_SIZEOF_VOID_P ${CMAKE_SIZEOF_VOID_P})
    set(CMAKE_SIZEOF_VOID_P "")
    mdt_install_package_config_version_file(
      VERSION ${ARG_VERSION}
      COMPATIBILITY ${ARG_VERSION_COMPATIBILITY}
      FILE ${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}ConfigVersion.cmake
      DESTINATION ${ARG_LIBRARY_DESTINATION}/cmake/${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}
      ${developmentComponentArguments}
    )
    set(CMAKE_SIZEOF_VOID_P ${MDT_INITIAL_CMAKE_SIZEOF_VOID_P})
  endif()

endfunction()


function(mdt_install_library)

  set(options INCLUDES_FILE_WITHOUT_EXTENSION)
  set(oneValueArgs TARGET RUNTIME_DESTINATION LIBRARY_DESTINATION ARCHIVE_DESTINATION
                  INCLUDES_DIRECTORY INCLUDES_DESTINATION INCLUDES_FILES_MATCHING_PATTERN
                  EXPORT_NAME EXPORT_NAMESPACE INSTALL_NAMESPACE INSTALL_IS_UNIX_SYSTEM_WIDE
                  VERSION SOVERSION VERSION_COMPATIBILITY
                  RUNTIME_COMPONENT DEVELOPMENT_COMPONENT)
  set(multiValueArgs INCLUDES_FILE_EXTENSIONS ADDITIONAL_INCLUDES_FILES FIND_PACKAGE_PATHS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_TARGET)
    message(FATAL_ERROR "mdt_install_library(): no target provided")
  endif()
  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_install_library(): ${ARG_TARGET} is not a valid target")
  endif()
  if(NOT ARG_RUNTIME_DESTINATION)
    message(FATAL_ERROR "mdt_install_library(): mandatory argument RUNTIME_DESTINATION missing")
  endif()
  if(NOT ARG_LIBRARY_DESTINATION)
    message(FATAL_ERROR "mdt_install_library(): mandatory argument LIBRARY_DESTINATION missing")
  endif()
  if(NOT ARG_ARCHIVE_DESTINATION)
    message(FATAL_ERROR "mdt_install_library(): mandatory argument ARCHIVE_DESTINATION missing")
  endif()
  if(NOT ARG_INCLUDES_DIRECTORY)
    message(FATAL_ERROR "mdt_install_library(): mandatory argument INCLUDES_DIRECTORY missing")
  endif()
  if(NOT ARG_INCLUDES_DESTINATION)
    message(FATAL_ERROR "mdt_install_library(): mandatory argument INCLUDES_DESTINATION missing")
  endif()
  if(NOT ARG_EXPORT_NAME)
    message(FATAL_ERROR "mdt_install_library(): mandatory argument EXPORT_NAME missing")
  endif()
  if(NOT ARG_EXPORT_NAMESPACE)
    message(FATAL_ERROR "mdt_install_library(): mandatory argument EXPORT_NAMESPACE missing")
  endif()
  if(NOT ARG_INSTALL_NAMESPACE)
    message(FATAL_ERROR "mdt_install_library(): mandatory argument INSTALL_NAMESPACE missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_install_library(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  if(ARG_VERSION AND NOT ARG_VERSION_COMPATIBILITY)
    message(FATAL_ERROR "mdt_install_library(): provided a VERSION argument, but no VERSION_COMPATIBILITY")
  endif()

  set_target_properties(${ARG_TARGET}
    PROPERTIES
      OUTPUT_NAME ${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}
      EXPORT_NAME ${ARG_EXPORT_NAME}
      INTERFACE_EXPORT_NAMESPACE ${ARG_EXPORT_NAMESPACE}
      INTERFACE_FIND_PACKAGE_NAME ${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}
  )

  if(ARG_FIND_PACKAGE_PATHS)
    set_target_properties(${ARG_TARGET}
      PROPERTIES
        INTERFACE_FIND_PACKAGE_PATHS "${ARG_FIND_PACKAGE_PATHS}"
    )
  endif()

  if(ARG_VERSION)
    set_target_properties(${ARG_TARGET}
      PROPERTIES
        VERSION ${ARG_VERSION}
        INTERFACE_FIND_PACKAGE_VERSION ${ARG_VERSION}
    )
  endif()

  if(DEFINED ARG_SOVERSION)
    set_target_properties(${ARG_TARGET}
      PROPERTIES
        SOVERSION ${ARG_SOVERSION}
    )
  endif()

  if(${ARG_FIND_PACKAGE_PATHS})
    set_target_properties(${ARG_TARGET}
      PROPERTIES
        INTERFACE_FIND_PACKAGE_PATHS "${ARG_FIND_PACKAGE_PATHS}"
    )
  endif()

  if(NOT ARG_INSTALL_IS_UNIX_SYSTEM_WIDE)
    mdt_set_target_install_rpath_property(
      TARGET ${ARG_TARGET}
      PATHS .
    )
  endif()

  set(targetExportName ${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}Targets)

  set(runtimeComponentArguments)
  if(ARG_RUNTIME_COMPONENT)
    set(runtimeComponentArguments COMPONENT ${ARG_RUNTIME_COMPONENT})
  endif()

  set(developmentComponentArguments)
  if(ARG_DEVELOPMENT_COMPONENT)
    set(developmentComponentArguments COMPONENT ${ARG_DEVELOPMENT_COMPONENT})
  endif()

  install(
    TARGETS ${ARG_TARGET}
    EXPORT ${targetExportName}
    RUNTIME
      DESTINATION "${ARG_RUNTIME_DESTINATION}"
      ${runtimeComponentArguments}
    LIBRARY
      DESTINATION "${ARG_LIBRARY_DESTINATION}"
      NAMELINK_SKIP
      ${runtimeComponentArguments}
    ARCHIVE
      DESTINATION "${ARG_ARCHIVE_DESTINATION}"
      ${developmentComponentArguments}
    INCLUDES
      DESTINATION "${ARG_INCLUDES_DESTINATION}"
  )

  get_target_property(targetType ${ARG_TARGET} TYPE)
  if(${targetType} STREQUAL SHARED_LIBRARY)
    install(
      TARGETS ${ARG_TARGET}
      LIBRARY
        DESTINATION "${ARG_LIBRARY_DESTINATION}"
        NAMELINK_ONLY
        ${developmentComponentArguments}
    )
  endif()

  set(fileWithoutExtensionArgument)
  if(ARG_INCLUDES_FILE_WITHOUT_EXTENSION)
    set(fileWithoutExtensionArgument FILE_WITHOUT_EXTENSION)
  endif()

  mdt_install_include_directory(
    DIRECTORY "${ARG_INCLUDES_DIRECTORY}"
    DESTINATION "${ARG_INCLUDES_DESTINATION}"
    FILE_EXTENSIONS ${ARG_INCLUDES_FILE_EXTENSIONS}
    ${fileWithoutExtensionArgument}
    ${developmentComponentArguments}
  )

  if(ARG_ADDITIONAL_INCLUDES_FILES)
    install(
      FILES "${ARG_ADDITIONAL_INCLUDES_FILES}"
      DESTINATION "${ARG_INCLUDES_DESTINATION}"
      ${developmentComponentArguments}
    )
  endif()

  install(
    EXPORT ${targetExportName}
    DESTINATION ${ARG_LIBRARY_DESTINATION}/cmake/${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}
    NAMESPACE ${ARG_EXPORT_NAMESPACE}
    FILE ${targetExportName}.cmake
    ${developmentComponentArguments}
  )

  mdt_install_package_config_file(
    TARGETS ${ARG_TARGET}
    TARGETS_EXPORT_FILE ${targetExportName}.cmake
    FILE ${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}Config.cmake
    DESTINATION ${ARG_LIBRARY_DESTINATION}/cmake/${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}
    ${developmentComponentArguments}
  )

  if(ARG_VERSION)
    mdt_install_package_config_version_file(
      VERSION ${ARG_VERSION}
      COMPATIBILITY ${ARG_VERSION_COMPATIBILITY}
      FILE ${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}ConfigVersion.cmake
      DESTINATION ${ARG_LIBRARY_DESTINATION}/cmake/${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}
      ${developmentComponentArguments}
    )
  endif()

endfunction()
