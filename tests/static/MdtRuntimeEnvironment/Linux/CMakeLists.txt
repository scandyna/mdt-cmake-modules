# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#############################################################
# Documentation example
#  CMAKE_LIBRARY_PATH is empty
#  LD_LIBRARY_PATH initially empty
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, LD_LIBRARY_PATH initially empty")

set(CMAKE_LIBRARY_PATH "")
set(ENV{LD_LIBRARY_PATH} "")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>")

#############################################################
# Documentation example
#  CMAKE_LIBRARY_PATH is empty
#  LD_LIBRARY_PATH already set
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, LD_LIBRARY_PATH initially set to /opt/qt/5.15.2/gcc_64/lib")

set(CMAKE_LIBRARY_PATH "")
set(ENV{LD_LIBRARY_PATH} "/opt/qt/5.15.2/gcc_64/lib")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:/opt/qt/5.15.2/gcc_64/lib")

#############################################################
# Documentation example
#  CMAKE_LIBRARY_PATH is set to a single path
#  LD_LIBRARY_PATH initially empty
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, CMAKE_LIBRARY_PATH is set to a single path")

set(CMAKE_LIBRARY_PATH "/opt/somelib/lib")
set(ENV{LD_LIBRARY_PATH} "")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:/opt/somelib/lib")

#############################################################
# Documentation example
#  CMAKE_LIBRARY_PATH contains multiple paths
#  LD_LIBRARY_PATH initially empty
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, CMAKE_LIBRARY_PATH contains multiple paths")

set(CMAKE_LIBRARY_PATH "/opt/A/lib;/opt/B/lib")
set(ENV{LD_LIBRARY_PATH} "")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:/opt/A/lib:/opt/B/lib")

#############################################################
# Documentation example
#  CMAKE_LIBRARY_PATH is set
#  LD_LIBRARY_PATH already set
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, CMAKE_LIBRARY_PATH and LD_LIBRARY_PATH both have value")

set(CMAKE_LIBRARY_PATH "/opt/somelib/lib")
set(ENV{LD_LIBRARY_PATH} "/opt/qt/5.15.2/gcc_64/lib")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:/opt/somelib/lib:/opt/qt/5.15.2/gcc_64/lib")
