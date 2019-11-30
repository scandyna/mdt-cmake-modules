# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtInstallLibrary
# -----------------
#
# Headers in various project layouts
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# TODO: Module ideas: MdtInstallIcludes
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
#          |-Mdt_Led_autogen
#          |   |-include
#          |   |-moc_predefs.h
#          |-libMdt_Led.so
#          |-Makefile
#          |-MdtLedExport.h
#
# We can see that a lot of files and directories are generated in the build tree.
# In above example, only ``MdtLedExport.h`` has to be installed, but not ``moc_predefs.h``.
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
#
# .. command:: mdt_install_include_files
#
# Install include files::
#
#   mdt_install_include_files(
#     DIRECTORY <dir>
#     DESTINATION <dir>
#     [FILE_EXTENSIONS ext1 [ext2 ...]]
#     [FILE_WITHOUT_EXTENSION]
#     [COMPONENT <component>]
#   )
#
#
# .. command:: mdt_install_interface_include_directories
#
# Install the headers for each directory listed in the ``INTERFACE_INCLUDE_DIRECTORIES`` property of a target::
#
#   mdt_install_interface_include_directories(
#     TARGET <target>
#     DESTINATION <dir>
#     [FILE_EXTENSIONS ext1 [ext2 ...]]
#     [FILE_WITHOUT_EXTENSION]
#     BINARY_DIR_INCLUDES_DESTINATION <dir>
#     [BINARY_DIR_INCLUDES_FILE_EXTENSIONS ext1 [ext2 ...]]
#     [COMPONENT <component>]
#   )
#
# The headers of all directories specified in the ``INTERFACE_INCLUDE_DIRECTORIES`` property of ``target`` will be installed.
#
# See also :command:`mdt_install_include_directory()`
#
# TODO: will not work for headers in BUILD directories:
# - Will copy unwanted directory structure (all subdirectories generated by CMake, f.ex)
# - If FILE_WITHOUT_EXTENSION is set, will also copy files like Makefile
#
# Example of something (current!) that will fail:
#
# .. code-block:: cmake
#
#   target_include_directories(Mdt_ItemEditor
#     PUBLIC
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
#       $<INSTALL_INTERFACE:include>
#     PRIVATE
#       $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Impl>
#   )
#
# NOTE: use mdt_install_include_directory() for all that is not in ${CMAKE_BINARY_DIR}.
# Also give optional directories to ignore ?
# For that is in BUILD tree, use mdt_install_include_files() .
#
# mdt_install_include_directory() will copy the source directory structures (subdirectories),
# mdt_install_include_files() will copy given files to destination dir.
#
#
# TODO: seems difficult to solve properly. Should:
#  - Specify explicitly which directories containing includes to install in mdt_install_library()
#  - Specify explicitly other files to install (f.ex. exports)
#  - Maybe target property ``INSTALL_INCLUDE_DIRECTORIES`` + ``INSTALL_ADDITIONAL_INCLUDE_FILES`` + ``INSTALL_ADDITIONAL_INCLUDE_FILES_DESTINATION`` (could be set by mdt_add_library()).
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
# to the destination specified by ``INCLUDES_DESTINATION`` using :command:`mdt_install_interface_include_directories()`.
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
#       EXPORT_NAMESPACE ${EXPORT_NAMESPACE}
#   )
#
# As result, the export name of ``target`` (which will be the name of the IMPORTED target for the consumer of the package)
# will be ``${EXPORT_NAMESPACE}${EXPORT_NAME}``.
# The library base name will also be ``${EXPORT_NAMESPACE}${EXPORT_NAME}``.
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
# TODO: problem by running app
#
# Using installed shared libraries in your development
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# TODO: Module ideas: MdtRuntimeEvironment
#
# Introduction
# """"""""""""
#
# On Linux, only using system wide installed libraries
# will not cause any problem.
#
# In practice, libraries that are not available on the system
# (for example the latest version of Qt5) will be installed
# in a directory that is not known by the loader.
#
# When developping your own libraries,
# you probably not want to install them system wide.
#
# By using CMake on Linux, depending on one package
# providing shared libraries in one directory will not cause problems.
#
# Take a (simplified) Qt5 installation as example::
#
#   ~/opt
#      |-Qt5
#         |-5.13.1
#             |gcc_64
#                 |-lib
#                    |-cmake
#                    |-libQt5Core.so
#                    |-libQt5Gui.so
#                    |-libQt5Widgets.so
#
# Your project depends on Qt5 Widgets:
#
# .. code-block:: cmake
#
#   find_package(Qt5 COMPONENTS Widgets REQUIRED)
#   add_executable(myApp source.cpp)
#   target_link_libraries(myApp Qt5::Widgets)
#
# On Linux, ``myApp`` will build and run in the build tree out of the box.
#
# This is because CMake handles the ``RPATH``.
# ``myApp`` will have a entry in its ``RUNPATH`` pointing to the absolute path
# of the installed Qt5 library (for example ``/home/you/opt/Qt5/5.13.1/gcc_64/lib``).
#
# You can experiment it with ``objdump``::
#
#   objdump -x myApp | less
#
# While ``myApp`` depends on ``libQt5Widgets.so``,
# ``libQt5Widgets.so`` itself also depends on ``libQt5Gui.so``,
# ``libQt5Core.so`` and other shared libraries.
# All of those dependencies are resolved at runtime
# because Qt5's libraries are shipped with their ``RUNPATH`` pointing to ``$ORIGIN``.
#
# Problems comes when installing different projects,
# providing shared libraries, in different locations.
# This is, for example, the case when using a package manager like
# `Conan <https://conan.io/>`_ .
#
# Lets take a example of 2 installed libraries::
#
#   ~opt
#     |-MdtItemModel
#     |    |-lib
#     |       |-cmake
#     |       |-libMdt0ItemModel.so
#     |
#     |-MdtItemEditor
#          |-lib
#             |-cmake
#             |-libMdt0ItemEditor.so
#
# Here, ``MdtItemEditor`` depends on ``MdtItemModel``.
#
# Your project depends on MdtItemEditor:
#
# .. code-block:: cmake
#
#   find_package(Mdt0 COMPONENTS ItemEditor REQUIRED)
#   add_executable(myApp source.cpp)
#   target_link_libraries(myApp Mdt0::ItemEditor)
#
# The dependencies are resolved transitively,
# so we don't care about finding ``MdtItemModel``
# (and its own dependencies) ourselve.
#
# On Linux, CMake will generate a build system that can build ``myApp``.
#
# This time, running ``myApp`` in the build tree will fail.
# This is because ``libMdt0ItemEditor.so`` cannot find ``libMdt0ItemModel.so``.
#
# At this stage we are in a dependency management problem,
# that is not trivial to solve with CMake directly.
#
# TODO: see below, seems to be solvable with CMake..
#
# A solution would be to use a package manager that takes this issue into account.
#
# For example, see `Conan env_info <https://docs.conan.io/en/latest/reference/conanfile/methods.html#method-package-info-env-info>`_ .
#
#
# Using environment path as CMake property
# """"""""""""""""""""""""""""""""""""""""
#
# .. command:: mdt_target_libraries_to_library_env_path
#
# Get a list of full path to the directory for each dependency of a target::
#
#   mdt_target_libraries_to_library_env_path(<out_var> TARGET <target>)
#
# Example:
#
# .. code-block:: cmake
#
#   add_executable(myApp main.cpp)
#
#   target_link_libraries(myApp
#     PRIVATE Mdt0::ItemEditor
#   )
#
#   set(myAppEnv)
#   mdt_target_libraries_to_library_env_path(myAppEnv TARGET myApp)
#
# ``myAppEnv`` will contain a generator expression to build a environment path.
#
# On Linux::
#
#   LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:$ENV{LD_LIBRARY_PATH}
#
#
# On Windows::
#
#   PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:$ENV{PATH}
#
#
# .. command:: mdt_set_test_library_env_path
#
# Set the ``ENVIRONMENT`` property to a test with paths
# to the libraries the test links to::
#
#   mdt_set_test_library_env_path(NAME <test-name> TARGET <test-target>)
#
# Will get the libraries defined in the ``LINK_LIBRARIES`` property of ``test-target``,
# then the ``INTERFACE_LINK_LIBRARIES`` for each dependency.
#
# Example:
#
# .. code-block:: cmake
#
#   add_executable(myApp main.cpp)
#
#   target_link_libraries(myApp
#     PRIVATE Mdt0::ItemEditor
#   )
#
#   add_test(NAME RunMyApp COMMAND myApp)
#   mdt_set_test_library_env_path(NAME RunMyApp TARGET myApp)
#
# This will set the ``ENVIRONMENT`` property to the test like this:
#
# .. code-block:: cmake
#
#   set_tests_properties(RunMyApp
#     PROPERTIES
#       ENVIRONMENT
#         "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:$ENV{LD_LIBRARY_PATH}"
#   )
#
# Using environment path in the terminal
# """"""""""""""""""""""""""""""""""""""
#
# TODO: describe Conan generator + document usage of launching a executable without CTest
#

