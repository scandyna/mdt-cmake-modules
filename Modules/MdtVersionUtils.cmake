# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtVersionUtils
# ---------------
#
# .. command:: mdt_get_git_tag
#
# Gets the current checkout tag::
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
#   include(MdtVersionUtils)
#
#   mdt_get_git_tag(GIT_TAG_VERSION DEFAULT_VERSION 0.0.0)
#
# To set the project version, see :command:`mdt_cmake_project_version_from_git_tag()`.
#
#
# .. command:: mdt_dotted_integer_part_from_version_string
#
# Get the doted integer part of a version string::
#
#   mdt_dotted_integer_part_from_version_string(<out_var>
#     VERSION_STRING <version>
#   )
#
# Examples:
#
# .. code-block:: cmake
#
#   mdt_dotted_integer_part_from_version_string(version VERSION_STRING 1.2.3)
#   # version will contain 1.2.3
#
#   mdt_dotted_integer_part_from_version_string(version VERSION_STRING 1.2.3.4)
#   # version will contain 1.2.3.4
#
#   mdt_dotted_integer_part_from_version_string(version VERSION_STRING v1.2.3)
#   # version will contain 1.2.3
#
#   mdt_dotted_integer_part_from_version_string(version VERSION_STRING 1.0.0-alpha)
#   # version will contain 1.0.0
#
#   mdt_dotted_integer_part_from_version_string(version VERSION_STRING v1.0.0-x.7.z.92)
#   # version will contain 1.0.0
#
#
# .. command:: mdt_cmake_project_version_from_git_tag
#
# Get the version from git tag and extract the dotted integer part::
#
#   mdt_cmake_project_version_from_git_tag(<out_var>
#     [GIT_REPOSITORY_DIR dir]
#     [DEFAULT_VERSION version]
#     [FAIL_IF_NO_TAG]
#   )
#
# Will get the git tag using :command:`mdt_get_git_tag()`
# and extract the dotted integer part using :command:`mdt_dotted_integer_part_from_version_string()`.
#
# Example:
#
# .. code-block:: cmake
#
#   find_package(Git REQUIRED)
#   find_package(MdtCMakeModules REQUIRED)
#
#   include(MdtVersionUtils)
#
#   mdt_cmake_project_version_from_git_tag(GIT_TAG_VERSION DEFAULT_VERSION 0.0.0)
#   project(MyProject VERSION ${GIT_TAG_VERSION})
#
#
# Notice that the version is extracted from git tag only when the CMake project is generated.
# Internally, no custom target is added, avoiding generating the project all the time.
# In a CI/CD pipeline, this should not be a issue, because the project is generated
# with a git tag allready set at push time.
# If you have to install/generate a package from the developper machine,
# yout should call ``cmake .`` from the build directory after having set the git tag.
#

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

  if(NOT gitTag AND ARG_DEFAULT_VERSION)
    set(gitTag ${ARG_DEFAULT_VERSION})
  endif()

  set(${out_var} ${gitTag} PARENT_SCOPE)

endfunction()


function(mdt_dotted_integer_part_from_version_string out_var)

  set(options)
  set(oneValueArgs VERSION_STRING)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_dotted_integer_part_from_version_string(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  string(REGEX MATCH "[0-9]*\\.*[0-9]*\\.*[0-9]*\\.*[0-9]" dottedIntegerPart "${ARG_VERSION_STRING}")

  set(${out_var} ${dottedIntegerPart} PARENT_SCOPE)

endfunction()


function(mdt_cmake_project_version_from_git_tag out_var)

  set(options FAIL_IF_NO_TAG)
  set(oneValueArgs GIT_REPOSITORY_DIR DEFAULT_VERSION)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT GIT_EXECUTABLE)
    message(FATAL_ERROR "mdt_cmake_project_version_from_git_tag(): GIT_EXECUTABLE is not defined. Did you run find_package(Git) before calling this function ?")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_cmake_project_version_from_git_tag(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(arguments)
  if(ARG_GIT_REPOSITORY_DIR)
    list(APPEND arguments GIT_REPOSITORY_DIR ${ARG_GIT_REPOSITORY_DIR})
  endif()
  if(ARG_DEFAULT_VERSION)
    list(APPEND arguments DEFAULT_VERSION ${ARG_DEFAULT_VERSION})
  endif()
  if(ARG_FAIL_IF_NO_TAG)
    list(APPEND arguments FAIL_IF_NO_TAG)
  endif()

  mdt_get_git_tag(gitTag ${arguments})

  if(gitTag)
    mdt_dotted_integer_part_from_version_string(version VERSION_STRING ${gitTag})
  endif()

  set(${out_var} ${version} PARENT_SCOPE)

endfunction()
