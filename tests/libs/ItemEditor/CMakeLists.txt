
cmake_minimum_required(VERSION 3.10)

project(MdtItemEditor VERSION 0.0.2)

message("tests MdtItemEditor CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)
find_package(Mdt0 0.0.1 COMPONENTS ItemModel REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

set(MDT_INSTALL_PACKAGE_NAME Mdt0)
include(GNUInstallDirs)
include(MdtInstallDirs)

add_subdirectory(src)

enable_testing()
add_subdirectory(tests)
