# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

# TODO: remove 
set(UNIX FALSE)
set(WIN32 TRUE)

#############################################################
# Documentation example
#  ALWAYS_USE_SLASHES: No
#  CMAKE_LIBRARY_PATH is empty
#  PATH initially empty
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, PATH initially empty")

set(CMAKE_LIBRARY_PATH "")
set(ENV{PATH} "")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>;$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>")

#############################################################
# Documentation example
#  ALWAYS_USE_SLASHES: Yes
#  CMAKE_LIBRARY_PATH is empty
#  PATH initially empty
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, PATH initially empty, ALWAYS_USE_SLASHES")

set(CMAKE_LIBRARY_PATH "")
set(ENV{PATH} "")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib ALWAYS_USE_SLASHES)

require_string_equals_to(myAppEnv "PATH=$<TARGET_FILE_DIR:Mdt0::ItemEditor>;$<TARGET_FILE_DIR:Mdt0::ItemModel>")

#############################################################
# Documentation example
#  ALWAYS_USE_SLASHES: No
#  CMAKE_LIBRARY_PATH is empty
#  PATH already set
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, PATH initially set")

set(CMAKE_LIBRARY_PATH "")
set(ENV{PATH} "C:\\opt\\qt\\5.15.2\\gcc_64\\bin")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>;$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>;C:\\opt\\qt\\5.15.2\\gcc_64\\bin")

#############################################################
# Documentation example
#  ALWAYS_USE_SLASHES: Yes
#  CMAKE_LIBRARY_PATH is empty
#  PATH already set
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, PATH initially set, ALWAYS_USE_SLASHES")

set(CMAKE_LIBRARY_PATH "")
set(ENV{PATH} "C:\\opt\\qt\\5.15.2\\gcc_64\\bin")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib ALWAYS_USE_SLASHES)

require_string_equals_to(myAppEnv "PATH=$<TARGET_FILE_DIR:Mdt0::ItemEditor>;$<TARGET_FILE_DIR:Mdt0::ItemModel>;C:/opt/qt/5.15.2/gcc_64/bin")

#############################################################
# Documentation example
#  ALWAYS_USE_SLASHES: No
#  CMAKE_LIBRARY_PATH is set to a single path
#  PATH initially empty
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, CMAKE_LIBRARY_PATH is set to a single path")

set(CMAKE_LIBRARY_PATH "C:\\opt\\somelib\\bin")
set(ENV{PATH} "")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>;$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>;C:\\opt\\somelib\\bin")

#############################################################
# Documentation example
#  ALWAYS_USE_SLASHES: No
#  CMAKE_LIBRARY_PATH is set to multiple paths
#  PATH initially empty
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, CMAKE_LIBRARY_PATH is set to multiple paths")

set(CMAKE_LIBRARY_PATH "C:\\opt\\A\\bin;C:\\opt\\B\\bin")
set(ENV{PATH} "")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>;$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>;C:\\opt\\A\\bin;C:\\opt\\B\\bin")

#############################################################
# Documentation example
#  ALWAYS_USE_SLASHES: Yes
#  CMAKE_LIBRARY_PATH is set
#  PATH initially empty
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, CMAKE_LIBRARY_PATH is set, ALWAYS_USE_SLASHES")

set(CMAKE_LIBRARY_PATH "C:\\opt\\somelib\\bin")
set(ENV{PATH} "")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib ALWAYS_USE_SLASHES)

require_string_equals_to(myAppEnv "PATH=$<TARGET_FILE_DIR:Mdt0::ItemEditor>;$<TARGET_FILE_DIR:Mdt0::ItemModel>;C:/opt/somelib/bin")
