# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtPackageConfigHelpers
# ---------------------------
#
# These commands are available:
#  - :command:`mdt_get_target_export_name()`
#  - :command:`mdt_install_package_config_file()`
#  - :command:`mdt_install_package_config_version_file()`
#  - :command:`mdt_install_namespace_package_config_file()`
#  - :command:`mdt_install_namespace_package_config_version_file()`
#
# Get the export name of a target
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_get_target_export_name
#
# Get the export name of a target::
#
#   mdt_get_target_export_name(out_var target)
#
# Example of a target that does not define any export property:
#
# .. code-block:: cmake
#
#   add_library(Mdt_Led led.cpp)
#
#   mdt_get_target_export_name(exportName Mdt_Led)
#   # exportName will contain Mdt_Led
#
# Example of a target that define the ``EXPORT_NAME`` property:
#
# .. code-block:: cmake
#
#   add_library(Mdt_Led led.cpp)
#   set_target_properties(Mdt_Led
#     PROPERTIES
#       EXPORT_NAME Led
#   )
#
#   mdt_get_target_export_name(exportName Mdt_Led)
#   # exportName will contain Led
#
# Example of a target that define the ``EXPORT_NAME`` and ``INSTALL_NAMESPACE`` properties:
#
# .. code-block:: cmake
#
#   add_library(Mdt_Led led.cpp)
#   set_target_properties(Mdt_Led
#     PROPERTIES
#       EXPORT_NAME Led
#       INSTALL_NAMESPACE Mdt0
#   )
#
#   mdt_get_target_export_name(exportName Mdt_Led)
#   # exportName will contain Mdt0::Led
#
# Notice that the ``INSTALL_NAMESPACE`` property was set without passing the ``::``.
#
# TODO This is confusing !! The property should be renamed EXPORT_NAMESPACE !
#
# Generate package configuration file
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_install_package_config_file
#
# Generate and install a package config file including find dependencies::
#
#   mdt_install_package_config_file(
#     TARGETS targets
#     TARGETS_EXPORT_FILE <targets-export-file>
#     FILE <package-config-file>
#     DESTINATION <destination>
#     [COMPONENT component]
#   )
#
# CMake can generate a package config file using the couple of
# ``install(TARGETS target EXPORT export-name)`` and ``install(EXPORT export-name)`` .
# Currently, CMake does not generate ``find_dependency()`` for the dependencies of the targets.
# This file must be written by the author, for example ``MyPackageConfig.cmake``:
#
# .. code-block:: cmake
#
#   # Content of MyPackageConfig.cmake
#   find_dependency(DependencyA)
#   find_dependency(DependencyB)
#   include("${CMAKE_CURRENT_LIST_DIR}/MyPackageTargets.cmake")
#
# This is not ideal, because we have to repeat that we passed as public dependencies to ``target_link_libraries()`` .
#
# See also this issue: https://gitlab.kitware.com/cmake/cmake/issues/17006
#
# As workaround, ``mdt_install_package_config_file()``
# will generate such file and install it.
#
# This solution is inpired from the BCMExport module: https://github.com/boost-cmake/bcm/blob/master/share/bcm/cmake/BCMExport.cmake
#
# Example (see also :command:`mdt_set_target_package_properties_if_not()` and :command:`mdt_get_target_package_name()`):
#
# .. code-block:: cmake
#
#   add_library(Mdt_ItemEditor_Widgets sourc1.cpp sourc2.cpp ...)
#   target_link_libraries(Mdt_ItemEditor_Widgets PUBLIC Mdt::ItemModel Qt5::Widgets)
#
#   set_target_properties(Mdt_ItemEditor_Widgets
#     PROPERTIES
#       EXPORT_NAME ItemEditor_Widgets
#       INSTALL_NAMESPACE Mdt0::
#   )
#
#   # This was allready set if Mdt_ItemModel have been installed using mdt_install_library()
#   set_target_properties(Mdt_ItemModel
#     PROPERTIES
#       EXPORT_NAME ItemModel
#       INSTALL_NAMESPACE Mdt0::
#   )
#
#   # This was allready set if Mdt_ItemModel have been installed using mdt_install_library()
#   mdt_set_target_package_properties_if_not(
#     TARGET Mdt_ItemModel
#     PACKAGE_NAME Mdt0ItemModel
#   )
#
#   # If you also want external libraries, like Qt5, to be found automatically
#   # when using Mdt_ItemEditor_Widgets ( by calling find_package(Mdt0 COMPONENT ItemEditor_Widgets) ),
#   # the package name of the used Qt5 libraries could be defined.
#   # This should be done in the top level CMakeLists.txt.
#   # See also if this is a good practice or not (maybe finding Qt5 should be explicit in the user project).
#   mdt_set_target_package_properties_if_not(
#     TARGET Qt5::Widgets
#     PACKAGE_NAME Qt5Widgets
#   )
#
#   install(
#     TARGETS Mdt_ItemEditor_Widgets
#     EXPORT MdtItemEditor_WidgetsTargets
#     RUNTIME
#       DESTINATION ${CMAKE_INSTALL_BINDIR}
#       COMPONENT Mdt_ItemEditor_Widgets_Runtime
#     LIBRARY
#       DESTINATION ${CMAKE_INSTALL_LIBDIR}
#       COMPONENT Mdt_ItemEditor_Widgets_Runtime
#     ARCHIVE
#       DESTINATION ${CMAKE_INSTALL_LIBDIR}
#       COMPONENT Mdt_ItemEditor_Widgets_Dev
#   )
#
#   install(
#     EXPORT MdtItemEditor_WidgetsTargets
#     DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0ItemEditor_Widgets
#     NAMESPACE Mdt0::
#     FILE Mdt0ItemEditor_WidgetsTargets.cmake
#     COMPONENT Mdt_ItemEditor_Widgets_Dev
#   )
#
#   mdt_install_package_config_file(
#     TARGETS Mdt_ItemEditor_Widgets
#     TARGETS_EXPORT_FILE Mdt0ItemEditor_WidgetsTargets.cmake
#     FILE Mdt0ItemEditor_WidgetsConfig.cmake
#     DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0ItemEditor_Widgets
#     COMPONENT Mdt_ItemEditor_Widgets_Dev
#   )
#
# Above example will generate the Mdt0ItemEditor_WidgetsConfig.cmake with a content similar to:
#
# .. code-block:: cmake
#
#   find_dependency(Mdt0ItemModel)
#   find_dependency(Qt5Widgets)
#   include("${CMAKE_CURRENT_LIST_DIR}/Mdt0ItemEditor_WidgetsTargets.cmake")
#
# The rules to install the generated file are also set calling a install() command.
#
# Generate package version file
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_install_package_config_version_file
#
# Generate and install a package config version file::
#
#   mdt_install_package_config_version_file(
#     VERSION <major.minor.patch>
#     COMPATIBILITY <AnyNewerVersion|SameMajorVersion|ExactVersion>
#     FILE <package-config-file>
#     DESTINATION <destination>
#     [COMPONENT component]
#   )
#
# Internally, :command:`write_basic_package_version_file()` from the ``CMakePackageConfigHelpers``
# module is used to generate the version file. A :command:`install()` will then add the install rules.
#
# Example:
#
# .. code-block:: cmake
#
#   include(GNUInstallDirs)
#   mdt_install_package_config_version_file(
#     VERSION ${PROJECT_VERSION}
#     COMPATIBILITY ExactVersion
#     FILE "${CMAKE_CURRENT_BINARY_DIR}/Mdt0LedConfigVersion.cmake"
#     DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0Led
#     COMPONENT Mdt_Led_Dev
#   )
#
# Generate namespace package configuration file
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_install_namespace_package_config_file
#
# Generate and install a namespace package config file::
#
#   mdt_install_namespace_package_config_file(
#     INSTALL_NAMESPACE InstallNameSpace
#     DESTINATION destination
#     [COMPONENT <component>]
#   )
#
# The optional ``COMPONENT`` argument will be passed to the install() command called internally.
#
# Example:
#
# .. code-block:: cmake
#
#   include(GNUInstallDirs)
#   mdt_install_namespace_package_config_file(
#     INSTALL_NAMESPACE Mdt0
#     DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0
#     VERSION ${PROJECT_VERSION}
#     VERSION_COMPATIBILITY ExactVersion
#   )
#
# This will generate a package config file and install it in::
#
#   ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0/Mdt0Config.cmake
#
# This file will allow the usage of the component syntax of find_package().
# Example of a consumer CMakeLists.txt:
#
# .. code-block:: cmake
#
#   find_package(Mdt0 COMPONENTS Led REQUIRED)
#
# Above statement will refer to the install namespace config file::
#
#   ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0/Mdt0Config.cmake
#
# Which then will refer to the following package config file::
#
#   ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0Led/Mdt0LedConfig.cmake
#
# To also support a version at install namespace level, also see :command:`mdt_install_namespace_package_config_version_file()`
#
# Generate namespace package version file
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_install_namespace_package_config_version_file
#
# Generate and install a namespace package config file::
#
#   mdt_install_namespace_package_config_version_file(
#     INSTALL_NAMESPACE InstallNameSpace
#     VERSION <major.minor.patch>
#     COMPATIBILITY <AnyNewerVersion|SameMajorVersion|ExactVersion>
#     DESTINATION <destination>
#     [COMPONENT component]
#   )
#
# The optional ``COMPONENT`` argument will be passed to the install() command called internally.
#
# Example:
#
# .. code-block:: cmake
#
#   include(GNUInstallDirs)
#   mdt_install_namespace_package_config_version_file(
#     INSTALL_NAMESPACE Mdt0
#     VERSION ${PROJECT_VERSION}
#     COMPATIBILITY ExactVersion
#     DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0
#     COMPONENT Mdt_Dev
#   )
#
# This will generate a package config version file and install it in::
#
#   ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0/Mdt0ConfigVersion.cmake
#

