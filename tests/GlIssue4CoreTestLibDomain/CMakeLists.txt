
cmake_minimum_required(VERSION 3.10)

project(GlIssue4CoreTestLibDomain)

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)
find_package(Mdt0 0.0.1 COMPONENTS ItemModel REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

enable_testing()

add_subdirectory(libs/Core)
add_subdirectory(libs/Domain)
add_subdirectory(libs/TestLib)
