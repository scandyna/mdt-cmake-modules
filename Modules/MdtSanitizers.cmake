# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtSanitizers
# -------------
#
# .. contents:: Known sanitizers
#    :local:
#
# AddressSanitizer (ASan)
# ^^^^^^^^^^^^^^^^^^^^^^^
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
#   - The address sanitizer documentation: https://github.com/google/sanitizers/wiki/AddressSanitizer
#   - The anounce from Microsoft: https://devblogs.microsoft.com/cppblog/addresssanitizer-asan-for-windows-with-msvc
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
# .. command:: mdt_build_with_address_sanitizer
#
# Build with support for AddressSanitizer::
#
#   mdt_build_with_address_sanitizer(
#     [BUILD_TYPES types...]
#   )
#
# Enables AddressSanitizer for available build configurations:
#
# .. code-block:: cmake
#
#   mdt_build_with_address_sanitizer()
#
# The list of available build configurations is got by :command:`mdt_get_available_build_configurations()`.
# It is also possible to specify a custom set of build configurations:
#
# .. code-block:: cmake
#
#   mdt_build_with_address_sanitizer(BUILD_TYPES Debug RelWithDebInfo)
#
#
# Note that this function will not check the availability of ASan,
# but simply passes the appropriate flags.
#
#
# .. command:: mdt_set_test_asan_options
#
# Pass ASAN_OPTIONS as `ENVIRONMENT` property of a test::
#
#   mdt_set_test_asan_options(
#     NAME test
#     OPTIONS options1 [options2...]
#   )
#
# While running a executable with AddressSanitizer,
# some runtime options can be passed.
# This is done by setting those options to the ASAN_OPTIONS.
#
# For example on Linux::
#
#   ASAN_OPTIONS=verbosity=1:malloc_context_size=20
#
# Usage exemple:
#
# .. code-block:: cmake
#
#   mdt_set_test_asan_options(
#     NAME SomeTest
#     OPTIONS verbosity=1 malloc_context_size=20
#   )
#
# See also https://github.com/google/sanitizers/wiki/AddressSanitizerFlags
#
#
# AddressSanitizerLeakSanitizer (LSan)
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# LeakSanitizer is enable by AddressSanitizer by defualt on some platforms.
# It can be enabled without AddressSanitizer, which is currently not supported here.
#
# See also https://github.com/google/sanitizers/wiki/AddressSanitizerLeakSanitizer
#
#
# Hardware-assisted AddressSanitizer (HWASan)
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# Similar to AddressSanitizer, but based on partial hardware assistance.
# HWASan is currently not supported here.
#
# See also https://clang.llvm.org/docs/HardwareAssistedAddressSanitizerDesign.html
#
# MemorySanitizer (MSan)
# ^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_is_memory_sanitizer_available
#
# Check if MemorySanitizer is available::
#
#   mdt_is_memory_sanitizer_available(var)
#
# Example:
#
# .. code-block:: cmake
#
#   mdt_is_memory_sanitizer_available(memorySanitizerIsAvailable)
#   if(memorySanitizerIsAvailable)
#     ...
#   endif()
#
# The rules to deduce if MemorySanitizer is available are based on:
#   - https://github.com/google/sanitizers/wiki/MemorySanitizer
#
#
# .. command:: mdt_add_memory_sanitizer_option_if_available
#
# Add a option, by calling :command:`option()`, to enable MemorySanitizer if available::
#
#   mdt_add_memory_sanitizer_option_if_available(var HELP_STRING [INITIAL_VALUE])
#
# Example:
#
# .. code-block:: cmake
#
#   mdt_add_memory_sanitizer_option_if_available(SANITIZER_ENABLE_MEMORY
#     HELP_STRING "Enable memory sanitizer for Debug and RelWithDebInfo build"
#     INITIAL_VALUE OFF
#   )
#   if(SANITIZER_ENABLE_MEMORY)
#     mdt_build_with_memory_sanitizer(BUILD_TYPES Debug RelWithDebInfo)
#   endif()
#
#
# See also :command:`mdt_is_memory_sanitizer_available()`.
#
#
# .. command:: mdt_build_with_memory_sanitizer
#
# Build with support for MemorySanitizer::
#
#   mdt_build_with_memory_sanitizer(
#     [BUILD_TYPES types...]
#   )
#
# Enables MemorySanitizer for available build configurations:
#
# .. code-block:: cmake
#
#   mdt_build_with_memory_sanitizer()
#
# The list of available build configurations is got by :command:`mdt_get_available_build_configurations()`.
# It is also possible to specify a custom set of build configurations:
#
# .. code-block:: cmake
#
#   mdt_build_with_memory_sanitizer(BUILD_TYPES Debug RelWithDebInfo)
#
# Note that this function will not check the availability of MSan,
# but simply passes the appropriate flags.
#
#
# UndefinedBehaviorSanitizer (UBSan)
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_is_undefined_sanitizer_available
#
# Check if UndefinedBehaviorSanitizer is available::
#
#   mdt_is_undefined_sanitizer_available(var)
#
# Example:
#
# .. code-block:: cmake
#
#   mdt_is_undefined_sanitizer_available(undefinedSanitizerIsAvailable)
#   if(undefinedSanitizerIsAvailable)
#     ...
#   endif()
#
# The rules to deduce if UndefinedBehaviorSanitizer is available are based on:
#   - https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html
#   - https://www.kernel.org/doc/html/v4.14/dev-tools/ubsan.html
#
#
# .. command:: mdt_add_undefined_sanitizer_option_if_available
#
# Add a option, by calling :command:`option()`, to enable UndefinedBehaviorSanitizer if available::
#
#   mdt_add_undefined_sanitizer_option_if_available(var HELP_STRING [INITIAL_VALUE])
#
# Example:
#
# .. code-block:: cmake
#
#   mdt_add_undefined_sanitizer_option_if_available(SANITIZER_ENABLE_UNDEFINED
#     HELP_STRING "Enable undefined behaviour sanitizer for Debug and RelWithDebInfo build"
#     INITIAL_VALUE OFF
#   )
#   if(SANITIZER_ENABLE_UNDEFINED)
#     mdt_build_with_undefined_sanitizer(BUILD_TYPES Debug RelWithDebInfo)
#   endif()
#
#
# See also :command:`mdt_is_undefined_sanitizer_available()`.
#
#
# .. command:: mdt_build_with_undefined_sanitizer
#
# Build with support for UndefinedBehaviorSanitizer::
#
#   mdt_build_with_undefined_sanitizer(
#     [BUILD_TYPES types...]
#   )
#
# Enables UndefinedBehaviorSanitizer for available build configurations:
#
# .. code-block:: cmake
#
#   mdt_build_with_undefined_sanitizer()
#
# The list of available build configurations is got by :command:`mdt_get_available_build_configurations()`.
# It is also possible to specify a custom set of build configurations:
#
# .. code-block:: cmake
#
#   mdt_build_with_undefined_sanitizer(BUILD_TYPES Debug RelWithDebInfo)
#
# Note that this function will not check the availability of UBSan,
# but simply passes the appropriate flags.
#
#
# .. command:: mdt_set_test_ubsan_options
#
#
# Pass UBSAN_OPTIONS as `ENVIRONMENT` property of a test::
#
#   mdt_set_test_ubsan_options(
#     NAME test
#     OPTIONS options1 [options2...]
#   )
#
#
# While running a executable with UndefinedBehaviorSanitizer,
# some runtime options can be passed.
# This is done by setting those options to the UBSAN_OPTIONS.
#
# For example on Linux::
#
#   UBSAN_OPTIONS=suppressions=MyUBSan.supp:log_path=ubsanlog.txt
#
# Usage exemple:
#
# .. code-block:: cmake
#
#   mdt_set_test_ubsan_options(
#     NAME SomeTest
#     OPTIONS suppressions=MyUBSan.supp log_path=ubsanlog.txt
#   )
#
# See also:
#   - https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html
#   - https://chromium.googlesource.com/chromium/src/testing/libfuzzer/+/HEAD/reference.md
#
#
# ThreadSanitizer (TSan)
# ^^^^^^^^^^^^^^^^^^^^^^
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
#     [BUILD_TYPES types...]
#   )
#
# Enables ThreadSanitizer for available build configurations:
#
# .. code-block:: cmake
#
#   mdt_build_with_thread_sanitizer()
#
# The list of available build configurations is got by :command:`mdt_get_available_build_configurations()`.
# It is also possible to specify a custom set of build configurations:
#
# .. code-block:: cmake
#
#   mdt_build_with_thread_sanitizer(BUILD_TYPES Debug RelWithDebInfo)
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
# ---
#
#
# Build configurations
# --------------------
#
# TODO: this should go to MdtBuildConfigurations
#
#
# .. command:: mdt_get_available_build_configurations
#
# Get a list of available build configurations (also named build types)::
#
#   mdt_get_available_build_configurations(out_var)
#
# For multi-configuration generators (like Visual Studio Generators, Ninja Multi-Config),
# given `out_var` will contain the content of ``CMAKE_CONFIGURATION_TYPES``,
# otherwise it will contain the value of ``CMAKE_BUILD_TYPE``.
#

