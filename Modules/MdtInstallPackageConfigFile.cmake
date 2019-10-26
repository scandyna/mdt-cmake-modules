# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtInstallPackageConfigFile
# ---------------------------
#
# Write a package config file to including find dependencies::
#
#   mdt_install_package_config_file(
#     TARGETS targets
#     TARGETS_EXPORT_FILE <targets-export-file>
#     FILE <package-config-file>
#     DESTINATION <destination>
#     [COMPONENT component]
#   )
#
# Currently CMake can generate a package config file using the couple of
# ``install(TARGETS target EXPORT export-name)`` and ``install(EXPORT export-name)`` .
# Currently, CMake does not generate ``find_dependency()`` for the dependencies of the targets.
# This file must be written by the author, for example ``MyPackageConfig.cmake``::
#
#   find_dependency(DependencyA)
#   find_dependency(DependencyB)
#   include("${CMAKE_CURRENT_LIST_DIR}/MyPackageTargets.cmake")
#
# This is not ideal, because we have to repeat that we passed as public dependencies to ``target_link_libraries()`` .
#
# See also this issue: https://gitlab.kitware.com/cmake/cmake/issues/17006
#
# To temporarly solve this issue, ``mdt_install_package_config_file()``
# will generate such file and install it.
#
# This solution is inpired from the BCMExport module: https://github.com/boost-cmake/bcm/blob/master/share/bcm/cmake/BCMExport.cmake
#
# Example::
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
# Above example will generate the Mdt0ItemEditor_WidgetsConfig.cmake with a content similar to::
#
#   find_dependency(Mdt0ItemModel)
#   find_dependency(Qt5Widgets)
#   include("${CMAKE_CURRENT_LIST_DIR}/Mdt0ItemEditor_WidgetsTargets.cmake")
#
# The rules to install the generated file are also set calling a install() command.
#
# Internally, this function is also used::
#
#   mdt_get_target_package_name(out_var target)
#
# If the given ``target`` has a property named ``INTERFACE_FIND_PACKAGE_NAME`` it will be used
# to set the package name to ``out_var`` .
#
# Set the package name property to a target if not allready set::
#
#   mdt_set_target_package_name_if_not(
#     TARGET target
#     PACKAGE_NAME package-name
#   )
#

function(mdt_get_target_package_name out_var target)

  if(NOT TARGET ${target})
    message(FATAL_ERROR "mdt_get_target_package_name(): ${target} is not a valid target")
  endif()

  get_target_property(targetPackageName ${target} INTERFACE_FIND_PACKAGE_NAME)

  set(${out_var} ${targetPackageName} PARENT_SCOPE)

endfunction()

function(mdt_set_target_package_name_if_not)

  set(options)
  set(oneValueArgs TARGET PACKAGE_NAME)
  set(multiValueArgs)
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
  endif()

endfunction()
