# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtTargetPackageProperties
# --------------------------
#
# Those commands are available:
#  - :command:`mdt_get_target_package_name()`
#  - :command:`mdt_target_package_properties_to_find_package_arguments()`
#  - :command:`mdt_target_package_properties_to_set_target_properties_arguments()`
#  - :command:`mdt_set_target_package_properties_if_not()`
#
#
# .. command:: mdt_get_target_package_name
#
# Get the package name of a target::
#
#   mdt_get_target_package_name(out_var target)
#
# If the given ``target`` has a property named ``INTERFACE_FIND_PACKAGE_NAME`` it will be used
# to set the package name to ``out_var`` , otherwise out_var will be empty.
#
# Get ``INTERFACE_FIND_PACKAGE_*`` target properties as arguments for find_package()
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# This section presents helper functions to :command:`mdt_install_package_config_file()`.
#
# Take a example of a library that will be exported:
#
# .. code-block:: cmake
#
#   project(MdtItemModel VERSION 0.1.2);
#
#   add_library(Mdt_ItemModel sourc1.cpp sourc2.cpp ...)
#
#   set_target_properties(Mdt_ItemModel
#     PROPERTIES
#       EXPORT_NAME ItemModel
#       EXPORT_NAMESPACE Mdt0::
#       INTERFACE_FIND_PACKAGE_NAME Mdt0ItemModel
#       INTERFACE_FIND_PACKAGE_VERSION ${PROJECT_VERSION}
#       INTERFACE_FIND_PACKAGE_EXACT TRUE
#       INTERFACE_FIND_PACKAGE_PATHS ..
#   )
#
#
# .. command:: mdt_target_package_properties_to_find_package_paths_arguments
#
# Generate arguments for find_package()::
#
#   mdt_target_package_properties_to_find_package_paths_arguments(out_var target)
#
# If given ``target`` has both properties ``INTERFACE_FIND_PACKAGE_NAME`` and ``INTERFACE_FIND_PACKAGE_PATHS`` set,
# ``out_var`` will contain arguments of the form:
#
# .. code-block:: cmake
#
#   <package> [version] [EXACT] QUIET PATHS "${CMAKE_CURRENT_LIST_DIR}/<path1>" ["${CMAKE_CURRENT_LIST_DIR}/<path2>" ...] NO_DEFAULT_PATH
#
# otherwise ``out_var`` will be empty.
#
# Example for above defined target:
#
# .. code-block:: cmake
#
#   mdt_target_package_properties_to_find_package_paths_arguments(arguments Mdt_ItemModel)
#
# ``arguments`` will contain:
#
# .. code-block:: cmake
#
#   Mdt0ItemModel 0.1.2 EXACT QUIET PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
#
#
# .. command:: mdt_target_package_properties_to_find_package_arguments
#
# Generate arguments for find_package()::
#
#   mdt_target_package_properties_to_find_package_arguments(out_var target)
#
# If given ``target`` has property ``INTERFACE_FIND_PACKAGE_NAME`` set,
# ``out_var`` will contain arguments of the form:
#
# .. code-block:: cmake
#
#   <package> [version] [EXACT] QUIET REQUIRED
#
# otherwise ``out_var`` will be empty.
#
# Example for above defined target:
#
# .. code-block:: cmake
#
#   mdt_target_package_properties_to_find_package_arguments(arguments Mdt_ItemModel)
#
# ``arguments`` will contain:
#
# .. code-block:: cmake
#
#   Mdt0ItemModel 0.1.2 EXACT QUIET REQUIRED
#
#
# .. command:: mdt_target_package_properties_to_find_package_commands
#
# Generate find_package() commands::
#
#   mdt_target_package_properties_to_find_package_commands(out_var target)
#
# If given ``target`` has no property ``INTERFACE_FIND_PACKAGE_NAME`` set,
# ``out_var`` will be empty.
#
# If given ``target`` has property ``INTERFACE_FIND_PACKAGE_PATHS`` set,
# ``out_var`` will contain 2 :command:`find_package()` commands of the form:
#
# .. code-block:: cmake
#
#   find_package(<package> [version] [EXACT] QUIET PATHS "${CMAKE_CURRENT_LIST_DIR}/<path1>" ["${CMAKE_CURRENT_LIST_DIR}/<path2>" ...] NO_DEFAULT_PATH)
#   if(NOT <package>_FOUND)
#     find_package(<package> [version] [EXACT] QUIET REQUIRED)
#   endif()
#
# If given ``target`` has no property ``INTERFACE_FIND_PACKAGE_PATHS`` set,
# ``out_var`` will contain a single :command:`find_package()` command of the form:
#
# .. code-block:: cmake
#
#   find_package(<package> [version] [EXACT] QUIET REQUIRED)
#
#
#
# Get ``INTERFACE_FIND_PACKAGE_*`` target properties as arguments for set_target_properties()
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_target_package_properties_to_set_target_properties_arguments
#
# Generate arguments for :command:`set_target_properties()`::
#
#   mdt_target_package_properties_to_set_target_properties_arguments(out_var target)
#
# If given ``target`` has no property named ``INTERFACE_FIND_PACKAGE_NAME``, ``out_var`` will be empty.
# Otherwise, ``out_var`` will contain arguments of the form::
#
#     PROPERTIES
#       INTERFACE_FIND_PACKAGE_NAME package-name
#       INTERFACE_FIND_PACKAGE_VERSION version
#       INTERFACE_FIND_PACKAGE_EXACT TRUE
#       INTERFACE_FIND_PACKAGE_PATHS paths
#       INTERFACE_FIND_PACKAGE_NO_DEFAULT_PATH TRUE
#
# The properties other than ``INTERFACE_FIND_PACKAGE_NAME`` are only generated if they exist in ``target`` .
#
# .. command:: mdt_set_target_package_properties_if_not
#
# Set the package properties to a target if not allready set::
#
#   mdt_set_target_package_properties_if_not(
#     TARGET target
#     PACKAGE_NAME package-name
#     [PACKAGE_VERSION version]
#     [PACKAGE_VERSION_EXACT]
#     [PATHS <list of relative paths>]
#     [NO_DEFAULT_PATH]
#   )
#
# If ``target`` allready has the ``INTERFACE_FIND_PACKAGE_NAME`` nothing will be set at all.
#
# Example to set a target package properties for a project that allways distributes
# theire modules together, like Qt5:
#
# .. code-block:: cmake
#
#   mdt_set_target_package_properties_if_not(
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
#   mdt_set_target_package_properties_if_not(
#     TARGET Mdt_Led
#     PACKAGE_NAME Mdt0Led
#     PACKAGE_VERSION ${PROJECT_VERSION}
#     PACKAGE_VERSION_EXACT
#     PATHS ..
#   )