include(MdtRuntimeEnvironment)

# TODO: this should go to MdtBuildConfigurations
function(mdt_get_available_build_configurations out_var)

  get_property(isMultiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

  if(isMultiConfig)
    set(${out_var} ${CMAKE_CONFIGURATION_TYPES} PARENT_SCOPE)
  else()
    set(${out_var} ${CMAKE_BUILD_TYPE} PARENT_SCOPE)
  endif()

endfunction()

function(mdt_get_cxx_or_c_compiler_id out_var)

  if(CMAKE_CXX_COMPILER_ID)
    set(${out_var} "${CMAKE_CXX_COMPILER_ID}" PARENT_SCOPE)
  else()
    set(${out_var} "${CMAKE_C_COMPILER_ID}" PARENT_SCOPE)
  endif()

endfunction()


function(mdt_get_cxx_or_c_compiler_version out_var)

  if(CMAKE_CXX_COMPILER_VERSION)
    set(${out_var} ${CMAKE_CXX_COMPILER_VERSION} PARENT_SCOPE)
  else()
    set(${out_var} ${CMAKE_C_COMPILER_VERSION} PARENT_SCOPE)
  endif()

endfunction()


function(mdt_is_address_sanitizer_available out_var)

  if(WIN32)
    if(MSVC_VERSION)
      if(${MSVC_VERSION} GREATER_EQUAL 1929)
        set(${out_var} TRUE PARENT_SCOPE)
        return()
      endif()
    else()
      set(${out_var} FALSE PARENT_SCOPE)
      return()
    endif()
  endif()

  # TODO: missing FreeBSD
  set(supportedCpuArchs)
  if(UNIX)
    if(APPLE)
      set(supportedCpuArchs x86_64 x86)
    else()
      set(supportedCpuArchs x86_64 x86 mips mips64 powerpc powerpc64)
    endif()
  endif()
  if(NOT CMAKE_SYSTEM_PROCESSOR IN_LIST supportedCpuArchs)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  mdt_get_cxx_or_c_compiler_id(compilerId)
  if(NOT compilerId)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  set(supportedCompilers "AppleClang" "Clang" "GNU")
  if(NOT compilerId IN_LIST supportedCompilers)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  mdt_get_cxx_or_c_compiler_version(compilerVersion)
  if(NOT compilerVersion)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  if(${compilerId} MATCHES "Clang")
    if(${compilerVersion} VERSION_LESS 3.1)
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


function(mdt_add_address_sanitizer_option_if_available var)

  set(options)
  set(oneValueArgs HELP_STRING INITIAL_VALUE)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_HELP_STRING)
    message(FATAL_ERROR "mdt_add_address_sanitizer_option_if_available(): HELP_STRING argument missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_add_address_sanitizer_option_if_available(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  mdt_is_address_sanitizer_available(addressSanitizerIsAvailable)
  if(addressSanitizerIsAvailable)
    option(${var} "${ARG_HELP_STRING}" ${ARG_INITIAL_VALUE})
  endif()

endfunction()


function(mdt_build_with_address_sanitizer)

  set(options)
  set(oneValueArgs)
  set(multiValueArgs BUILD_TYPES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_build_with_address_sanitizer(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(buildTypes)
  if(ARG_BUILD_TYPES)
    set(buildTypes ${ARG_BUILD_TYPES})
  else()
    mdt_get_available_build_configurations(buildTypes)
  endif()
  message(VERBOSE "mdt_build_with_address_sanitizer(): build with ASan for ${buildTypes}")

  foreach(buildType ${buildTypes})
    add_compile_options($<$<CONFIG:${buildType}>:-fsanitize=address>)
    add_compile_options($<$<CONFIG:${buildType}>:-fno-omit-frame-pointer>)
    link_libraries($<$<CONFIG:${buildType}>:-fsanitize=address>)
  endforeach()

endfunction()


function(mdt_set_test_asan_options)

  set(options)
  set(oneValueArgs NAME)
  set(multiValueArgs OPTIONS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_NAME)
    message(FATAL_ERROR "mdt_set_test_asan_options(): NAME argument missing")
  endif()
  if(NOT ARG_OPTIONS)
    message(FATAL_ERROR "mdt_set_test_asan_options(): OPTIONS argument expects at least one option")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_set_test_asan_options(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  string(REPLACE ";" ":" asanOptions "${ARG_OPTIONS}")

  mdt_append_test_environment_variables_string(${ARG_NAME} "ASAN_OPTIONS=${asanOptions}")

endfunction()


function(mdt_is_memory_sanitizer_available out_var)

  set(supportedCpuArchs x86_64 aarch64 mips64 powerpc64)
  if(NOT CMAKE_SYSTEM_PROCESSOR IN_LIST supportedCpuArchs)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  mdt_get_cxx_or_c_compiler_id(compilerId)
  if(NOT compilerId)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  set(supportedCompilers "AppleClang" "Clang")
  if(NOT compilerId IN_LIST supportedCompilers)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  mdt_get_cxx_or_c_compiler_version(compilerVersion)
  if(NOT compilerVersion)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  if(${compilerId} MATCHES "Clang")
    if(${compilerVersion} VERSION_LESS 4.0)
      set(${out_var} FALSE PARENT_SCOPE)
      return()
    endif()
  endif()

  set(${out_var} TRUE PARENT_SCOPE)

endfunction()


function(mdt_add_memory_sanitizer_option_if_available var)

  set(options)
  set(oneValueArgs HELP_STRING INITIAL_VALUE)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_HELP_STRING)
    message(FATAL_ERROR "mdt_add_memory_sanitizer_option_if_available(): HELP_STRING argument missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_add_memory_sanitizer_option_if_available(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  mdt_is_memory_sanitizer_available(memorySanitizerIsAvailable)
  if(memorySanitizerIsAvailable)
    option(${var} "${ARG_HELP_STRING}" ${ARG_INITIAL_VALUE})
  endif()

endfunction()


function(mdt_build_with_memory_sanitizer)

  set(options)
  set(oneValueArgs)
  set(multiValueArgs BUILD_TYPES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_build_with_memory_sanitizer(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(buildTypes)
  if(ARG_BUILD_TYPES)
    set(buildTypes ${ARG_BUILD_TYPES})
  else()
    mdt_get_available_build_configurations(buildTypes)
  endif()
  message(VERBOSE "mdt_build_with_memory_sanitizer(): build with MSan for ${buildTypes}")

  foreach(buildType ${buildTypes})
    add_compile_options($<$<CONFIG:${buildType}>:-fsanitize=memory>)
    add_compile_options($<$<CONFIG:${buildType}>:-fPIE>)
    add_compile_options($<$<CONFIG:${buildType}>:-fpie>)
    add_compile_options($<$<CONFIG:${buildType}>:-fno-omit-frame-pointer>)
    link_libraries($<$<CONFIG:${buildType}>:-fsanitize=memory>)
  endforeach()

endfunction()


function(mdt_is_undefined_sanitizer_available out_var)

  # MinGW seems not to support any sanitizer
  # See also https://github.com/msys2/MINGW-packages/issues/3163
  if(MINGW)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  mdt_get_cxx_or_c_compiler_id(compilerId)
  if(NOT compilerId)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  set(supportedCompilers "AppleClang" "Clang" "GNU")
  if(NOT compilerId IN_LIST supportedCompilers)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  mdt_get_cxx_or_c_compiler_version(compilerVersion)
  if(NOT compilerVersion)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  if(${compilerId} MATCHES "Clang")
    if(${compilerVersion} VERSION_LESS 3.3)
      set(${out_var} FALSE PARENT_SCOPE)
      return()
    endif()
  endif()

  if(${compilerId} STREQUAL "GNU")
    if(${compilerVersion} VERSION_LESS 4.9)
      set(${out_var} FALSE PARENT_SCOPE)
      return()
    endif()
  endif()

  set(${out_var} TRUE PARENT_SCOPE)

endfunction()


function(mdt_add_undefined_sanitizer_option_if_available var)

  set(options)
  set(oneValueArgs HELP_STRING INITIAL_VALUE)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_HELP_STRING)
    message(FATAL_ERROR "mdt_add_undefined_sanitizer_option_if_available(): HELP_STRING argument missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_add_undefined_sanitizer_option_if_available(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  mdt_is_undefined_sanitizer_available(undefinedSanitizerIsAvailable)
  if(undefinedSanitizerIsAvailable)
    option(${var} "${ARG_HELP_STRING}" ${ARG_INITIAL_VALUE})
  endif()

endfunction()


function(mdt_build_with_undefined_sanitizer)

  set(options)
  set(oneValueArgs)
  set(multiValueArgs BUILD_TYPES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_build_with_undefined_sanitizer(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(buildTypes)
  if(ARG_BUILD_TYPES)
    set(buildTypes ${ARG_BUILD_TYPES})
  else()
    mdt_get_available_build_configurations(buildTypes)
  endif()
  message(VERBOSE "mdt_build_with_undefined_sanitizer(): build with UBSan for ${buildTypes}")

  foreach(buildType ${buildTypes})
    add_compile_options($<$<CONFIG:${buildType}>:-fsanitize=undefined>)
    # See https://stackoverflow.com/questions/55480333/clang-8-with-mingw-w64-how-do-i-use-address-ub-sanitizers
    if(WIN32)
      mdt_get_cxx_or_c_compiler_id(compilerId)
      if( (${compilerId} MATCHES "Clang") OR (${compilerId} MATCHES "GNU") )
        add_compile_options($<$<CONFIG:${buildType}>:-fsanitize-undefined-trap-on-error>)
      endif()
    endif()
    add_compile_options($<$<CONFIG:${buildType}>:-fno-omit-frame-pointer>)
    link_libraries($<$<CONFIG:${buildType}>:-fsanitize=undefined>)
  endforeach()

endfunction()


function(mdt_set_test_ubsan_options)

  set(options)
  set(oneValueArgs NAME)
  set(multiValueArgs OPTIONS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_NAME)
    message(FATAL_ERROR "mdt_set_test_ubsan_options(): NAME argument missing")
  endif()
  if(NOT ARG_OPTIONS)
    message(FATAL_ERROR "mdt_set_test_ubsan_options(): OPTIONS argument expects at least one option")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_set_test_ubsan_options(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  string(REPLACE ";" ":" ubsanOptions "${ARG_OPTIONS}")

  mdt_append_test_environment_variables_string(${ARG_NAME} "UBSAN_OPTIONS=${ubsanOptions}")

endfunction()


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

  mdt_get_cxx_or_c_compiler_id(compilerId)
  if(NOT compilerId)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  set(supportedCompilers "AppleClang" "Clang" "GNU")
  if(NOT compilerId IN_LIST supportedCompilers)
    set(${out_var} FALSE PARENT_SCOPE)
    return()
  endif()

  mdt_get_cxx_or_c_compiler_version(compilerVersion)
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

  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_build_with_thread_sanitizer(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(buildTypes)
  if(ARG_BUILD_TYPES)
    set(buildTypes ${ARG_BUILD_TYPES})
  else()
    mdt_get_available_build_configurations(buildTypes)
  endif()
  message(VERBOSE "mdt_build_with_thread_sanitizer(): build with TSan for ${buildTypes}")

  foreach(buildType ${buildTypes})
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

  mdt_append_test_environment_variables_string(${ARG_NAME} "TSAN_OPTIONS=${tsanOptions}")

endfunction()
