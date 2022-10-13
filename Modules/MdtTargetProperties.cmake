# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.


function(mdt_target_is_shared_library out_var)

  set(options)
  set(oneValueArgs TARGET)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_TARGET)
    message(FATAL_ERROR "mdt_target_is_shared_library(): mandatory argument TARGET missing")
  endif()
  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_target_is_shared_library(): ${ARG_TARGET} is not a valid target")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_target_is_shared_library(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(result)
  get_target_property(targetType ${ARG_TARGET} TYPE)
  if(${targetType} STREQUAL "SHARED_LIBRARY")
    set(result TRUE)
  else()
    set(result FALSE)
  endif()

  set(${out_var} ${result} PARENT_SCOPE)

endfunction()


function(mdt_target_is_object_library out_var)

  set(options)
  set(oneValueArgs TARGET)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_TARGET)
    message(FATAL_ERROR "mdt_target_is_object_library(): mandatory argument TARGET missing")
  endif()
  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_target_is_object_library(): ${ARG_TARGET} is not a valid target")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_target_is_object_library(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(result)
  get_target_property(targetType ${ARG_TARGET} TYPE)
  if(${targetType} STREQUAL "OBJECT_LIBRARY")
    set(result TRUE)
  else()
    set(result FALSE)
  endif()

  set(${out_var} ${result} PARENT_SCOPE)

endfunction()


function(mdt_is_conan_runtime_target_genex out_var)

  set(options)
  set(oneValueArgs ITEM)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_ITEM)
    message(FATAL_ERROR "mdt_is_conan_runtime_target_genex(): mandatory argument ITEM missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_is_conan_runtime_target_genex(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  string(REGEX MATCH "CONAN_LIB::" matchingString ${ARG_ITEM})
  if("${matchingString}" STREQUAL "")
    set(result FALSE)
  else()
    set(result TRUE)
  endif()

  set(${out_var} ${result} PARENT_SCOPE)

endfunction()


function(mdt_target_file_genex out_var)

  set(options)
  set(oneValueArgs TARGET)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_TARGET)
    message(FATAL_ERROR "mdt_target_file_genex(): mandatory argument TARGET missing")
  endif()
  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_target_file_genex(): ${ARG_TARGET} is not a valid target")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_target_file_genex(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  message(WARNING "mdt_target_file_genex() is not reliable and should not be used. For more details, see https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/12")

  set(targetFileGenex)

  set(runtimeTargetTypes STATIC_LIBRARY MODULE_LIBRARY SHARED_LIBRARY OBJECT_LIBRARY EXECUTABLE)
  get_target_property(targetType ${ARG_TARGET} TYPE)
  if(${targetType} IN_LIST runtimeTargetTypes)
    set(targetFileGenex $<TARGET_FILE:${ARG_TARGET}>)
  elseif(${targetType} STREQUAL "INTERFACE_LIBRARY")
    # Maybe we have a Conan INTERFACE target.
    # The dependencies of this target should contain the runtime targets
    set(conanRuntimeTargetsGenex)
    get_target_property(interfaceLinkDependencies ${ARG_TARGET} INTERFACE_LINK_LIBRARIES)
    foreach(item ${interfaceLinkDependencies})
      mdt_is_conan_runtime_target_genex(isConanRuntimeTargetGenex ITEM ${item})
      if(${isConanRuntimeTargetGenex})
        # Just add each genex without any separator
        set(conanRuntimeTargetsGenex ${conanRuntimeTargetsGenex}${item})
      endif()
    endforeach()
    set(targetFileGenex $<TARGET_FILE:${conanRuntimeTargetsGenex}>)
  else()
    message(FATAL_ERROR "mdt_target_file_genex(): ${ARG_TARGET} is a unknown type: ${targetType}")
  endif()

  set(${out_var} ${targetFileGenex} PARENT_SCOPE)

endfunction()


function(mdt_set_target_install_rpath_property)

  set(options)
  set(oneValueArgs TARGET)
  set(multiValueArgs PATHS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_TARGET)
    message(FATAL_ERROR "mdt_set_target_install_rpath_property(): mandatory argument TARGET missing")
  endif()
  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_set_target_install_rpath_property(): ${ARG_TARGET} is not a valid target")
  endif()
  if(NOT ARG_PATHS)
    message(FATAL_ERROR "mdt_set_target_install_rpath_property(): PATHS argument requires at least 1 path")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_set_target_install_rpath_property(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(rpathPathList)
  foreach(path ${ARG_PATHS})
    set(rpathPath)
    if("${path}" STREQUAL ".")
      set(rpathPath "$ORIGIN")
    else()
      set(rpathPath "$ORIGIN/${path}")
    endif()
    list(APPEND rpathPathList "${rpathPath}")
  endforeach()

  set_target_properties(${ARG_TARGET} PROPERTIES INSTALL_RPATH "${rpathPathList}")

endfunction()
