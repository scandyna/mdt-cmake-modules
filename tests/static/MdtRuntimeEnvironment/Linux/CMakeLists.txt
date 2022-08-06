# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#############################################################
# Documentation example
#  LD_LIBRARY_PATH initially empty
#  conanbuildinfo.txt not used
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, LD_LIBRARY_PATH initially empty")

set(ENV{LD_LIBRARY_PATH} "")
set(MDT_CONAN_BUILD_INFO_FILE_PATH "")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>")

#############################################################
# Documentation example
#  LD_LIBRARY_PATH already set
#  conanbuildinfo.txt not used
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, LD_LIBRARY_PATH initially set to /opt/qt/5.15.2/gcc_64/lib")

set(ENV{LD_LIBRARY_PATH} "/opt/qt/5.15.2/gcc_64/lib")
set(MDT_CONAN_BUILD_INFO_FILE_PATH "")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:/opt/qt/5.15.2/gcc_64/lib")

#############################################################
# Documentation example
#  CMAKE_LIBRARY_PATH is set to a single path
#  LD_LIBRARY_PATH initially empty
#############################################################

# message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, CMAKE_LIBRARY_PATH is set to a single path")
# 
# set(CMAKE_LIBRARY_PATH "/opt/somelib/lib")
# set(ENV{LD_LIBRARY_PATH} "")
# 
# mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)
# 
# require_string_equals_to(myAppEnv "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:/opt/somelib/lib")

#############################################################
# Documentation example
#  LD_LIBRARY_PATH initially empty
#  Use conanbuildinfo.txt
#############################################################

# Variant using find_file() to locate conanbuildinfo.txt

# message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, use conanbuildinfo.txt with find_file()")
# 
# set(ENV{LD_LIBRARY_PATH} "")
# set(MDT_CONAN_BUILD_INFO_FILE_PATH "")
# 
# mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)
# 
# require_string_equals_to(myAppEnv "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:/opt/conan/A/lib:/opt/conan/B/lib")

# Variant using MDT_CONAN_BUILD_INFO_FILE_PATH to locate conanbuildinfo.txt

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, use conanbuildinfo.txt with MDT_CONAN_BUILD_INFO_FILE_PATH")

set(ENV{LD_LIBRARY_PATH} "")
set(MDT_CONAN_BUILD_INFO_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/conanbuildinfo.txt")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:/opt/conan/A/lib:/opt/conan/B/lib")

#############################################################
# Documentation example
#  LD_LIBRARY_PATH already set
#  Use conanbuildinfo.txt
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, CMAKE_LIBRARY_PATH and LD_LIBRARY_PATH both have value")

set(ENV{LD_LIBRARY_PATH} "/opt/qt/5.15.2/gcc_64/lib")
set(MDT_CONAN_BUILD_INFO_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/conanbuildinfo.txt")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:/opt/conan/A/lib:/opt/conan/B/lib:/opt/qt/5.15.2/gcc_64/lib")

# TODO: add a test with conanbuildinfo.txt is source DIR, should be found by find_file() without manipulating CMAKE_PREFIX_PATH
