# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.15)

project(MdtTargetDependenciesHelpersStaticTests LANGUAGES CXX)

include(MdtTargetDependenciesHelpers)

#################################
# Test helpers
#################################

function(require_list_contains list value)

  list(FIND ${list} ${value} index)
  if(${index} LESS 0)
    message(FATAL_ERROR "Test failed: list does not contain ${value}")
  endif()

endfunction()

##########################################
# Test based on the documentation example
##########################################


# TODO: does not work ! Shoud create some IMPL functions that does not speack targets ?
#     -> first real test, then see what appears. Maybe no static test

# TODO: create, as in example, allmost all imported targets.
#       also give different import locations (maybe not so important here)

# add_library(Mdt_Core SHARED "Core.cpp")
# add_library(Mdt::Core ALIAS Mdt_Core)
add_library(Mdt0::Core SHARED IMPORTED)

# add_library(Mdt_Widgets SHARED "Widgets.cpp")
# add_library(Mdt::Widgets ALIAS Mdt_Widgets)
add_library(Mdt0::Widgets SHARED IMPORTED)

# add_library(Mdt_ItemModel SHARED "ItemModel.cpp")
# add_library(Mdt::ItemModel ALIAS Mdt_ItemModel)
# target_link_libraries(Mdt_ItemModel PUBLIC Mdt::Core)
add_library(Mdt0::ItemModel SHARED IMPORTED)
set_target_properties(Mdt0::ItemModel
  PROPERTIES
    INTERFACE_LINK_LIBRARIES Mdt0::Core
)

add_library(Mdt0::ItemEditor SHARED IMPORTED)
set_target_properties(Mdt0::ItemEditor
  PROPERTIES
    INTERFACE_LINK_LIBRARIES "Mdt0::Widgets;Mdt0::ItemModel"
#     IMPORTED_LOCATION
#       "/tmp"
)

add_library(myAppLibrary SHARED IMPORTED)
set_target_properties(myAppLibrary
  PROPERTIES
    INTERFACE_LINK_LIBRARIES Mdt0::ItemEditor
#     IMPORTED_LOCATION
#       "/tmp"
)

# TODO APP

message(VERBOSE "TEST mdt_collect_shared_libraries_targets_target_depends_on(): documentation example")

mdt_collect_shared_libraries_targets_target_depends_on(dependencies TARGET myAppLibrary)
require_list_contains(dependencies Mdt0::ItemEditor)
require_list_contains(dependencies Mdt0::Widgets)
require_list_contains(dependencies Mdt0::ItemModel)
require_list_contains(dependencies Mdt0::Core)


add_library(CircularA SHARED IMPORTED)
add_library(CircularB SHARED IMPORTED)
set_target_properties(CircularA
  PROPERTIES
    INTERFACE_LINK_LIBRARIES CircularB
)
set_target_properties(CircularB
  PROPERTIES
    INTERFACE_LINK_LIBRARIES CircularA
)

# target_link_libraries(CircularA PUBLIC CircularB)
# target_link_libraries(CircularB PUBLIC CircularA)

# set_target_properties(libA
#   PROPERTIES
#     INTERFACE_LINK_LIBRARIES gg
# )

# TODO: no dependencies

# TODO: non shared lib elements

# TODO genex

message(VERBOSE "TEST mdt_collect_shared_libraries_targets_target_depends_on(): all static tests passed")