include(MdtTargetProperties)
include(MdtPackageConfigHelpers)

###########################
# ENV part - # TODO Move
############################

function(mdt_target_libraries_to_library_env_path out_var)

  set(options "")
  set(oneValueArgs TARGET)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_target_libraries_to_library_env_path(): ${ARG_TARGET} is not a valid target")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_target_libraries_to_library_env_path(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(pathList)
  set(directDependencies)
  get_target_property(directDependencies ${ARG_TARGET} LINK_LIBRARIES)
  if(directDependencies)
    foreach(directDependency ${directDependencies})
      if(TARGET ${directDependency})
        string(APPEND pathList ":\$<TARGET_FILE_DIR:${directDependency}>")
      else()
        message(WARNING "mdt_target_libraries_to_library_env_path(): library ${directDependency} will be ignored because it is not a TARGET")
        continue()
      endif()
      set(interfaceLinkDependencies)
      get_target_property(interfaceLinkDependencies ${directDependency} INTERFACE_LINK_LIBRARIES)
      if(interfaceLinkDependencies)
        foreach(interfaceLinkDependency ${interfaceLinkDependencies})
          if(TARGET ${interfaceLinkDependency})
            string(APPEND pathList ":\$<TARGET_FILE_DIR:${interfaceLinkDependency}>")
          else()
            message(WARNING "mdt_target_libraries_to_library_env_path(): library ${interfaceLinkDependency} will be ignored because it is not a TARGET")
            continue()
          endif()
        endforeach()
      endif(interfaceLinkDependencies)
    endforeach()
  endif(directDependencies)

  set(pathName)
  if(APPLE)
    set(pathName "DYLD_LIBRARY_PATH")
  elseif(UNIX)
    set(pathName "LD_LIBRARY_PATH")
  elseif(WIN32)
    set(pathName "PATH")
  else()
    message(FATAL_ERROR "mdt_target_libraries_to_library_env_path(): unknown operating system")
  endif()

  set(currentEnvPath "$ENV{${pathName}}")

  set(envPath)
  if(pathList)
    set(envPath "${pathName}=$<SHELL_PATH${pathList}>")
    if(currentEnvPath)
      string(APPEND envPath ":${currentEnvPath}")
    endif()
  else()
    if(currentEnvPath)
      set(envPath "${pathName}=${currentEnvPath}")
    endif()
  endif()

  set(${out_var} ${envPath} PARENT_SCOPE)

