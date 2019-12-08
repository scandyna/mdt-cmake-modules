
# TODO Test mdt_get_git_tag(GIT_TAG_VERSION FAIL_IF_NO_TAG)

cmake_minimum_required(VERSION 3.10)

project(TableEditor VERSION 0.0.3)

message("tests TableEditor CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

find_package(Mdt0 0.0.1 COMPONENTS ItemEditor REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

set(MDT_INSTALL_PACKAGE_NAME Mdt0)
include(GNUInstallDirs)
include(MdtInstallDirs)

add_subdirectory(src)

enable_testing()
add_subdirectory(tests)