function(mdt_get_target_package_name out_var target)

  if(NOT TARGET ${target})
    message(FATAL_ERROR "mdt_get_target_package_name(): ${target} is not a valid target")
  endif()

  get_target_property(targetPackageName ${target} INTERFACE_FIND_PACKAGE_NAME)

  set(${out_var} ${targetPackageName} PARENT_SCOPE)

endfunction()


function(mdt_target_package_properties_to_find_package_paths_arguments out_var target)

  if(NOT TARGET ${target})
    message(FATAL_ERROR "mdt_target_package_properties_to_find_package_paths_arguments(): ${target} is not a valid target")
  endif()

  set(findPackageArguments)
  get_target_property(targetPackageName ${target} INTERFACE_FIND_PACKAGE_NAME)
  get_target_property(targetPackagePaths ${target} INTERFACE_FIND_PACKAGE_PATHS)
  get_target_property(targetPackagePaths ${target} INTERFACE_FIND_PACKAGE_PATHS)
  if(targetPackageName AND targetPackagePaths)
    get_target_property(targetPackageVersion ${target} INTERFACE_FIND_PACKAGE_VERSION)
    get_target_property(targetPackageVersionExact ${target} INTERFACE_FIND_PACKAGE_EXACT)
    string(APPEND findPackageArguments ${targetPackageName})
    if(targetPackageVersion)
      string(APPEND findPackageArguments " ${targetPackageVersion}")
    endif()
    if(targetPackageVersionExact)
      string(APPEND findPackageArguments " EXACT")
    endif()
    string(APPEND findPackageArguments " PATHS")
    foreach(path ${targetPackagePaths})
      string(APPEND findPackageArguments " \"\${CMAKE_CURRENT_LIST_DIR}/${path}\"")
    endforeach()
    string(APPEND findPackageArguments " NO_DEFAULT_PATH")
  endif()

  set(${out_var} ${findPackageArguments} PARENT_SCOPE)

endfunction()


function(mdt_target_package_properties_to_find_package_arguments out_var target)

  if(NOT TARGET ${target})
    message(FATAL_ERROR "mdt_target_package_properties_to_find_package_arguments(): ${target} is not a valid target")
  endif()

  set(findPackageArguments)
  get_target_property(targetPackageName ${target} INTERFACE_FIND_PACKAGE_NAME)
  if(targetPackageName)
    get_target_property(targetPackageVersion ${target} INTERFACE_FIND_PACKAGE_VERSION)
    get_target_property(targetPackageVersionExact ${target} INTERFACE_FIND_PACKAGE_EXACT)
    string(APPEND findPackageArguments ${targetPackageName})
    if(targetPackageVersion)
      string(APPEND findPackageArguments " ${targetPackageVersion}")
      if(targetPackageVersionExact)
        string(APPEND findPackageArguments " EXACT")
      endif()
    endif()
    string(APPEND findPackageArguments " QUIET REQUIRED")

