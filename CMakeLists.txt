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
