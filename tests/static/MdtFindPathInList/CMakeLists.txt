# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

include(MdtFindPathInList)

set(PATH_LIST)

mdt_find_path_in_list(PATH_LIST "/tmp/LibA" PATH_INDEX)

if(${PATH_INDEX} GREATER_EQUAL 0)
  message(FATAL_ERROR "TEST mdt_find_path_in_list() failed: /tmp/LibA should not be found in a empty list")
endif()


list(APPEND PATH_LIST "/tmp/LibA")

mdt_find_path_in_list(PATH_LIST "/tmp/LibA" PATH_INDEX)

if( NOT (${PATH_INDEX} EQUAL 0) )
  message(FATAL_ERROR "TEST mdt_find_path_in_list() failed: /tmp/LibA should be the first element in the list")
endif()

mdt_find_path_in_list(PATH_LIST "/tmp/LibA/" PATH_INDEX)

if( NOT (${PATH_INDEX} EQUAL 0) )
  message(FATAL_ERROR "TEST mdt_find_path_in_list() failed: /tmp/LibA/ should be the first element in the list")
endif()
