# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.17)

project(MdtFindPathInList_UsageInPackageConfig VERSION 0.0.3)

set(CMAKE_MESSAGE_LOG_LEVEL VERBOSE)

message(VERBOSE "tests MdtFindPathInList_UsageInPackageConfig CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

set(MdtFindPathInList_FUNCTION_NAME MyLib_mdt_find_path_in_list)
configure_file("${MDT_CMAKE_MODULES_PATH}/MdtFindPathInList.cmake.in" MyLibMdtFindPathInList.cmake @ONLY)

include(CMakePackageConfigHelpers)
configure_package_config_file(
  MyLibConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/MyLibConfig.cmake
  INSTALL_DESTINATION "lib/cmake"
  NO_SET_AND_CHECK_MACRO
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

install(
  FILES
    "${CMAKE_CURRENT_BINARY_DIR}/MyLibConfig.cmake"
    "${CMAKE_BINARY_DIR}/MyLibMdtFindPathInList.cmake"
  DESTINATION "lib/cmake"
)
