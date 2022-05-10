
message(DEBUG "begin of mdt_cmake_modules-conan-cmake-modules.cmake")

message(DEBUG "CMAKE_CURRENT_LIST_DIR: ${CMAKE_CURRENT_LIST_DIR}")

message(DEBUG "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

# TODO should implement this
# mdt_generate_mdt_find_path_in_list_function()
# mdt_write_mdt_find_path_in_list_function()
# mdt_find_path_in_list()

# We could have a trailing slash, or not, in CMAKE_PREFIX_PATH
list(REMOVE_ITEM CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}/")
list(REMOVE_ITEM CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}")
# On Windows build, we could have a trailing slash or backslash
if(WIN32)
  list(REMOVE_ITEM CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}\\")
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/Modules")

message(DEBUG "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

# unset(MDT_CMAKE_CURRENT_LIST_DIR_INDEX)

message(DEBUG "end of mdt_cmake_modules-conan-cmake-modules.cmake")
