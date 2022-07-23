
cmake_minimum_required(VERSION 3.15)

project(Hello_Conan_CMakeDeps VERSION 0.0.3)

set(CMAKE_MESSAGE_LOG_LEVEL DEBUG)

message("tests TableEditor_Conan_CMakeDeps CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)
find_package(Mdt0 COMPONENTS ItemEditor REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

add_subdirectory(src)

enable_testing()
add_subdirectory(tests)