include(MdtTargetPackageProperties)
include(CMakePackageConfigHelpers)


function(mdt_get_target_export_name out_var target)

  if(NOT TARGET ${target})
    message(FATAL_ERROR "mdt_get_target_export_name(): ${target} is not a valid target")
  endif()

  get_target_property(exportName ${target} EXPORT_NAME)
  get_target_property(installNamespace ${target} INSTALL_NAMESPACE)

  if(installNamespace)
    set(${out_var} ${installNamespace}${exportName} PARENT_SCOPE)
  else()
    set(${out_var} ${exportName} PARENT_SCOPE)
  endif()

endfunction()


function(mdt_install_package_config_file)

  set(options)
  set(oneValueArgs TARGETS_EXPORT_FILE FILE DESTINATION COMPONENT)
  set(multiValueArgs TARGETS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_TARGETS)
    message(FATAL_ERROR "mdt_install_package_config_file(): no target provided")
  endif()
  if(NOT ARG_TARGETS_EXPORT_FILE)
    message(FATAL_ERROR "mdt_install_package_config_file(): mandatory argument TARGETS_EXPORT_FILE missing")
  endif()
  if(NOT ARG_FILE)
    message(FATAL_ERROR "mdt_install_package_config_file(): mandatory argument FILE missing")
  endif()
  if(NOT ARG_DESTINATION)
    message(FATAL_ERROR "mdt_install_package_config_file(): mandatory argument DESTINATION missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_set_target_package_name_if_not(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(packageConfigFileContent "")
  # Generate commands to find the dependencies of each target of this package
  foreach(target ${ARG_TARGETS})
    if(NOT TARGET ${target})
      message(FATAL_ERROR "mdt_install_package_config_file(): ${target} is not a valid target")
    endif()
    string(APPEND packageConfigFileContent "# Find dependencies for target ${target} (may be empty)")
    get_target_property(targetDependencies ${target} INTERFACE_LINK_LIBRARIES)
    foreach(dependency ${targetDependencies})
      if(TARGET ${dependency})
        mdt_target_package_properties_to_find_package_arguments(dependencyFindPackageArguments ${dependency})
        if(dependencyFindPackageArguments)
          string(APPEND packageConfigFileContent "find_package(${dependencyFindPackageArguments} QUIET REQUIRED)\n")
        endif()
      endif()
    endforeach()
  endforeach()
  # Generate the statements to include the targets export file + additionnal needed module
  string(APPEND packageConfigFileContent "include(\"\${CMAKE_CURRENT_LIST_DIR}/${ARG_TARGETS_EXPORT_FILE}\")\n")
#   string(APPEND packageConfigFileContent "include(\"\${CMAKE_CURRENT_LIST_DIR}/MdtTargetPackageProperties.cmake\")\n")
  # Generate commands to set the package properties for each target of this package
  foreach(target ${ARG_TARGETS})
    mdt_get_target_export_name(importTarget ${target})
    string(APPEND packageConfigFileContent "# Set package properties for target ${importTarget}\n")
    mdt_target_package_properties_to_set_target_properties_arguments(targetPackageProperties ${target})
    if(targetPackageProperties)
      string(APPEND packageConfigFileContent "get_target_property(targetPackageName ${importTarget} INTERFACE_FIND_PACKAGE_NAME)\n")
      string(APPEND packageConfigFileContent "if(NOT targetPackageName)\n")
      string(APPEND packageConfigFileContent "  set_target_properties(${importTarget} ${targetPackageProperties})\n")
      string(APPEND packageConfigFileContent "endif()\n")
    endif()
  endforeach()

  set(packageConfigFile "${CMAKE_CURRENT_BINARY_DIR}/${ARG_FILE}")
  file(WRITE "${packageConfigFile}" "${packageConfigFileContent}")

  # Find the module containig mdt_set_target_package_name_if_not()
#   find_file(
#     MdtTargetPackagePropertiesFilePath
#     NAMES MdtTargetPackageProperties.cmake
#     PATHS ${CMAKE_MODULE_PATH}
#   )
#   if(NOT MdtTargetPackagePropertiesFilePath)
#     message(FATAL_ERROR "mdt_install_package_config_file(): unable to locate MdtTargetPackageProperties.cmake")
#   endif()

  if(ARG_COMPONENT)
    install(
      FILES "${packageConfigFile}"
      DESTINATION ${ARG_DESTINATION}
      COMPONENT "${ARG_COMPONENT}"
    )
  else()
    install(
      FILES "${packageConfigFile}"
      DESTINATION ${ARG_DESTINATION}
    )
  endif()

endfunction()


function(mdt_install_package_config_version_file)

  set(options)
  set(oneValueArgs VERSION COMPATIBILITY FILE DESTINATION COMPONENT)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_VERSION)
    message(FATAL_ERROR "mdt_install_package_config_version_file(): mandatory argument VERSION missing")
  endif()
  if(NOT ARG_COMPATIBILITY)
    message(FATAL_ERROR "mdt_install_package_config_version_file(): mandatory argument COMPATIBILITY missing")
  endif()
  if(NOT ARG_FILE)
    message(FATAL_ERROR "mdt_install_package_config_version_file(): mandatory argument FILE missing")
  endif()
  if(NOT ARG_DESTINATION)
    message(FATAL_ERROR "mdt_install_package_config_version_file(): mandatory argument DESTINATION missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_install_package_config_version_file(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  write_basic_package_version_file("${ARG_FILE}"
    VERSION ${ARG_VERSION}
    COMPATIBILITY ${ARG_COMPATIBILITY}
  )

  set(componentArgument)
  if(ARG_COMPONENT)
    set(componentArgument COMPONENT ${ARG_COMPONENT})
  endif()

  install(
    FILES "${ARG_FILE}"
    DESTINATION "${ARG_DESTINATION}"
    ${componentArgument}
  )

