# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

function(require_list_is_empty listVarName)

  list(LENGTH ${listVarName} length)
  if(${length} GREATER 0)
    message(FATAL_ERROR "Test failed: list '${listVarName}' is not empty.\nlist content: ${${listVarName}}")
  endif()

endfunction()

function(require_list_is_of_length listVarName expectedLength)

  list(LENGTH ${listVarName} length)

  if( NOT (${length} EQUAL ${expectedLength}) )
    message(FATAL_ERROR "Test failed: list '${listVarName}' has a lenght of ${length}, expected ${expectedLength}.\nlist content: ${${listVarName}}")
  endif()

endfunction()

function(require_list_contains listVarName value)

  list(FIND ${listVarName} ${value} index)
  if(${index} LESS 0)
    message(FATAL_ERROR "Test failed: list '${listVarName}' does not contain ${value}.\nlist content: ${${listVarName}}")
  endif()

endfunction()

function(require_list_not_contains listVarName value)

  list(FIND ${listVarName} ${value} index)
  if(${index} GREATER_EQUAL 0)
    message(FATAL_ERROR "Test failed: list '${listVarName}' does contain ${value}.\nlist content: ${${listVarName}}")
  endif()

endfunction()
