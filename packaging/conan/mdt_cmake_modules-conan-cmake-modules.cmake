# This file is only used by conan generators that generates CMake package config files

message(DEBUG "begin of mdt_cmake_modules-conan-cmake-modules.cmake")

message(DEBUG "CMAKE_CURRENT_LIST_DIR: ${CMAKE_CURRENT_LIST_DIR}")

include("${CMAKE_CURRENT_LIST_DIR}/MdtCMakeModulesConanMdtFindPathInList.cmake")

message(DEBUG "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

# Remove the root of the package from CMAKE_PREFIX_PATH
# to avoid clashes when using Conan generated CMake package config files
MdtCMakeModulesConan_mdt_find_path_in_list(CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}" PATH_INDEX)
if(${PATH_INDEX} GREATER_EQUAL 0)
  list(REMOVE_AT CMAKE_PREFIX_PATH ${PATH_INDEX})
endif()

# Add the path to our CMake modules if not already
MdtCMakeModulesConan_mdt_find_path_in_list(CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}/Modules" PATH_INDEX)
if(${PATH_INDEX} LESS 0)
  list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/Modules")
endif()

unset(PATH_INDEX)

message(DEBUG "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

message(DEBUG "end of mdt_cmake_modules-conan-cmake-modules.cmake")
