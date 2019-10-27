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
#   )
#
# The optional ``COMPONENT`` argument will be passed to the install() command called internally.
#
# Example::
#
#   include(GNUInstallDirs)
#   mdt_install_namespace_package_config_file(
#     INSTALL_NAMESPACE Mdt0
#     DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0
#   )
#
# This will generate a package config file and install it in::
#
#   ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0/Mdt0Config.cmake
#
# This file will allow the component syntax of find_package().
# Example of a consumer CMakeLists.txt::
#
#   find_package(Mdt0 COMPONENTS Led REQUIRED)
#
# Above statement will refer to the following package config file::
#
#   ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0Led/Mdt0LedConfig.cmake
#

function(mdt_install_namespace_package_config_file)
  set(options)
  set(oneValueArgs INSTALL_NAMESPACE DESTINATION COMPONENT)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_INSTALL_NAMESPACE)
    message(FATAL_ERROR "mdt_install_namespace_package_config_file(): mandatory argument INSTALL_NAMESPACE missing")
  endif()
  if(NOT ARG_DESTINATION)
    message(FATAL_ERROR "mdt_install_namespace_package_config_file(): mandatory argument DESTINATION missing")
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
