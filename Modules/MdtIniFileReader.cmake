# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

# First idea was to use file(STRINGS REGEX)
# This did not work, because only a line that matches given regex will be read.
# A regex that matches a section, i.e. multiple lines, can't work.
# Note: file(STRINGS REGEX MATCHALL) also not exists.

function(mdt_ini_file_read_section_content out_var)

  set(options)
  set(oneValueArgs FILE SECTION LIMIT_FILE_BYTE_COUNT)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_FILE)
    message(FATAL_ERROR "mdt_ini_file_read_section_content(): mandadtory FILE argument missing")
  endif()
  if(NOT ARG_SECTION)
    message(FATAL_ERROR "mdt_ini_file_read_section_content(): mandadtory SECTION argument missing")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_ini_file_read_section_content(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(limitFileByteCountArgument)
  if(ARG_LIMIT_FILE_BYTE_COUNT)
    set(limitFileByteCountArgument LIMIT_INPUT ${ARG_LIMIT_FILE_BYTE_COUNT})
    message(DEBUG "mdt_ini_file_read_section_content(): will read max ${ARG_LIMIT_FILE_BYTE_COUNT} bytes from file")
  endif()

  file(STRINGS "${ARG_FILE}" fileLines ${limitFileByteCountArgument})

  set(sectionHeaderRegex "\\[${ARG_SECTION}\\]")
  set(endOfSectionRegex "[\\[]")
  set(content)
  set(inSection FALSE)

  foreach(line ${fileLines})
    if(inSection)
      if("${line}" MATCHES "${endOfSectionRegex}")
        set(inSection FALSE)
      else()
        list(APPEND content "${line}")
      endif()
    endif()
    if("${line}" MATCHES "${sectionHeaderRegex}")
      set(inSection TRUE)
    endif()
  endforeach()

  set(${out_var} ${content} PARENT_SCOPE)

endfunction()
