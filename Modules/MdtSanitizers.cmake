# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtSanitizers
# -------------
#
# List of sanitizers:
#  - ASan
#  - HWASan ?
#  - LSan ?
#  - MSan
#  - UBSan
#  - TSan
#
# TODO: see also value sanitizer
#
# AddressSanitizer
# ^^^^^^^^^^^^^^^^
#
# .. command:: mdt_is_address_sanitizer_available
#
# Check if AddressSanitizer is available::
#
#   mdt_is_address_sanitizer_available(var)
#
# Example:
#
# .. code-block:: cmake
#
#   mdt_is_address_sanitizer_available(addressSanitizerIsAvailable)
#   if(addressSanitizerIsAvailable)
#     ...
#   endif()
#
# The rules to deduce if AddressSanitizer is available are based on:
#   - https://github.com/google/sanitizers/wiki/AddressSanitizer
#
#
# .. command:: mdt_add_address_sanitizer_option_if_available
#
# Add a option, by calling :command:`option()`, to enable AddressSanitizer if available::
#
#   mdt_add_address_sanitizer_option_if_available(var HELP_STRING [INITIAL_VALUE])
#
# Example:
#
# .. code-block:: cmake
#
#   mdt_add_address_sanitizer_option_if_available(SANITIZER_ENABLE_ADDRESS
#     HELP_STRING "Enable address sanitizer for Debug and RelWithDebInfo build"
#     INITIAL_VALUE OFF
#   )
#   if(SANITIZER_ENABLE_ADDRESS)
#     mdt_build_with_address_sanitizer(BUILD_TYPES Debug RelWithDebInfo)
#   endif()
#
#
# See also :command:`mdt_is_address_sanitizer_available()`.
#
#
# .. command:: mdt_build_address_thread_sanitizer
#
# Build with support for AddressSanitizer::
#
#   mdt_build_address_thread_sanitizer(
#     BUILD_TYPES type1 [[type2 ...]
#   )
#
# Note that this function will not check the availability of ASan,
# but simply passes the appropriate flags.
#
#
# ThreadSanitizer
# ^^^^^^^^^^^^^^^
#
# .. command:: mdt_is_thread_sanitizer_available
#
# Check if ThreadSanitizer is available::
#
#   mdt_is_thread_sanitizer_available(var)
#
# Example:
#
# .. code-block:: cmake
#
#   mdt_is_thread_sanitizer_available(threadSanitizerIsAvailable)
#   if(threadSanitizerIsAvailable)
#     ...
#   endif()
#
# The rules to deduce if ThreadSanitizer is available are based on:
#   - https://clang.llvm.org/docs/ThreadSanitizer.html
#   - https://github.com/google/sanitizers/wiki/ThreadSanitizerCppManual
#
# .. command:: mdt_add_thread_sanitizer_option_if_available
#
# Add a option, by calling :command:`option()`, to enable ThreadSanitizer if available::
#
#   mdt_add_thread_sanitizer_option_if_available(var HELP_STRING [INITIAL_VALUE])
#
# Example:
#
# .. code-block:: cmake
#
#   mdt_add_thread_sanitizer_option_if_available(SANITIZER_ENABLE_THREAD
#     HELP_STRING "Enable thread sanitizer for Instrumented and RelWithDebInfo build (can be incompatible with other sanitizers)"
#     INITIAL_VALUE OFF
#   )
#   if(SANITIZER_ENABLE_THREAD)
#     mdt_build_with_thread_sanitizer(BUILD_TYPES Instrumented RelWithDebInfo)
#   endif()
#
#
# See also :command:`mdt_is_thread_sanitizer_available()`.
#
#
# .. command:: mdt_build_with_thread_sanitizer
#
# Build with support for ThreadSanitizer::
#
#   mdt_build_with_thread_sanitizer(
#     BUILD_TYPES type1 [[type2 ...]
#   )
#
# Note that this function will not check the availability of TSan,
# but simply passes the appropriate flags.
#
#
# .. command:: mdt_set_test_tsan_options
#
# Pass TSAN_OPTIONS as `ENVIRONMENT` property of a test::
#
#   mdt_set_test_tsan_options(
#     NAME test
#     OPTIONS options1 [options2...]
#   )
#
# While running a executable with ThreadSanitizer,
# some runtime options can be passed.
# This is done by setting those options to the TSAN_OPTIONS.
#
# For example on Linux::
#
#   TSAN_OPTIONS="ignore_noninstrumented_modules=true verbosity=1"
#
# Usage exemple:
#
# .. code-block:: cmake
#
#   mdt_set_test_tsan_options(
#     NAME SomeTest
#     OPTIONS ignore_noninstrumented_modules=true verbosity=1
#   )
#
# See also https://github.com/google/sanitizers/wiki/ThreadSanitizerFlags
#