endfunction()


function(mdt_set_test_library_env_path)

  set(options "")
  set(oneValueArgs NAME TARGET)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_NAME)
    message(FATAL_ERROR "mdt_set_test_library_env_path(): mandatory argument NAME missing")
  endif()
  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_set_test_library_env_path(): ${ARG_TARGET} is not a valid target")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_set_test_library_env_path(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  mdt_target_libraries_to_library_env_path(envPath TARGET ${ARG_TARGET})
  if(envPath)
    set_tests_properties(${ARG_NAME} PROPERTIES ENVIRONMENT "${envPath}")
  endif()

endfunction()

###########################
# Includes part - # TODO Move
############################


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
      EXPORT_NAMESPACE ${ARG_EXPORT_NAMESPACE}
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

  install(
    TARGETS ${ARG_TARGET}
    LIBRARY
      DESTINATION "${ARG_LIBRARY_DESTINATION}"
      NAMELINK_ONLY
      ${developmentComponentArguments}
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
    mdt_install_package_config_version_file(
      VERSION ${ARG_VERSION}
      COMPATIBILITY ${ARG_VERSION_COMPATIBILITY}
      FILE ${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}ConfigVersion.cmake
      DESTINATION ${ARG_LIBRARY_DESTINATION}/cmake/${ARG_INSTALL_NAMESPACE}${ARG_EXPORT_NAME}
      ${developmentComponentArguments}
    )
  endif()

endfunction()
