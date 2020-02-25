cmake_minimum_required(VERSION 3.10)

project(SanitizersTests VERSION 0.0.3)

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

include(MdtSanitizers)
include(MdtBuildOptionsUtils)

mdt_set_available_build_types(Release Debug RelWithDebInfo MinSizeRel Instrumented)

option(TEST_ADDRESS_SANITIZER "" OFF)
option(TEST_THREAD_SANITIZER "" OFF)

mdt_add_address_sanitizer_option_if_available(SANITIZER_ENABLE_ADDRESS
  HELP_STRING "Enable address sanitizer for Debug and RelWithDebInfo build"
  INITIAL_VALUE ON
)
if(TEST_ADDRESS_SANITIZER AND SANITIZER_ENABLE_ADDRESS)
  message("SanitizersTests: build with AddressSanitizer")
  mdt_build_with_address_sanitizer(BUILD_TYPES Debug RelWithDebInfo)
endif()

mdt_add_thread_sanitizer_option_if_available(SANITIZER_ENABLE_THREAD
  HELP_STRING "Enable thread sanitizer for Debug build (can be incompatible with other sanitizers)"
  INITIAL_VALUE ON
)
if(TEST_THREAD_SANITIZER AND SANITIZER_ENABLE_THREAD)
  message("SanitizersTests: build with ThreadSanitizer")
  mdt_build_with_thread_sanitizer(BUILD_TYPES Debug)
endif()


add_subdirectory(src)

enable_testing()
add_subdirectory(tests)
