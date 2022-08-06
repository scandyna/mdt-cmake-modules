# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

include(MdtIniFileReader)

function(mdt_conan_build_info_read_libdirs out_var)

  set(options)
  set(oneValueArgs FILE)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_FILE)
    message(FATAL_ERROR "mdt_conan_build_info_read_libdirs(): mandadtory FILE argument missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_conan_build_info_read_libdirs(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  # A example conanbuildinfo.txt that depends on Qt Widgets is about 50Ko
  # The libdirs section seems to be at the beginning of the file
  mdt_ini_file_read_section_content(dirs
    FILE "${ARG_FILE}"
    SECTION "libdirs"
    LIMIT_FILE_BYTE_COUNT 30000
  )

  set(${out_var} ${dirs} PARENT_SCOPE)

endfunction()


function(mdt_conan_build_info_read_bindirs out_var)

  set(options)
  set(oneValueArgs FILE)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_FILE)
    message(FATAL_ERROR "mdt_conan_build_info_read_bindirs(): mandadtory FILE argument missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_conan_build_info_read_bindirs(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  # A example conanbuildinfo.txt that depends on Qt Widgets is about 50Ko
  # The libdirs section seems to be at the beginning of the file
  mdt_ini_file_read_section_content(dirs
    FILE "${ARG_FILE}"
    SECTION "bindirs"
    LIMIT_FILE_BYTE_COUNT 30000
  )

  set(${out_var} ${dirs} PARENT_SCOPE)

endfunction()


function(mdt_get_shared_libraries_directories_from_conanbuildinfo_if_exists out_var)

  if(MDT_CONAN_BUILD_INFO_FILE_PATH)
    set(conanBuildInfoFilePath "${MDT_CONAN_BUILD_INFO_FILE_PATH}")
  else()
    # find_file() will search in CMAKE_PREFIX_PATH by default
    find_file(findFileConanBuildInfoFilePath "conanbuildinfo.txt" NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
    set(conanBuildInfoFilePath "${findFileConanBuildInfoFilePath}")
  endif()

  if(EXISTS "${conanBuildInfoFilePath}")
    message(DEBUG "mdt_get_shared_libraries_directories_from_conanbuildinfo_if_exists(): using ${conanBuildInfoFilePath}")
    if(WIN32)
      mdt_conan_build_info_read_bindirs(sharedLibrariesDirectories FILE "${conanBuildInfoFilePath}")
    else()
      mdt_conan_build_info_read_libdirs(sharedLibrariesDirectories FILE "${conanBuildInfoFilePath}")
    endif()
  endif()

  set(${out_var} ${sharedLibrariesDirectories} PARENT_SCOPE)

endfunction()
