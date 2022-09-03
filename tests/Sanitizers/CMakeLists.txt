cmake_minimum_required(VERSION 3.15)

project(SanitizersTests VERSION 0.0.3)

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

include(MdtSanitizers)
include(MdtBuildOptionsUtils)

mdt_set_available_build_types(Release Debug RelWithDebInfo MinSizeRel Instrumented)

option(TEST_ADDRESS_SANITIZER "" OFF)
option(TEST_MEMORY_SANITIZER "" OFF)
option(TEST_UNDEFINED_SANITIZER "" OFF)
option(TEST_THREAD_SANITIZER "" OFF)

set(CMAKE_MESSAGE_LOG_LEVEL "DEBUG")

mdt_add_address_sanitizer_option_if_available(SANITIZER_ENABLE_ADDRESS
  HELP_STRING "Enable address sanitizer for Debug and RelWithDebInfo build"
  INITIAL_VALUE ON
)
if(TEST_ADDRESS_SANITIZER)
  if(SANITIZER_ENABLE_ADDRESS)
    message(STATUS "TEST: build with AddressSanitizer for Debug RelWithDebInfo")
    mdt_build_with_address_sanitizer(BUILD_TYPES Debug RelWithDebInfo)
    message(STATUS "TEST: build with AddressSanitizer for available build types")
    mdt_build_with_address_sanitizer()
  else()
    message(STATUS "TEST: AddressSanitizer not supported (will be ignored)")
  endif()
endif()

mdt_add_memory_sanitizer_option_if_available(SANITIZER_ENABLE_MEMORY
  HELP_STRING "Enable memory sanitizer for Debug and RelWithDebInfo build"
  INITIAL_VALUE ON
)
if(TEST_MEMORY_SANITIZER)
  if(SANITIZER_ENABLE_MEMORY)
    message(STATUS "TEST: build with MemorySanitizer for Debug RelWithDebInfo")
    mdt_build_with_memory_sanitizer(BUILD_TYPES Debug RelWithDebInfo)
    message(STATUS "TEST: build with MemorySanitizer for available build types")
    mdt_build_with_memory_sanitizer()
  else()
    message(STATUS "TEST: MemorySanitizer not supported (will be ignored)")
  endif()
endif()

mdt_add_undefined_sanitizer_option_if_available(SANITIZER_ENABLE_UNDEFINED
  HELP_STRING "Enable undefined behaviour sanitizer for Debug and RelWithDebInfo build"
  INITIAL_VALUE ON
)
if(TEST_UNDEFINED_SANITIZER)
  if(SANITIZER_ENABLE_UNDEFINED)
    message(STATUS "TEST: build with UndefinedBehaviorSanitizer (UBSan) for Debug RelWithDebInfo")
    mdt_build_with_undefined_sanitizer(BUILD_TYPES Debug RelWithDebInfo)
    message(STATUS "TEST: build with UndefinedBehaviorSanitizer (UBSan) for available build types")
    mdt_build_with_undefined_sanitizer()
  else()
    message(STATUS "TEST: UndefinedBehaviorSanitizer (UBSan) not supported (will be ignored)")
  endif()
endif()

mdt_add_thread_sanitizer_option_if_available(SANITIZER_ENABLE_THREAD
  HELP_STRING "Enable thread sanitizer for Debug build (can be incompatible with other sanitizers)"
  INITIAL_VALUE ON
)
if(TEST_THREAD_SANITIZER)
  if(SANITIZER_ENABLE_THREAD)
    message(STATUS "TEST: build with ThreadSanitizer for Debug")
    mdt_build_with_thread_sanitizer(BUILD_TYPES Debug)
    message(STATUS "TEST: build with ThreadSanitizer for available build types")
    mdt_build_with_thread_sanitizer()
  else()
    message("TEST: ThreadSanitizer not supported (will be ignored)")
  endif()
endif()


add_subdirectory(src)

enable_testing()
add_subdirectory(tests)
