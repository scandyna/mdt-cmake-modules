# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtBuildOptionsUtils
# --------------------
#
# Some helper functions to try to reduce some boilerplate in top level CMakeLists.txt files.
#
# Example:
#
# .. code-block:: cmake
#
#   mdt_set_available_build_types(Debug Release RelWithDebInfo MinSizeRel Instrumented)
#
#   mdt_get_available_optimization_levels(AVAILABLE_OPTIMIZATION_LEVELS)
#
#   set(BUILD_TYPE_INSTRUMENTED_OPTIMIZATION_LEVEL "" CACHE STRING "Set optimization level for Instrumented build")
#   set_property(CACHE BUILD_TYPE_INSTRUMENTED_OPTIMIZATION_LEVEL PROPERTY STRINGS ${AVAILABLE_OPTIMIZATION_LEVELS})
#   if(BUILD_TYPE_INSTRUMENTED_OPTIMIZATION_LEVEL)
#     add_compile_options($<$<CONFIG:Instrumented>:${BUILD_TYPE_INSTRUMENTED_OPTIMIZATION_LEVEL}>)
#   endif()
#
#   option(BUILD_TYPE_INSTRUMENTED_USE_DEBUG_SYMBOLS "Add debug symbols (-g on Gcc/Clang, /DEBUG on MSVC)" ON)
#   if(BUILD_TYPE_INSTRUMENTED_USE_DEBUG_SYMBOLS)
#     mdt_add_debug_symbols_compile_option(BUILD_TYPES Instrumented)
#   endif()
#
#   option(WARNING_AS_ERROR "Threat warnings as errors" OFF)
#   if(MSVC)
#     add_compile_options(/W4)
#     if(WARNING_AS_ERROR)
#       add_compile_options(/WX)
#     endif()
#   else()
#     add_compile_options(-Wall -Wextra)
#     if(WARNING_AS_ERROR)
#       add_compile_options(-Werror)
#     endif()
#   endif()
#
#   mdt_are_sanitizers_available(SANITIZERS_ARE_AVAILABLE)
#   if(SANITIZERS_ARE_AVAILABLE)
#     option(SANITIZER_ENABLE_ADDRESS "Enable address sanitizer for Instrumented build" OFF)
#     option(SANITIZER_ENABLE_LEAK "Enable leak sanitizer for Instrumented build" OFF)
#     option(SANITIZER_ENABLE_UNDEFINED "Enable undefined sanitizer for Instrumented build" OFF)
#     option(SANITIZER_ENABLE_THREAD "Enable thread sanitizer for Instrumented build (can be incompatible with other sanitizers)" OFF)
#   endif()
#
#   if(SANITIZER_ENABLE_ADDRESS)
#     mdt_compile_with_address_sanitizer(BUILD_TYPES Instrumented)
#   endif()
#   if(SANITIZER_ENABLE_LEAK)
#     mdt_compile_with_leak_sanitizer(BUILD_TYPES Instrumented)
#   endif()
#   if(SANITIZER_ENABLE_UNDEFINED)
#     mdt_compile_with_undefined_sanitizer(BUILD_TYPES Instrumented)
#   endif()
#   if(SANITIZER_ENABLE_THREAD)
#     mdt_compile_with_thread_sanitizer(BUILD_TYPES Instrumented)
#   endif()
#
#
# .. command:: mdt_set_available_build_types
#
# Set the list of available build types::
#
#   mdt_set_available_build_types(type1 [type2 ...])
#
# For multi-config generators, each build type
# will be added to ``CMAKE_CONFIGURATION_TYPES`` if not allready present.
#
# For single-config generators, a property will be attached to the ``CMAKE_BUILD_TYPE`` variable:
#
# .. code-block:: cmake
#
#   set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS type1 type2 ...)
#
#
# .. command:: mdt_get_available_optimization_levels
#
# Get the available optimization levels::
#
#   mdt_get_available_optimization_levels(out_var)
#
# Example:
#
# .. code-block:: cmake
#
#   mdt_get_available_optimization_levels(AVAILABLE_OPTIMIZATION_LEVELS)
#
#   # On MSVC, AVAILABLE_OPTIMIZATION_LEVELS will contain /O0 /O1 /O2 /Os
#
#   # On Gcc and Clang, AVAILABLE_OPTIMIZATION_LEVELS will contain -O0 -O1 -O2 -O3 -Os
#
#
# .. command:: mdt_add_debug_symbols_compile_option
#
# Add debug symbols compile options::
#
#   mdt_add_debug_symbols_compile_option(
#     BUILD_TYPES type1 [[type2 ...]
#   )
#
# .. command:: mdt_are_sanitizers_available
#
# Check if sanitizers are available::
#
#   mdt_are_sanitizers_available(out_var)
#
# This can be used to provide options to enable sanitizers if they are available:
#
# .. code-block:: cmake
#
#   mdt_are_sanitizers_available(SANITIZERS_ARE_AVAILABLE)
#   if(SANITIZERS_ARE_AVAILABLE)
#     option(SANITIZER_ENABLE_ADDRESS "Enable address sanitizer for Instrumented build" OFF)
#     option(SANITIZER_ENABLE_LEAK "Enable leak sanitizer for Instrumented build" OFF)
#     option(SANITIZER_ENABLE_UNDEFINED "Enable undefined sanitizer for Instrumented build" OFF)
#     option(SANITIZER_ENABLE_THREAD "Enable thread sanitizer for Instrumented build (can be incompatible with other sanitizers)" OFF)
#   endif()
#
# Note that current implementation is basic.
# It will only check for some CMake variables (OS, compiler).
# The deduction is based on:
#
# - The address sanitizer documentation: https://github.com/google/sanitizers/wiki/AddressSanitizer
# - The anounce from Microsoft: https://devblogs.microsoft.com/cppblog/addresssanitizer-asan-for-windows-with-msvc
#
# This function is candidate to deprecation.
# See https://gitlab.com/scandyna/mdt-cmake-modules/issues/1
#
#
# .. command:: mdt_compile_with_address_sanitizer
#
# Compile with support for address sanitizer::
#
#   mdt_compile_with_address_sanitizer(
#     BUILD_TYPES type1 [[type2 ...]
#   )
#
#
# .. command:: mdt_compile_with_leak_sanitizer
#
# Compile with support for leak sanitizer::
#
#   mdt_compile_with_leak_sanitizer(
#     BUILD_TYPES type1 [[type2 ...]
#   )
#
#
# .. command:: mdt_compile_with_undefined_sanitizer
#
# Compile with support for undefined sanitizer::
#
#   mdt_compile_with_undefined_sanitizer(
#     BUILD_TYPES type1 [[type2 ...]
#   )
#
#
# .. command:: mdt_compile_with_thread_sanitizer
#
# Compile with support for address sanitizer::
#
#   mdt_compile_with_thread_sanitizer(
#     BUILD_TYPES type1 [[type2 ...]
#   )
#
#


