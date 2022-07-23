include(MdtRuntimeEnvironment)

add_test(
  NAME RunTableEditor
  COMMAND tableEditor
)



# TODO: document the problem of generator expression
#       Understand if we can provide the dependencies at cmake processing time
#       For proper multi-config version, maybe not
#
# Problem 1) (INTERFACE_)LINK_LIBRARIES declared as generator expressions
#
# Problem 2) Conan does not provide a proper TARGET TYPE,
#            either once generator expression resolved
#            see cmakedeps_macros.cmake, conan_package_library_targets()
#
#
# Clarifications: list use cases
#
#   get list of shared libraries paths)
#
#   set runtime environment)
#
#
# Should compromise.
# Document that generator expressions are not supported
# (maybe basic parsing to remove them ? Helpers in CMake ?)
#
# Should be able to extract genexp.
# Count $< then count down >
#
# Test with LINK_LIBRARIES just after found targets's paths


# TODO: see LINK_LIBRARIES

# TODO: design ! example: function to add list to list, also see what CMake offers (maybe LIST APPEND, simply?)

# TODO: check no doubles in tree resolution

# NOTE: current version allready solves to after CMake generation !

# Begin with a sandbox module


function(display_target)

  set(options "")
  set(oneValueArgs TARGET)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  # TODO: see ARG_KEYWORDS_MISSING_VALUES (cmake 3.15)
  
  message("* TARGET: ${ARG_TARGET}")
  
  get_target_property(targetType ${ARG_TARGET} TYPE)
  message("*  TYPE: ${targetType}")

  get_target_property(linkLibraries ${ARG_TARGET} LINK_LIBRARIES)
  message("*  LINK_LIBRARIES: ${linkLibraries}")
  
  get_target_property(interfaceLinkLibrariesRaw ${ARG_TARGET} INTERFACE_LINK_LIBRARIES)
  message("*  INTERFACE_LINK_LIBRARIES (RAW): ${interfaceLinkLibrariesRaw}")
  
  string(GENEX_STRIP "${interfaceLinkLibrariesRaw}" interfaceLinkLibraries)
  message("*  INTERFACE_LINK_LIBRARIES: ${interfaceLinkLibraries}")
  
endfunction()


function(get_direct_dependnecies out_deps)

  set(options "")
  set(oneValueArgs TARGET)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  get_target_property(linkLibraries ${ARG_TARGET} LINK_LIBRARIES)
  foreach(library ${linkLibraries})
    list(APPEND allDeps "${library}")
  endforeach()

  get_target_property(interfaceLinkLibrariesRaw ${ARG_TARGET} INTERFACE_LINK_LIBRARIES)
  string(GENEX_STRIP "${interfaceLinkLibrariesRaw}" interfaceLinkLibraries)
  foreach(library ${interfaceLinkLibraries})
    list(APPEND allDeps "${library}")
  endforeach()

  set(${out_deps} ${allDeps} PARENT_SCOPE)

endfunction()


message("******** Main sandbox *********")

display_target(TARGET tableEditor)

get_direct_dependnecies(tableEditorDependencies TARGET tableEditor)
foreach(library ${tableEditorDependencies})
  if(TARGET ${library})
    message("- item: ${library}")
    display_target(TARGET ${library})
    
    get_direct_dependnecies(depenenciesL2 TARGET ${library})
    foreach(depL2 ${depenenciesL2})
      message("- item: ${depL2}")
      if(TARGET ${depL2})
        display_target(TARGET ${depL2})
      endif()
    endforeach()
    
  endif()
endforeach()

# get_target_property(linkLibraries tableEditor LINK_LIBRARIES)
# foreach(library ${linkLibraries})
#   if(TARGET ${library})
#     display_target(TARGET ${library})
#     
#     
#     
#   endif()
# endforeach()

message("******** Main sandbox END *********")

mdt_set_test_library_env_path(NAME RunTableEditor TARGET tableEditor)

# get_test_property(RunTableEditor ENVIRONMENT envPath)
# message("RunTableEditor ENVIRONMENT: ${envPath}")
