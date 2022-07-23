# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

project(MdtRuntimeEnvironmentStaticTests LANGUAGES CXX)

include(MdtRuntimeEnvironment)

#############################################################
# NOTE: here we test mainly concatenations
#  Dependency tree is tested in MdtTargetDependenciesHelpers
#############################################################

#############################################################
# Test helpers
#############################################################

function(require_string_starts_with strVarName expectedStart)

  string(FIND "${${strVarName}}" "${expectedStart}" index)
  if(${index} LESS 0)
    message(FATAL_ERROR "Test failed: str does not start with expected content.\nstr: '${${strVarName}}'\nexpected start: '${expectedStart}'")
  endif()

endfunction()


function(require_string_equals_to strVarName expectedStr)

  if( NOT ("${${strVarName}}" STREQUAL "${expectedStr}"))
    message(FATAL_ERROR "Test failed: str is different from the expected one.\nstr: '${${strVarName}}'\nexpected: '${expectedStr}'")
  endif()

endfunction()

#############################################################
# Common libraries used for some tests
#############################################################

add_library(Mdt0::ItemModel SHARED IMPORTED)

add_library(Mdt0::ItemEditor SHARED IMPORTED)
set_target_properties(Mdt0::ItemEditor
  PROPERTIES
    INTERFACE_LINK_LIBRARIES Mdt0::ItemModel
)

add_library(MyAppLib SHARED IMPORTED)
set_target_properties(MyAppLib
  PROPERTIES
    LINK_LIBRARIES Mdt0::ItemEditor
)


#############################################################
# Platform specific tests
#############################################################

if(UNIX AND NOT APPLE)
  add_subdirectory(Linux)
endif()

# if(WIN32)
  add_subdirectory(Windows)
# endif()

#############################################################
# end
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): all static tests passed")
