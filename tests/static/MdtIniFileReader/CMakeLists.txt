# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.15)

project(MdtIniFileReaderStaticTests LANGUAGES CXX)

include(MdtIniFileReader)
include(MdtListTestHelpers)

#########################################
# Empty section
#########################################

message(VERBOSE "TEST mdt_ini_file_read_section_content(): empty section")

mdt_ini_file_read_section_content(sectionContent FILE "${CMAKE_CURRENT_SOURCE_DIR}/common.txt" SECTION "EmptySection")
require_list_is_empty(sectionContent)

#########################################
# Section with 1 item
#########################################

message(VERBOSE "TEST mdt_ini_file_read_section_content(): section with 1 item")

mdt_ini_file_read_section_content(sectionContent FILE "${CMAKE_CURRENT_SOURCE_DIR}/common.txt" SECTION "OneItemSection")
require_list_equals_to(sectionContent "A")

#########################################
# Section with 2 items
#########################################

message(VERBOSE "TEST mdt_ini_file_read_section_content(): section with 2 items")

mdt_ini_file_read_section_content(sectionContent FILE "${CMAKE_CURRENT_SOURCE_DIR}/common.txt" SECTION "TwoItemSection")
require_list_equals_to(sectionContent "A;B")

#########################################
# File with 1 section of 3 items
#########################################

message(VERBOSE "TEST mdt_ini_file_read_section_content(): file with 1 section of 3 items")

mdt_ini_file_read_section_content(sectionContent FILE "${CMAKE_CURRENT_SOURCE_DIR}/onesection.txt" SECTION "Section")
require_list_equals_to(sectionContent "A;B;C")


message(VERBOSE "TEST mdt_ini_file_read_section_content(): all static tests passed")
