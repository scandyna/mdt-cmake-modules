
cmake_minimum_required(VERSION 3.10)

project(Hello VERSION 0.0.3)

message("tests Hello CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)


add_subdirectory(src)

enable_testing()
add_subdirectory(tests)
