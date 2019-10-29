# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtInstallNamespacePackageConfigFile
# ------------------------------------
#
# Generate and install a namespace package config file::
#
#   mdt_install_namespace_package_config_file(
#     INSTALL_NAMESPACE InstallNameSpace
#     DESTINATION destination
#     [COMPONENT <component>]
#     [VERSION version]
#     [VERSION_COMPATIBILITY <AnyNewerVersion|SameMajorVersion|ExactVersion>]
#   )
#
# The optional ``COMPONENT`` argument will be passed to the install() command called internally.
# If the optional ``VERSION`` is given, in which case ``VERSION_COMPATIBILITY`` also becomes mandatory,
# a package config version file will also be generated and installed.
#
# TODO: if version support is directly added here, se also mdt_install_package_config_file()
# to have the same support.
# Or, split into:
#  - mdt_install_package_config_file()
#  - mdt_install_package_config_version_file()
#  - mdt_install_namespace_package_config_file()
#  - mdt_install_namespace_package_config_version_file()
#
# TODO Also, the module could be called MdtPackageConfigHelpers (which matches known CMakePackageConfigHelpers)
#
# Example::
#
#   include(GNUInstallDirs)
#   mdt_install_namespace_package_config_file(
#     INSTALL_NAMESPACE Mdt0
#     DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0
#     VERSION ${PROJECT_VERSION}
#     VERSION_COMPATIBILITY ExactVersion
#   )
#
# This will generate a package config file and a package config version file and install them in::
#
#   ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0/Mdt0Config.cmake
#   ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0/Mdt0ConfigVersion.cmake
#
# Those files will allow the component syntax of find_package().
# Example of a consumer CMakeLists.txt::
#
#   find_package(Mdt0 0.1.2 COMPONENTS Led REQUIRED)
#
# Above statement will refer to the following package config file::
#
#   ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0Led/Mdt0LedConfig.cmake
#

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
