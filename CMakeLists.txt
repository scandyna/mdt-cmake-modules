# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

# TODO
# Create a test_package or similar that is NOT included as subdirectory of the top CMakeLists
# and that has a other project name
# NOTE: this will probably be the end-to-end test, which also checks Conan description files


cmake_minimum_required(VERSION 3.2)

project(MdtCMakeModules VERSION 0.0.1)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/Modules/")


option(BUILD_TESTS "Build the tests" OFF)
if(BUILD_TESTS)
  enable_testing()
  add_subdirectory("tests")
endif()

option(BUILD_DOCS "Build the documentations" OFF)
if(BUILD_DOCS)
  add_subdirectory("doc")
endif()


#
# Install directories
#

option(DETERMINE_INSTALL_ROOT_DIR "Determine the install relative root directory. See MdtInstallDirs CMake module for more about this" ON)

include(GNUInstallDirs)
include(MdtInstallDirs)

message("DETERMINE_INSTALL_ROOT_DIR: ${DETERMINE_INSTALL_ROOT_DIR}")
message("Main: CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
message(MDT_INSTALL_IS_UNIX_SYSTEM_WIDE: ${MDT_INSTALL_IS_UNIX_SYSTEM_WIDE})

# If we have a empty entry here, provide a default one
# (CMake / cmake-gui does not this by default)
# if(NOT MDT_CMAKE_MODULE_INSTALL_DIR)
#   unset(MDT_CMAKE_MODULE_INSTALL_DIR CACHE)
# endif()
# set(MDT_CMAKE_MODULE_INSTALL_DIR "${MDT_INSTALL_DATADIR}" CACHE PATH "Relativ install directory")

if(DETERMINE_INSTALL_ROOT_DIR)
  set(MDT_CMAKE_MODULE_INSTALL_MODULES_DIR "${MDT_INSTALL_DATADIR}/Modules")
  set(MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR "${MDT_INSTALL_DATADIR}/cmake")
else()
  set(MDT_CMAKE_MODULE_INSTALL_MODULES_DIR "Modules")
  set(MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR "cmake")
endif()


message("MDT_CMAKE_MODULE_INSTALL_MODULES_DIR: ${MDT_CMAKE_MODULE_INSTALL_MODULES_DIR}")
message("MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR: ${MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR}")


#
# Modules installation
#

install(
  FILES
    "Modules/FindSphinx.cmake"
    "Modules/AddQt5ToCMakePrefixPath.cmake"
    "Modules/MdtInstallDirs.cmake"
  DESTINATION "${MDT_CMAKE_MODULE_INSTALL_MODULES_DIR}"
)

include(CMakePackageConfigHelpers)
configure_package_config_file(
  MdtCMakeModulesConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/MdtCMakeModulesConfig.cmake
  INSTALL_DESTINATION "${MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR}"
  PATH_VARS MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR
)

install(
  FILES
    "${CMAKE_CURRENT_BINARY_DIR}/MdtCMakeModulesConfig.cmake"
#   "${CMAKE_CURRENT_BINARY_DIR}/MdtCMakeModulesVersion.cmake"
  DESTINATION "${MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR}"
)
