# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#############################################################
# Documentation example
#  ALWAYS_USE_SLASHES: No
#  PATH initially empty
#  conanbuildinfo.txt not used
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, PATH initially empty")

set(ENV{PATH} "")
set(MDT_CONAN_BUILD_INFO_FILE_PATH "")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>;$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>")

#############################################################
# Documentation example
#  ALWAYS_USE_SLASHES: Yes
#  PATH initially empty
#  conanbuildinfo.txt not used
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, PATH initially empty, ALWAYS_USE_SLASHES")

set(ENV{PATH} "")
set(MDT_CONAN_BUILD_INFO_FILE_PATH "")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib ALWAYS_USE_SLASHES)

require_string_equals_to(myAppEnv "PATH=$<TARGET_FILE_DIR:Mdt0::ItemEditor>;$<TARGET_FILE_DIR:Mdt0::ItemModel>")

#############################################################
# Documentation example
#  ALWAYS_USE_SLASHES: No
#  PATH already set
#  conanbuildinfo.txt not used
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, PATH initially set")

set(ENV{PATH} "C:\\opt\\qt\\5.15.2\\gcc_64\\bin")
set(MDT_CONAN_BUILD_INFO_FILE_PATH "")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>;$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>;C:\\opt\\qt\\5.15.2\\gcc_64\\bin")

#############################################################
# Documentation example
#  ALWAYS_USE_SLASHES: Yes
#  PATH already set
#  conanbuildinfo.txt not used
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, PATH initially set, ALWAYS_USE_SLASHES")

set(ENV{PATH} "C:\\opt\\qt\\5.15.2\\gcc_64\\bin")
set(MDT_CONAN_BUILD_INFO_FILE_PATH "")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib ALWAYS_USE_SLASHES)

require_string_equals_to(myAppEnv "PATH=$<TARGET_FILE_DIR:Mdt0::ItemEditor>;$<TARGET_FILE_DIR:Mdt0::ItemModel>;C:/opt/qt/5.15.2/gcc_64/bin")

#############################################################
# Documentation example
#  ALWAYS_USE_SLASHES: No
#  PATH initially empty
#  Use conanbuildinfo.txt
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, use conanbuildinfo.txt")

set(ENV{PATH} "")
set(MDT_CONAN_BUILD_INFO_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/conanbuildinfo.txt")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib)

require_string_equals_to(myAppEnv "PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>;$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>;C:/opt/conan/A/bin;C:/opt/conan/B/bin")

#############################################################
# Documentation example
#  ALWAYS_USE_SLASHES: Yes
#  PATH initially empty
#  Use conanbuildinfo.txt
#############################################################

message(VERBOSE "TEST mdt_target_libraries_to_library_env_path(): documentation example, use conanbuildinfo.txt, ALWAYS_USE_SLASHES")

set(ENV{PATH} "")
set(MDT_CONAN_BUILD_INFO_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/conanbuildinfo.txt")

mdt_target_libraries_to_library_env_path(myAppEnv TARGET MyAppLib ALWAYS_USE_SLASHES)

require_string_equals_to(myAppEnv "PATH=$<TARGET_FILE_DIR:Mdt0::ItemEditor>;$<TARGET_FILE_DIR:Mdt0::ItemModel>;C:/opt/conan/A/bin;C:/opt/conan/B/bin")
