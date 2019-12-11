# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtAddTest
# ----------
#
# Add a test
# ^^^^^^^^^^^^^
#
# .. command:: mdt_add_test
#
# Add a test::
#
#   mdt_add_test(
#     NAME name
#     TARGET target
#     [DEPENDENCIES dependencies]
#     SOURCE_FILES
#       file1.cpp
#       file2.cpp
#   )
#
# Will a executable target named ``target`` using :command:`add_executable()`,
# then add a test using :command:`add_test()`.
#
# See also :command:`mdt_set_test_library_env_path()`.
#
# Example:
#
# .. code-block:: cmake
#
#   mdt_add_test(
#     NAME MyTest
#     TARGET MyTestTarget
#     DEPENDENCIES My::LibA Qt5::Test
#     SOURCE_FILES
#       MyTest.cpp
#   )
#
# Above example is similar to:
#
# .. code-block:: cmake
#
#   add_executable(
#     MyTestTarget
#     MyTest.cpp
#   )
#
#   target_link_libraries(MyTestTarget
#     PRIVATE My::LibA Qt5::Test
#   )
#
#   add_test(
#     NAME MyTest
#     COMMAND MyTestTarget
#   )
#
#   mdt_set_test_library_env_path(
#     NAME MyTest
#     TARGET MyTestTarget
#   )
#

include(MdtRuntimeEnvironment)


function(mdt_add_test)

  set(options)
  set(oneValueArgs NAME TARGET)
  set(multiValueArgs DEPENDENCIES SOURCE_FILES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_NAME)
    message(FATAL_ERROR "mdt_add_test(): mandatory argument NAME missing")
  endif()
  if(NOT ARG_TARGET)
    message(FATAL_ERROR "mdt_add_test(): mandatory argument TARGET missing")
  endif()
  if(NOT ARG_SOURCE_FILES)
    message(FATAL_ERROR "mdt_add_test(): at least one source file expected")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_add_test(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  add_executable(${ARG_TARGET} ${ARG_SOURCE_FILES})

  if(ARG_DEPENDENCIES)
    target_link_libraries(${ARG_TARGET} PRIVATE ${ARG_DEPENDENCIES})
  endif()

  add_test(NAME ${ARG_NAME} COMMAND ${ARG_TARGET})

  mdt_set_test_library_env_path(NAME ${ARG_NAME} TARGET ${ARG_TARGET})

endfunction()