include(MdtRuntimeEnvironment)

function(mdt_is_thread_sanitizer_available out_var)

  if(WIN32 OR CYGWIN)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  set(supportedCpuArchs x86_64 aarch64 arm64 powerpc64 powerpc64le)
  if(NOT CMAKE_SYSTEM_PROCESSOR IN_LIST supportedCpuArchs)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  set(compilerId)
  if(CMAKE_CXX_COMPILER_ID)
    set(compilerId "${CMAKE_CXX_COMPILER_ID}")
  else()
    set(compilerId "${CMAKE_C_COMPILER_ID}")
  endif()
  if(NOT compilerId)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  set(supportedCompilers "AppleClang" "Clang" "GNU")
  if(NOT compilerId IN_LIST supportedCompilers)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  set(compilerVersion)
  if(CMAKE_CXX_COMPILER_VERSION)
    set(compilerVersion ${CMAKE_CXX_COMPILER_VERSION})
  else()
    set(compilerVersion ${CMAKE_C_COMPILER_VERSION})
  endif()
  if(NOT compilerVersion)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  if(${compilerId} MATCHES "Clang")
    if(${compilerVersion} VERSION_LESS 3.2)
      set(${out_var} FALSE PARENT_SCOPE)
      return()
    endif()
  endif()

  if(${compilerId} STREQUAL "GNU")
    if(${compilerVersion} VERSION_LESS 4.8)
      set(${out_var} FALSE PARENT_SCOPE)
      return()
    endif()
  endif()

  set(${out_var} TRUE PARENT_SCOPE)

endfunction()


function(mdt_add_thread_sanitizer_option_if_available var)

  set(options)
  set(oneValueArgs HELP_STRING INITIAL_VALUE)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_HELP_STRING)
    message(FATAL_ERROR "mdt_add_thread_sanitizer_option_if_available(): HELP_STRING argument missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_add_thread_sanitizer_option_if_available(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  mdt_is_thread_sanitizer_available(threadSanitizerIsAvailable)
  if(threadSanitizerIsAvailable)
    option(${var} "${ARG_HELP_STRING}" ${ARG_INITIAL_VALUE})
  endif()

endfunction()


function(mdt_build_with_thread_sanitizer)

  set(options)
  set(oneValueArgs)
  set(multiValueArgs BUILD_TYPES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_BUILD_TYPES)
    message(FATAL_ERROR "mdt_build_with_thread_sanitizer(): BUILD_TYPES argument expects at least one build type")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_build_with_thread_sanitizer(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  foreach(buildType ${ARG_BUILD_TYPES})
    add_compile_options($<$<CONFIG:${buildType}>:-fsanitize=thread>)
    link_libraries($<$<CONFIG:${buildType}>:-fsanitize=thread>)
  endforeach()

endfunction()


function(mdt_set_test_tsan_options)

  set(options)
  set(oneValueArgs NAME)
  set(multiValueArgs OPTIONS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_NAME)
    message(FATAL_ERROR "mdt_set_test_tsan_options(): NAME argument missing")
  endif()
  if(NOT ARG_OPTIONS)
    message(FATAL_ERROR "mdt_set_test_tsan_options(): OPTIONS argument expects at least one option")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_set_test_tsan_options(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  string(REPLACE ";" " " tsanOptions "${ARG_OPTIONS}")

  mdt_append_test_environment_variables_string(
    NAME ${ARG_NAME}
    VARIABLES_STRING "${tsanOptions}"
  )

endfunction()
