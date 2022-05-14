# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.17)

project(MdtFindPathInList_Usage VERSION 0.0.3)

set(CMAKE_MESSAGE_LOG_LEVEL VERBOSE)

message(VERBOSE "tests MdtFindPathInList_Usage CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

#######################################################
# Here we just check that MdtFindPathInList
# was properly installed with the correct function name
#######################################################

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

include(MdtFindPathInList)

mdt_find_path_in_list(CMAKE_PREFIX_PATH "Some/Relative/Path" INDEX)

message(VERBOSE "tests MdtFindPathInList_Usage INDEX: ${INDEX}")
