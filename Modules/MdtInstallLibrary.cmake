# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtInstallLibrary
# -----------------
#
# Install a library
# ^^^^^^^^^^^^^^^^^
#
# TODO Public and Private dependencies
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