endfunction()


function(mdt_install_namespace_package_config_file)

  # TODO Review !
  set(options)
  set(oneValueArgs INSTALL_NAMESPACE DESTINATION COMPONENT VERSION VERSION_COMPATIBILITY)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_INSTALL_NAMESPACE)
    message(FATAL_ERROR "mdt_install_namespace_package_config_file(): mandatory argument INSTALL_NAMESPACE missing")
  endif()
  if(NOT ARG_DESTINATION)
    message(FATAL_ERROR "mdt_install_namespace_package_config_file(): mandatory argument DESTINATION missing")
  endif()
  if(ARG_VERSION AND NOT ARG_VERSION_COMPATIBILITY)
    message(FATAL_ERROR "mdt_install_namespace_package_config_file(): a VERSION is present, but VERSION_COMPATIBILITY is missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_install_namespace_package_config_file(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  message("INSTALL_NAMESPACE: ${ARG_INSTALL_NAMESPACE}")
  message("DESTINATION: ${ARG_DESTINATION}")
  message("ARG_COMPONENT: ${ARG_COMPONENT}")

  set(config_file "${CMAKE_CURRENT_BINARY_DIR}/${ARG_INSTALL_NAMESPACE}Config.cmake")
  file(WRITE "${config_file}" "if(NOT ${ARG_INSTALL_NAMESPACE}_FIND_COMPONENTS)\n")
  file(APPEND "${config_file}" "  set(${ARG_INSTALL_NAMESPACE}_NOT_FOUND_MESSAGE \"The ${ARG_INSTALL_NAMESPACE} package requires at least one component\")\n")
  file(APPEND "${config_file}" "  set(${ARG_INSTALL_NAMESPACE}_FOUND False)\n")
  file(APPEND "${config_file}" "  return()\n")
  file(APPEND "${config_file}" "else()\n")
  file(APPEND "${config_file}" "  set(${ARG_INSTALL_NAMESPACE}_FOUND TRUE)\n")
  file(APPEND "${config_file}" "endif()\n")
  file(APPEND "${config_file}" "\n")
  file(APPEND "${config_file}" "foreach(component \${${ARG_INSTALL_NAMESPACE}_FIND_COMPONENTS})\n")
  file(APPEND "${config_file}" "  find_package(\n")
  file(APPEND "${config_file}" "    ${ARG_INSTALL_NAMESPACE}\${component}\n")
  file(APPEND "${config_file}" "    QUIET\n")
  file(APPEND "${config_file}" "    CONFIG\n")
  file(APPEND "${config_file}" "    PATHS \"\${CMAKE_CURRENT_LIST_DIR}/..\" NO_DEFAULT_PATH\n")
  file(APPEND "${config_file}" "  )\n")
  file(APPEND "${config_file}" "  if(NOT ${ARG_INSTALL_NAMESPACE}\${component}_FOUND AND \${${ARG_INSTALL_NAMESPACE}_FIND_REQUIRED_\${component}})\n")
  file(APPEND "${config_file}" "    set(${ARG_INSTALL_NAMESPACE}_NOT_FOUND_MESSAGE \"Failed to find ${ARG_INSTALL_NAMESPACE}::\${component}\")\n")
  file(APPEND "${config_file}" "    set(${ARG_INSTALL_NAMESPACE}_FOUND False)\n")
  file(APPEND "${config_file}" "    break()\n")
  file(APPEND "${config_file}" "  endif()\n")
  file(APPEND "${config_file}" "endforeach()\n")

  if(ARG_COMPONENT)
    message("Component install")
    install(
      FILES "${config_file}"
      DESTINATION "${ARG_DESTINATION}"
      COMPONENT "${ARG_COMPONENT}"
    )
  else()
    install(
      FILES "${config_file}"
      DESTINATION "${ARG_DESTINATION}"
    )
  endif()

endfunction()
