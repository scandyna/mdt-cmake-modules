# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

function(mdt_ini_file_read_section_content out_var)

  set(options)
  set(oneValueArgs FILE SECTION)
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

  # TODO: document limitation of file(STRINGS REGEX) - only take 1 line
  # REGEX MATCHALL not supported
  #
  # file(STRINGS) returns a list of strings, then replace by \n -> not good
  #
  
  # TODO: set some limit
  file(STRINGS "${ARG_FILE}" fileLines)
  message("** fileLines: ${fileLines}")
  
  set(sectionHeaderRegex "\\[${ARG_SECTION}\\]")
  set(endOfSectionRegex "[\\[]")
  set(content)
  set(inSection FALSE)
  
  foreach(line ${fileLines})
  
    message("+ line: ${line}")
    
    if(inSection)
      message("++ in section..")
      if("${line}" MATCHES "${endOfSectionRegex}")
        message("++ end of section")
        set(inSection FALSE)
      else()
        message("+++ line content: ${line}")
        list(APPEND content "${line}")
      endif()
    endif()
    
    if("${line}" MATCHES "${sectionHeaderRegex}")
      message("++ matches ${sectionHeaderRegex}")
      set(inSection TRUE)
    endif()
  
  endforeach()

  # file() already handles errors (like unreadable file)

#   file(STRINGS "${ARG_FILE}" content REGEX "^\\[${ARG_SECTION}\\].*")

#   ^\[TwoLines\]\n(.*)
#   file(STRINGS "${ARG_FILE}" content REGEX "(?<=^\\[${ARG_SECTION}\\]\n)[a-z|\\n]*")

#   set(regex "\\[${ARG_SECTION}\\]([a-z|A-Z|\n| ]*)")
#   set(regex "\\[${ARG_SECTION}\\][^\\[]")
#     set(regex "\\[${ARG_SECTION}\\][^\\[]*")

#   file(STRINGS "${ARG_FILE}" content REGEX "${regex}")

#   file(STRINGS "${ARG_FILE}" allContent)
#   
#   message("allContent: ${allContent}")
#   
# #   string(REPLACE ";" "\\n" "" allContent2 "${allContent}")
# 
#   list(JOIN allContent "\n" allContent2)
#   
#   message("allContent2: ${allContent2}")
#   
#   string(REGEX MATCH "${regex}" content "${allContent2}")

  

#   message("-* regex: ${regex}")
  message("-* content: ${content}")

  set(${out_var} ${content} PARENT_SCOPE)

endfunction()