#     get_target_property(targetPackagePaths ${target} INTERFACE_FIND_PACKAGE_PATHS)
#     if(targetPackagePaths)
#       string(APPEND findPackageArguments " PATHS")
#       foreach(path ${targetPackagePaths})
#         string(APPEND findPackageArguments " \"\${CMAKE_CURRENT_LIST_DIR}/${path}\"")
#       endforeach()
#     endif()
#     get_target_property(noDefaultPath ${target} INTERFACE_FIND_PACKAGE_NO_DEFAULT_PATH)
#     if(noDefaultPath)
#       string(APPEND findPackageArguments " NO_DEFAULT_PATH")
#     endif()
#   endif()

  set(${out_var} ${findPackageArguments} PARENT_SCOPE)

endfunction()


function(mdt_target_package_properties_to_find_package_commands out_var target)

  if(NOT TARGET ${target})
    message(FATAL_ERROR "mdt_target_package_properties_to_find_package_commands(): ${target} is not a valid target")
  endif()

  set(findPackageCommands)
  get_target_property(targetPackageName ${target} INTERFACE_FIND_PACKAGE_NAME)
  if(targetPackageName)
    mdt_target_package_properties_to_find_package_arguments(findPackageArguments ${target})
    get_target_property(targetPackagePaths ${target} INTERFACE_FIND_PACKAGE_PATHS)
    if(targetPackagePaths)
      mdt_target_package_properties_to_find_package_paths_arguments(findPackagePathsArguments ${target})
      string(APPEND findPackageCommands "find_package(${findPackagePathsArguments})\n")
      string(APPEND findPackageCommands "if(NOT ${targetPackageName}_FOUND)\n")
      string(APPEND findPackageCommands "  find_package(${findPackageArguments})\n")
      string(APPEND findPackageCommands "endif()\n")
    else()
      string(APPEND findPackageCommands "find_package(${findPackageArguments})\n")
    endif()
  endif()

  set(${out_var} ${findPackageCommands} PARENT_SCOPE)

endfunction()


function(mdt_target_package_properties_to_set_target_properties_arguments out_var target)

  if(NOT TARGET ${target})
    message(FATAL_ERROR "mdt_target_package_properties_to_set_target_properties_arguments(): ${target} is not a valid target")
  endif()

  set(setTargetPropertiesArguments)
  get_target_property(targetPackageName ${target} INTERFACE_FIND_PACKAGE_NAME)
  if(targetPackageName)
    string(APPEND setTargetPropertiesArguments " PROPERTIES INTERFACE_FIND_PACKAGE_NAME ${targetPackageName}")
    get_target_property(targetPackageVersion ${target} INTERFACE_FIND_PACKAGE_VERSION)
    if(targetPackageVersion)
      string(APPEND setTargetPropertiesArguments " INTERFACE_FIND_PACKAGE_VERSION ${targetPackageVersion}")
      get_target_property(targetPackageVersionExact ${target} INTERFACE_FIND_PACKAGE_EXACT)
      if(targetPackageVersionExact)
        string(APPEND setTargetPropertiesArguments " INTERFACE_FIND_PACKAGE_EXACT TRUE")
      endif()
    endif()
    get_target_property(targetPackagePaths ${target} INTERFACE_FIND_PACKAGE_PATHS)
    if(targetPackagePaths)
      string(APPEND setTargetPropertiesArguments " INTERFACE_FIND_PACKAGE_PATHS \"${targetPackagePaths}\"")
    endif()
    get_target_property(noDefaultPath ${target} INTERFACE_FIND_PACKAGE_NO_DEFAULT_PATH)
    if(noDefaultPath)
      string(APPEND setTargetPropertiesArguments " INTERFACE_FIND_PACKAGE_NO_DEFAULT_PATH TRUE")
    endif()
  endif()

  set(${out_var} ${setTargetPropertiesArguments} PARENT_SCOPE)

endfunction()


function(mdt_set_target_package_properties_if_not)

  set(options PACKAGE_VERSION_EXACT NO_DEFAULT_PATH)
  set(oneValueArgs TARGET PACKAGE_NAME PACKAGE_VERSION)
  set(multiValueArgs PATHS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_TARGET)
    message(FATAL_ERROR "mdt_set_target_package_properties_if_not(): mandatory argument TARGET missing")
  endif()
  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_set_target_package_properties_if_not(): ${ARG_TARGET} is not a valid target")
  endif()
  if(NOT ARG_PACKAGE_NAME)
    message(FATAL_ERROR "mdt_set_target_package_properties_if_not(): mandatory argument PACKAGE_NAME missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_set_target_package_properties_if_not(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
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
