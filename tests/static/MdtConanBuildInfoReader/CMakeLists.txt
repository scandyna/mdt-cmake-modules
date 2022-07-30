# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.15)

project(MdtConanBuildInfoReaderStaticTests LANGUAGES CXX)

include(MdtConanBuildInfoReader)
include(MdtListTestHelpers)

#########################################
# NOTE: here we make baisc tests,
# like arg passing and out vars
# The rest is mainly in MdtIniFileReader
#########################################

#########################################
# Simple file with 2 lib dirs
# and 2 bin dirs
#########################################

message(VERBOSE "TEST mdt_conan_build_info_read_libdirs(): simple file that contains 2 lib dirs")

mdt_conan_build_info_read_libdirs(libdirs FILE "${CMAKE_CURRENT_SOURCE_DIR}/conanbuildinfo.txt")
# TODO enable 
require_list_equals_to(libdirs "/home/test/.conan/data/qt/5.15.2/_/_/package/a1b2c3d4/lib;/home/test/.conan/data/sqlite3/3.38.1/_/_/package/1a2b3c4d/lib")


message(VERBOSE "TEST mdt_conan_build_info_read_bindirs(): simple file that contains 2 bin dirs")

mdt_conan_build_info_read_bindirs(bindirs FILE "${CMAKE_CURRENT_SOURCE_DIR}/conanbuildinfo.txt")
# TODO enable 
require_list_equals_to(bindirs "/home/test/.conan/data/qt/5.15.2/_/_/package/a1b2c3d4/bin;/home/test/.conan/data/sqlite3/3.38.1/_/_/package/1a2b3c4d/bin")


message(VERBOSE "TEST mdt_conan_build_info_read_[lib|bin]dirs(): all static tests passed")