function(mdt_set_available_build_types)

  get_property(isMultiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
  if(isMultiConfig)
    foreach(buildType ${ARGV})
      if(NOT "${buildType}" IN_LIST CMAKE_CONFIGURATION_TYPES)
        list(APPEND CMAKE_CONFIGURATION_TYPES "${buildType}")
      endif()
    endforeach()
  else()
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${ARGV})
    if(NOT CMAKE_BUILD_TYPE)
      set(CMAKE_BUILD_TYPE Debug CACHE STRING "")
    endif()
  endif()

endfunction()


function(mdt_get_available_optimization_levels out_var)

  set(optimizationLevels)
  if(MSVC)
    set(optimizationLevels /O0 /O1 /O2 /Os)
  else()
    set(optimizationLevels -O0 -O1 -O2 -O3 -Os)
  endif()

  set(${out_var} ${optimizationLevels} PARENT_SCOPE)

endfunction()


function(mdt_add_debug_symbols_compile_option)

  set(options)
  set(oneValueArgs)
  set(multiValueArgs BUILD_TYPES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_BUILD_TYPES)
    message(FATAL_ERROR "mdt_add_debug_symbols_compile_option(): BUILD_TYPES argument expects at least one build type")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_add_debug_symbols_compile_option(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(debugSymbolsOption)
  if(MSVC)
    set(debugSymbolsOption /DEBUG)
  else()
    set(debugSymbolsOption -g)
  endif()

  foreach(buildType ${ARG_BUILD_TYPES})
    add_compile_options($<$<CONFIG:${buildType}>:${debugSymbolsOption}>)
  endforeach()


endfunction()

# TODO see https://gitlab.com/scandyna/mdt-cmake-modules/issues/1
function(mdt_are_sanitizers_available out_var)

  set(sanitizersAvailable FALSE)
  if(WIN32)
    if(MSVC_VERSION)
      if(${MSVC_VERSION} GREATER_EQUAL 1929)
        set(sanitizersAvailable TRUE)
      endif()
    endif()
  else()
    set(sanitizersAvailable TRUE)
  endif()

  set(${out_var} ${sanitizersAvailable} PARENT_SCOPE)

endfunction()


function(mdt_compile_with_address_sanitizer)

  set(options)
  set(oneValueArgs)
  set(multiValueArgs BUILD_TYPES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_BUILD_TYPES)
    message(FATAL_ERROR "mdt_compile_with_address_sanitizer(): BUILD_TYPES argument expects at least one build type")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_compile_with_address_sanitizer(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  foreach(buildType ${ARG_BUILD_TYPES})
    add_compile_options($<$<CONFIG:${buildType}>:-fsanitize=address>)
    link_libraries($<$<CONFIG:${buildType}>:-fsanitize=address>)
  endforeach()

endfunction()


function(mdt_compile_with_leak_sanitizer)

  set(options)
  set(oneValueArgs)
  set(multiValueArgs BUILD_TYPES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_BUILD_TYPES)
    message(FATAL_ERROR "mdt_compile_with_leak_sanitizer(): BUILD_TYPES argument expects at least one build type")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_compile_with_leak_sanitizer(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  foreach(buildType ${ARG_BUILD_TYPES})
    add_compile_options($<$<CONFIG:${buildType}>:-fsanitize=leak>)
    link_libraries($<$<CONFIG:${buildType}>:-fsanitize=leak>)
  endforeach()

endfunction()


function(mdt_compile_with_undefined_sanitizer)

  set(options)
  set(oneValueArgs)
  set(multiValueArgs BUILD_TYPES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_BUILD_TYPES)
    message(FATAL_ERROR "mdt_compile_with_undefined_sanitizer(): BUILD_TYPES argument expects at least one build type")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_compile_with_undefined_sanitizer(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  foreach(buildType ${ARG_BUILD_TYPES})
    add_compile_options($<$<CONFIG:${buildType}>:-fsanitize=undefined>)
    link_libraries($<$<CONFIG:${buildType}>:-fsanitize=undefined>)
  endforeach()

endfunction()


function(mdt_compile_with_thread_sanitizer)

  set(options)
  set(oneValueArgs)
  set(multiValueArgs BUILD_TYPES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_BUILD_TYPES)
    message(FATAL_ERROR "mdt_compile_with_thread_sanitizer(): BUILD_TYPES argument expects at least one build type")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_compile_with_thread_sanitizer(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  foreach(buildType ${ARG_BUILD_TYPES})
    add_compile_options($<$<CONFIG:${buildType}>:-fsanitize=thread>)
    link_libraries($<$<CONFIG:${buildType}>:-fsanitize=thread>)
  endforeach()

endfunction()
