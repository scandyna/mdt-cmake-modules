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
