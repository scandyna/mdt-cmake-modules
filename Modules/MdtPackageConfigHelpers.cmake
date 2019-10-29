# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtPackageConfigHelpers
# ---------------------------
#
# These commands are available:
#  - :command:`mdt_install_package_config_file()`
#  - :command:`mdt_install_package_config_version_file()`
#  - :command:`mdt_set_target_package_name_if_not()`
#  - :command:`mdt_get_target_package_name()`
#  - :command:`mdt_install_namespace_package_config_file()`
#  - :command:`mdt_install_namespace_package_config_version_file()`
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
# Example (see also :command:`mdt_set_target_package_name_if_not()` and :command:`mdt_get_target_package_name()`):
#
# .. code-block:: cmake
#
#   add_library(Mdt_ItemEditor_Widgets sourc1.cpp sourc2.cpp ...)
#   target_link_libraries(Mdt_ItemEditor_Widgets PUBLIC Mdt::ItemModel Qt5::Widgets)
#
#   set_target_properties(Mdt_ItemEditor_Widgets PROPERTIES EXPORT_NAME ItemEditor_Widgets)
#
#   # This was allready set if Mdt_ItemModel have been installed using mdt_install_library()
#   mdt_set_target_package_name_if_not(
#     TARGET Mdt_ItemModel
#     PACKAGE_NAME Mdt0ItemModel
#   )
#
#   # If you also want external libraries, like Qt5, to be found automatically
#   # when using Mdt_ItemEditor_Widgets ( by calling find_package(Mdt0 COMPONENT ItemEditor_Widgets) ),
#   # the package name of the used Qt5 libraries could be defined.
#   # This should be done in the top level CMakeLists.txt.
#   # See also if this is a good practice or not (maybe finding Qt5 should be explicit in the user project).
#   mdt_set_target_package_name_if_not(
#     TARGET Qt5::Widgets
#     PACKAGE_NAME Qt5Widgets
#   )
#
#   install(
#     TARGETS Mdt_ItemEditor_Widgets
#     EXPORT Mdt0ItemEditor_WidgetsTargets
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
#     EXPORT Mdt0ItemEditor_WidgetsTargets
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
# Package name property of a target
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_get_target_package_name
#
# Internally, this function is also used::
#
#   mdt_get_target_package_name(out_var target)
#
# If the given ``target`` has a property named ``INTERFACE_FIND_PACKAGE_NAME`` it will be used
# to set the package name to ``out_var`` , which can be passed as argument to find_package().
# If the given ``target`` also has a property named ``INTERFACE_FIND_PACKAGE_VERSION``, it will be appended to ``out_var``.
# If the given ``target`` also has a property named ``INTERFACE_FIND_PACKAGE_EXACT``, ``EXACT`` will be appended to ``out_var``.
# If the given ``target`` also has a property named ``INTERFACE_FIND_PACKAGE_PATHS``, ``PATHS ${CMAKE_CURRENT_LIST_DIR}/<path1> ${CMAKE_CURRENT_LIST_DIR}/<path2> ...`` will be appended to ``out_var``.
# If the given ``target`` also has a property named ``INTERFACE_FIND_PACKAGE_NO_DEFAULT_PATH``, ``NO_DEFAULT_PATH`` will be appended to ``out_var``.
#
# .. command:: mdt_set_target_package_name_if_not
#
# Set the package name property to a target if not allready set::
#
#   mdt_set_target_package_name_if_not(
#     TARGET target
#     PACKAGE_NAME package-name
#     [PACKAGE_VERSION version]
#     [PACKAGE_VERSION_EXACT]
#     [PATHS <list of relative paths>]
#     [NO_DEFAULT_PATH]
#   )
#
# Example to set a target package name for a project that allways distributes
# theire modules together, like Qt5:
#
# .. code-block:: cmake
#
#   mdt_set_target_package_name_if_not(
#     TARGET Mdt_Led
#     PACKAGE_NAME Mdt0Led
#     PATHS ..
#     NO_DEFAULT_PATH
#   )
#
# Example for a package that can be installed in its own directory,
# for example by using a package manager like Conan,
# or also together, for example as system wide Linux installation:
#
# .. code-block:: cmake
#
#   mdt_set_target_package_name_if_not(
#     TARGET Mdt_Led
#     PACKAGE_NAME Mdt0Led
#     PACKAGE_VERSION ${PROJECT_VERSION}
#     PACKAGE_VERSION_EXACT
#     PATHS ..
#   )
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



