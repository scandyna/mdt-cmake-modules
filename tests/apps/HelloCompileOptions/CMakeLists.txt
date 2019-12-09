
cmake_minimum_required(VERSION 3.10)

project(HelloCompileOptions VERSION 0.0.3)

message("tests Hello CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

# TODO: check flags here

include(MdtBuildOptionsUtils)

mdt_set_available_build_types(Debug Release RelWithDebInfo MinSizeRel Instrumented)

get_property(isMultiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(NOT isMultiConfig)
  set(CMAKE_BUILD_TYPE Instrumented)
endif()

mdt_get_available_optimization_levels(AVAILABLE_OPTIMIZATION_LEVELS)
message("AVAILABLE_OPTIMIZATION_LEVELS: ${AVAILABLE_OPTIMIZATION_LEVELS}")

mdt_add_debug_symbols_compile_option(BUILD_TYPES Instrumented)

mdt_are_sanitizers_available(SANITIZERS_ARE_AVAILABLE)
if(SANITIZERS_ARE_AVAILABLE)
  mdt_compile_with_address_sanitizer(BUILD_TYPES Instrumented)
  mdt_compile_with_leak_sanitizer(BUILD_TYPES Instrumented)
  mdt_compile_with_undefined_sanitizer(BUILD_TYPES Instrumented)
endif()

# set(BUILD_TYPE_INSTRUMENTED_OPTIONS -g)
# add_compile_options($<$<CONFIG:Instrumented>:${BUILD_TYPE_INSTRUMENTED_OPTIONS}>)
# 
# set(SANITIZER_FLAGS "-fsanitize=address;-fsanitize=leak")
# # add_compile_options($<$<CONFIG:Instrumented>:${SANITIZER_FLAGS}>)
# # link_libraries($<$<CONFIG:Instrumented>:"${SANITIZER_FLAGS}">)
# 
# add_compile_options($<$<CONFIG:Instrumented>:-fsanitize=address>)
# add_compile_options($<$<CONFIG:Instrumented>:-fsanitize=leak>)
# link_libraries($<$<CONFIG:Instrumented>:-fsanitize=address>)
# link_libraries($<$<CONFIG:Instrumented>:-fsanitize=leak>)


add_subdirectory(src)

enable_testing()
add_subdirectory(tests)
