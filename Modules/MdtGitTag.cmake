# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtGitTag
# ---------
#
# .. command:: mdt_get_git_tag
#
# Get the Gets the current checkout tag::
#
#   mdt_get_git_tag(<out_var>
#     [GIT_REPOSITORY_DIR dir]
#     [DEFAULT_VERSION version]
#     [FAIL_IF_NO_TAG]
#   )
#
# ``out_var`` will contain the result of calling:
#
# .. code-block:: shell
#
#   git describe --exact-match --tags
#
# Git will be invoked from the ``${GIT_REPOSITORY_DIR}`` directory if defined,
# otherwise from ``${CMAKE_SOURCE_DIR}``.
#
# If current checkout has no tag, ``out_var`` will contain the value passed as ``DEFAULT_VERSION`` if defined,
# otherwise it will be empty.
#
# If the optional ``FAIL_IF_NO_TAG`` is set and current checkout has no tag,
# a fatal error will occur.
#
# Example:
#
# .. code-block:: cmake
#
#   find_package(Git REQUIRED)
#   find_package(MdtCMakeModules REQUIRED)
#
#   include(MdtGitTag)
#
#   mdt_get_git_tag(GIT_TAG_VERSION DEFAULT_VERSION 0.0.0-unknown)
#   project(MyProject VERSION ${GIT_TAG_VERSION})
#
# TODO Document the regenearte / call cmake / CI workflow
# To force regenerate, call cmake from build root: cmake .
#
# TODO: mybe split function to get git tag,
# and a other function mdt_get_version_from_git_tag()
# OR: just mdt_get_version_from_git_tag() ?

function(mdt_get_git_tag out_var)

  set(options FAIL_IF_NO_TAG)
  set(oneValueArgs GIT_REPOSITORY_DIR DEFAULT_VERSION)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT GIT_EXECUTABLE)
    message(FATAL_ERROR "mdt_get_git_tag(): GIT_EXECUTABLE is not defined. Did you run find_package(Git) before calling this function ?")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_get_git_tag(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(workDirectory)
  if(ARG_GIT_REPOSITORY_DIR)
    set(workDirectory "${ARG_GIT_REPOSITORY_DIR}")
  else()
    set(workDirectory "${CMAKE_SOURCE_DIR}")
  endif()

  execute_process(
    COMMAND "${GIT_EXECUTABLE}" describe --exact-match --tags
    WORKING_DIRECTORY "${workDirectory}"
    RESULT_VARIABLE result
    OUTPUT_VARIABLE gitTag
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  if(result AND ARG_FAIL_IF_NO_TAG)
    message(FATAL_ERROR "mdt_get_git_tag(): failed to get git tag, git returned: ${result}")
  endif()

  message("gitTag: ${gitTag}")
  # TODO: should formate the version corectly
  set(gitTagVersion)
  if(gitTag)
    set(gitTagVersion "${gitTag}")
  elseif(ARG_DEFAULT_VERSION)
    set(gitTagVersion "${ARG_DEFAULT_VERSION}")
  endif()

  set(${out_var} ${gitTagVersion} PARENT_SCOPE)

endfunction()
