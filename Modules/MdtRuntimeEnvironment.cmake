# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

include(MdtTargetDependenciesHelpers)
include(MdtConanBuildInfoReader)


function(mdt_append_test_environment_modification_property_variables_string test_name)

  if(${CMAKE_VERSION} VERSION_LESS "3.22")
    message(FATAL_ERROR "mdt_append_test_environment_modification_property_variables_string() only works with CMake >= 3.22")
  endif()

  if(${ARGC} LESS 2)
    message(FATAL_ERROR "mdt_append_test_environment_modification_property_variables_string(): expected a test name and a variables string")
  endif()

  if(NOT test_name)
    message(FATAL_ERROR "mdt_append_test_environment_modification_property_variables_string(): test name argument missing")
  endif()

  get_test_property(${test_name} ENVIRONMENT_MODIFICATION testEnvirnoment)
  if(testEnvirnoment)
    set(testEnvirnoment "${testEnvirnoment};${ARGN}")
  else()
    set(testEnvirnoment "${ARGN}")
  endif()

  set_tests_properties(${test_name} PROPERTIES ENVIRONMENT_MODIFICATION "${testEnvirnoment}")

endfunction()


function(mdt_append_test_environment_variables_string test_name)

  # message(DEPRECATION "mdt_append_test_environment_variables_string() is deprecated. Consider mdt_append_test_environment_modification_property_variables_string()")

  if(${ARGC} LESS 2)
    message(FATAL_ERROR "mdt_append_test_environment_variables_string(): expected a test name and a variables string")
  endif()

  if(NOT test_name)
    message(FATAL_ERROR "mdt_append_test_environment_variables_string(): test name argument missing")
  endif()

  get_test_property(${test_name} ENVIRONMENT testEnvirnoment)
  if(testEnvirnoment)
    set(testEnvirnoment "${testEnvirnoment};${ARGN}")
  else()
    set(testEnvirnoment "${ARGN}")
  endif()

  set_tests_properties(${test_name} PROPERTIES ENVIRONMENT "${testEnvirnoment}")

endfunction()


function(mdt_target_libraries_to_library_env_path out_var)

  set(options ALWAYS_USE_SLASHES)
  set(oneValueArgs TARGET PATH_LIST_VALUE_STRING_PREFIX)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_target_libraries_to_library_env_path(): ${ARG_TARGET} is not a valid target")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_target_libraries_to_library_env_path(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  mdt_collect_shared_libraries_targets_target_depends_on(sharedLibrariesDependencies TARGET ${ARG_TARGET})

  if(WIN32 AND ARG_ALWAYS_USE_SLASHES)
    foreach(sharedLibraryDependency ${sharedLibrariesDependencies})
        list(APPEND pathList "$<TARGET_FILE_DIR:${sharedLibraryDependency}>")
    endforeach()
  else()
    foreach(sharedLibraryDependency ${sharedLibrariesDependencies})
      list(APPEND pathList "$<SHELL_PATH:$<TARGET_FILE_DIR:${sharedLibraryDependency}>>")
    endforeach()
  endif()

  # TODO: s.a. WINEPATH
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

  set(pathSeparator)
  if(WIN32)
    set(pathSeparator ";")
  else()
    set(pathSeparator ":")
  endif()

  mdt_get_shared_libraries_directories_from_conanbuildinfo_if_exists(conanSharedLibrariesDirs)
  if(UNIX)
    string(REPLACE ";" "${pathSeparator}" conanSharedLibrariesDirs "${conanSharedLibrariesDirs}")
  endif()

  set(currentEnvPath "$ENV{${pathName}}")

  if(WIN32 AND ARG_ALWAYS_USE_SLASHES)
    string(REPLACE "\\" "/" currentEnvPath "${currentEnvPath}")
    string(REPLACE "\\" "/" conanSharedLibrariesDirs "${conanSharedLibrariesDirs}")
  endif()

  set(envPathList)
  list(LENGTH pathList pathListSize)
  if(${pathListSize} GREATER 0)
    list(GET pathList 0 firstPath)
    list(REMOVE_AT pathList 0)
    set(envPathList "${firstPath}")
    foreach(path ${pathList})
      string(APPEND envPathList "${pathSeparator}${path}")
    endforeach()
  endif()

  set(envPathContent)
  if(envPathList)
    string(APPEND envPathContent "${envPathList}")
  endif()
  if(conanSharedLibrariesDirs)
    if(envPathContent)
      string(APPEND envPathContent "${pathSeparator}")
    endif()
    string(APPEND envPathContent "${conanSharedLibrariesDirs}")
  endif()
  if(currentEnvPath)
    if(envPathContent)
      string(APPEND envPathContent "${pathSeparator}")
    endif()
    string(APPEND envPathContent "${currentEnvPath}")
  endif()

  set(envPath "${pathName}=${ARG_PATH_LIST_VALUE_STRING_PREFIX}${envPathContent}")

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
  if(WIN32)
    string(REPLACE ";" "\\;" envPath "${envPath}")
  endif()
  if(envPath)
#     set_tests_properties(${ARG_NAME} PROPERTIES ENVIRONMENT "${envPath}")
    mdt_append_test_environment_variables_string(${ARG_NAME} "${envPath}")
  endif()

endfunction()


function(mdt_modify_test_library_env_path)

  if(${CMAKE_VERSION} VERSION_LESS "3.22")
    message(FATAL_ERROR "mdt_modify_test_library_env_path() only works with CMake >= 3.22")
  endif()

  set(options "")
  set(oneValueArgs NAME TARGET)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_NAME)
    message(FATAL_ERROR "mdt_modify_test_library_env_path(): mandatory argument NAME missing")
  endif()
  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_modify_test_library_env_path(): ${ARG_TARGET} is not a valid target")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_modify_test_library_env_path(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  mdt_target_libraries_to_library_env_path(envPath TARGET ${ARG_TARGET} PATH_LIST_VALUE_STRING_PREFIX "path_list_prepend:")
  if(WIN32)
    string(REPLACE ";" "\\;" envPath "${envPath}")
  endif()
  if(envPath)
    mdt_append_test_environment_modification_property_variables_string(${ARG_NAME} "${envPath}")
  endif()

endfunction()
