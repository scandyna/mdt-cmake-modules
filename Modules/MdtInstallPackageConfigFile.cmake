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
# CMake can generate a package config file using the couple of
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
# to set the package name to ``out_var`` , which can be passed as argument to find_package().
# If the given ``target`` also has a property named ``INTERFACE_FIND_PACKAGE_VERSION``, it will be appended to ``out_var``.
# If the given ``target`` also has a property named ``INTERFACE_FIND_PACKAGE_EXACT``, ``EXACT`` will be appended to ``out_var``.
# If the given ``target`` also has a property named ``INTERFACE_FIND_PACKAGE_PATHS``, ``PATHS ${CMAKE_CURRENT_LIST_DIR}/<path1> ${CMAKE_CURRENT_LIST_DIR}/<path2> ...`` will be appended to ``out_var``.
# If the given ``target`` also has a property named ``INTERFACE_FIND_PACKAGE_NO_DEFAULT_PATH``, ``NO_DEFAULT_PATH`` will be appended to ``out_var``.
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
# theire modules together, like Qt5::
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
# or also together, for example as system wide Linux installation::
#
#   mdt_set_target_package_name_if_not(
#     TARGET Mdt_Led
#     PACKAGE_NAME Mdt0Led
#     PACKAGE_VERSION ${PROJECT_VERSION}
#     PACKAGE_VERSION_EXACT
#     PATHS ..
#   )
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