function(mdt_get_target_package_name out_var target)

  if(NOT TARGET ${target})
    message(FATAL_ERROR "mdt_get_target_package_name(): ${target} is not a valid target")
  endif()

  get_target_property(targetPackageName ${target} INTERFACE_FIND_PACKAGE_NAME)
  if(targetPackageName)
    get_target_property(targetPackageVersion ${target} INTERFACE_FIND_PACKAGE_VERSION)
    if(targetPackageVersion)
      string(APPEND targetPackageName " ${targetPackageVersion}")
      get_target_property(targetPackageVersionExact ${target} INTERFACE_FIND_PACKAGE_EXACT)
      if(targetPackageVersionExact)
        string(APPEND targetPackageName " EXACT")
      endif()
    endif()
    get_target_property(targetPackagePaths ${target} INTERFACE_FIND_PACKAGE_PATHS)
    if(targetPackagePaths)
      string(APPEND targetPackageName " PATHS")
      foreach(path ${targetPackagePaths})
        string(APPEND targetPackageName " \"\${CMAKE_CURRENT_LIST_DIR}/${path}\"")
      endforeach()
    endif()
    get_target_property(noDefaultPath ${target} INTERFACE_FIND_PACKAGE_NO_DEFAULT_PATH)
    if(noDefaultPath)
      string(APPEND targetPackageName " NO_DEFAULT_PATH")
    endif()
  endif()

  set(${out_var} ${targetPackageName} PARENT_SCOPE)

endfunction()

function(mdt_set_target_package_name_if_not)

  set(options PACKAGE_VERSION_EXACT NO_DEFAULT_PATH)
  set(oneValueArgs TARGET PACKAGE_NAME PACKAGE_VERSION)
  set(multiValueArgs PATHS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_TARGET)
    message(FATAL_ERROR "mdt_set_target_package_name_if_not(): mandatory argument TARGET missing")
  endif()
  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_set_target_package_name_if_not(): ${ARG_TARGET} is not a valid target")
  endif()
  if(NOT ARG_PACKAGE_NAME)
    message(FATAL_ERROR "mdt_set_target_package_name_if_not(): mandatory argument PACKAGE_NAME missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_set_target_package_name_if_not(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  mdt_get_target_package_name(target_package_name ${ARG_TARGET})
  if(NOT target_package_name)
    set_target_properties(${ARG_TARGET} PROPERTIES INTERFACE_FIND_PACKAGE_NAME ${ARG_PACKAGE_NAME})
    if(ARG_PACKAGE_VERSION)
      set_target_properties(${ARG_TARGET} PROPERTIES INTERFACE_FIND_PACKAGE_VERSION ${ARG_PACKAGE_VERSION})
      if(ARG_PACKAGE_VERSION_EXACT)
        set_target_properties(${ARG_TARGET} PROPERTIES INTERFACE_FIND_PACKAGE_EXACT TRUE)
      endif()
    endif()
    if(ARG_PATHS)
      set_target_properties(${ARG_TARGET} PROPERTIES INTERFACE_FIND_PACKAGE_PATHS "${ARG_PATHS}")
    endif()
    if(ARG_NO_DEFAULT_PATH)
      set_target_properties(${ARG_TARGET} PROPERTIES INTERFACE_FIND_PACKAGE_NO_DEFAULT_PATH TRUE)
    endif()
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
  foreach(target ${ARG_TARGETS})
    if(NOT TARGET ${target})
      message(FATAL_ERROR "mdt_install_package_config_file(): ${target} is not a valid target")
    endif()
    string(APPEND packageConfigFileContent "# Find dependencies for target ${target} (may be empty)")
    get_target_property(targetDependencies ${target} INTERFACE_LINK_LIBRARIES)
    foreach(dependency ${targetDependencies})
      if(TARGET ${dependency})
        mdt_get_target_package_name(dependencyPackageName ${dependency})
        if(dependencyPackageName)
          string(APPEND packageConfigFileContent "find_package(${dependencyPackageName} QUIET REQUIRED)\n")
        endif()
      endif()
    endforeach()
  endforeach()
  string(APPEND packageConfigFileContent "include(\"\${CMAKE_CURRENT_LIST_DIR}/${ARG_TARGETS_EXPORT_FILE}\")\n")
  foreach(target ${ARG_TARGETS})
    string(APPEND packageConfigFileContent "# Set package name for target ${target}")
    
  endforeach()

  set(packageConfigFile "${CMAKE_CURRENT_BINARY_DIR}/${ARG_FILE}")
  file(WRITE "${packageConfigFile}" "${packageConfigFileContent}")

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



function(mdt_install_namespace_package_config_file)
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

  # TODO shoud be aware not to find other installed components. See find_package() option (No module, no system paths)
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
