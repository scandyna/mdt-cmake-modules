# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.15)

project(MdtTargetDependenciesHelpersStaticTests LANGUAGES CXX)

include(MdtTargetDependenciesHelpers)


#################################
# Test helpers
#################################

function(require_list_is_empty listVarName)

  list(LENGTH ${listVarName} length)
  if(${length} GREATER 0)
    message(FATAL_ERROR "Test failed: list '${listVarName}' is not empty.\nlist content: ${${listVarName}}")
  endif()

endfunction()

function(require_list_is_of_length listVarName expectedLength)

  list(LENGTH ${listVarName} length)

  if( NOT (${length} EQUAL ${expectedLength}) )
    message(FATAL_ERROR "Test failed: list '${listVarName}' has a lenght of ${length}, expected ${expectedLength}.\nlist content: ${${listVarName}}")
  endif()

endfunction()

function(require_list_contains listVarName value)

  list(FIND ${listVarName} ${value} index)
  if(${index} LESS 0)
    message(FATAL_ERROR "Test failed: list '${listVarName}' does not contain ${value}.\nlist content: ${${listVarName}}")
  endif()

endfunction()

function(require_list_not_contains listVarName value)

  list(FIND ${listVarName} ${value} index)
  if(${index} GREATER_EQUAL 0)
    message(FATAL_ERROR "Test failed: list '${listVarName}' does contain ${value}.\nlist content: ${${listVarName}}")
  endif()

endfunction()

##########################################
# Common libraries used for some tests
##########################################

add_library(Mdt0::Core SHARED IMPORTED)
add_library(Mdt0::Widgets SHARED IMPORTED)

##########################################
# Test: target not having any dependencies
##########################################

message(VERBOSE "TEST mdt_collect_shared_libraries_targets_target_depends_on(): target without any dependency")

# Impl function
mdt_get_target_shared_libraries_targets_direct_dependencies(directDependencies TARGET Mdt0::Core)
require_list_is_empty(directDependencies)

# Public API
mdt_collect_shared_libraries_targets_target_depends_on(dependencies TARGET Mdt0::Core)
require_list_is_empty(dependencies)

##################################################
# Test: target having a LINK_LIBRARIES dependency
##################################################

message(VERBOSE "TEST mdt_collect_shared_libraries_targets_target_depends_on(): target with a dependency defined as LINK_LIBRARIES")

add_library(Mdt0::TargetWithLinkLibraries SHARED IMPORTED)
set_target_properties(Mdt0::TargetWithLinkLibraries
  PROPERTIES
    LINK_LIBRARIES Mdt0::Core
)

# Impl function
mdt_get_target_shared_libraries_targets_direct_dependencies(directDependencies TARGET Mdt0::TargetWithLinkLibraries)
require_list_contains(directDependencies Mdt0::Core)

# Public API
mdt_collect_shared_libraries_targets_target_depends_on(dependencies TARGET Mdt0::TargetWithLinkLibraries)
require_list_contains(dependencies Mdt0::Core)

###########################################################
# Test: target having a INTERFACE_LINK_LIBRARIES dependency
###########################################################

message(VERBOSE "TEST mdt_collect_shared_libraries_targets_target_depends_on(): target with a dependency defined as INTERFACE_LINK_LIBRARIES")

add_library(Mdt0::TargetWithInterfaceLinkLibraries SHARED IMPORTED)
set_target_properties(Mdt0::TargetWithInterfaceLinkLibraries
  PROPERTIES
    INTERFACE_LINK_LIBRARIES Mdt0::Core
)

# Impl function
mdt_get_target_shared_libraries_targets_direct_dependencies(directDependencies TARGET Mdt0::TargetWithInterfaceLinkLibraries)
require_list_contains(directDependencies Mdt0::Core)

# Public API
mdt_collect_shared_libraries_targets_target_depends_on(dependencies TARGET Mdt0::TargetWithInterfaceLinkLibraries)
require_list_contains(dependencies Mdt0::Core)

###############################################################
# Test: target having multiple direct dependencies
#  also check that LINK_LIBRARIES and INTERFACE_LINK_LIBRARIES
#  are appended, not overwritten (bug from 20.07.2022)
###############################################################

add_library(Mdt0::DirectLinkLibA SHARED IMPORTED)
add_library(Mdt0::DirectLinkLibB SHARED IMPORTED)
add_library(Mdt0::DirectInterfaceLinkLibC SHARED IMPORTED)
add_library(Mdt0::DirectInterfaceLinkLibD SHARED IMPORTED)

add_library(Mdt0::TargetWithMultipleDirectDeps SHARED IMPORTED)
set_target_properties(Mdt0::TargetWithMultipleDirectDeps
  PROPERTIES
    LINK_LIBRARIES "Mdt0::DirectLinkLibA;Mdt0::DirectLinkLibB"
    INTERFACE_LINK_LIBRARIES "Mdt0::DirectInterfaceLinkLibC;Mdt0::DirectInterfaceLinkLibD"
)

# Impl function
mdt_get_target_shared_libraries_targets_direct_dependencies(directDependencies TARGET Mdt0::TargetWithMultipleDirectDeps)
require_list_contains(directDependencies Mdt0::DirectLinkLibA)
require_list_contains(directDependencies Mdt0::DirectLinkLibB)
require_list_contains(directDependencies Mdt0::DirectInterfaceLinkLibC)
require_list_contains(directDependencies Mdt0::DirectInterfaceLinkLibD)

# Public API
mdt_collect_shared_libraries_targets_target_depends_on(dependencies TARGET Mdt0::TargetWithMultipleDirectDeps)
require_list_contains(dependencies Mdt0::DirectLinkLibA)
require_list_contains(dependencies Mdt0::DirectLinkLibB)
require_list_contains(dependencies Mdt0::DirectInterfaceLinkLibC)
require_list_contains(dependencies Mdt0::DirectInterfaceLinkLibD)

###########################################################
# Test: target having dependencies that are not targets
###########################################################

message(VERBOSE "TEST mdt_collect_shared_libraries_targets_target_depends_on(): target having a dependency that is not a target")

add_library(Mdt0::TargetNonTargetDependency SHARED IMPORTED)
set_target_properties(Mdt0::TargetNonTargetDependency
  PROPERTIES
    LINK_LIBRARIES NonTargetLinkLib
    INTERFACE_LINK_LIBRARIES NonTargetInterfaceLinkLib
)

# Impl function
mdt_get_target_shared_libraries_targets_direct_dependencies(directDependencies TARGET Mdt0::TargetNonTargetDependency)
require_list_is_empty(directDependencies)

# Public API
mdt_collect_shared_libraries_targets_target_depends_on(dependencies TARGET Mdt0::TargetNonTargetDependency)
require_list_is_empty(dependencies)

###########################################################
# Test: target having a generator expression dependency
###########################################################

message(VERBOSE "TEST mdt_collect_shared_libraries_targets_target_depends_on(): target having a LINK_LIBRARIES dependency that is a generator expression")

add_library(Mdt0::TargetWithGenexLinkLibraries SHARED IMPORTED)
set_target_properties(Mdt0::TargetWithGenexLinkLibraries
  PROPERTIES
    LINK_LIBRARIES "$<$<CONFIG:Debug>:libA.so;libB.so>;Mdt0::Core"
)

# Impl function
mdt_get_target_shared_libraries_targets_direct_dependencies(directDependencies TARGET Mdt0::TargetWithGenexLinkLibraries)
require_list_is_of_length(directDependencies 1)
require_list_contains(directDependencies Mdt0::Core)

# Public API
mdt_collect_shared_libraries_targets_target_depends_on(dependencies TARGET Mdt0::TargetWithGenexLinkLibraries)
require_list_is_of_length(dependencies 1)
require_list_contains(dependencies Mdt0::Core)

message(VERBOSE "TEST mdt_collect_shared_libraries_targets_target_depends_on(): target having a INTERFACE_LINK_LIBRARIES dependency that is a generator expression")

add_library(Mdt0::TargetWithGenexInterfaceLinkLibraries SHARED IMPORTED)
set_target_properties(Mdt0::TargetWithGenexInterfaceLinkLibraries
  PROPERTIES
    INTERFACE_LINK_LIBRARIES "$<$<CONFIG:Debug>:libA.so;libB.so>;Mdt0::Core"
)

# Impl function
mdt_get_target_shared_libraries_targets_direct_dependencies(directDependencies TARGET Mdt0::TargetWithGenexInterfaceLinkLibraries)
require_list_is_of_length(directDependencies 1)
require_list_contains(directDependencies Mdt0::Core)

# Public API
mdt_collect_shared_libraries_targets_target_depends_on(dependencies TARGET Mdt0::TargetWithGenexInterfaceLinkLibraries)
require_list_is_of_length(dependencies 1)
require_list_contains(dependencies Mdt0::Core)

###########################################################
# Test: target having a static library as dependency
###########################################################

message(VERBOSE "TEST mdt_collect_shared_libraries_targets_target_depends_on(): target having a static library in its dependencies")

add_library(Mdt0::StaticLib STATIC IMPORTED)
add_library(Mdt0::TargetWithStaticLibDependency SHARED IMPORTED)
set_target_properties(Mdt0::TargetWithStaticLibDependency
  PROPERTIES
    INTERFACE_LINK_LIBRARIES "Mdt0::StaticLib;Mdt0::Core"
)

# Impl function
mdt_get_target_shared_libraries_targets_direct_dependencies(directDependencies TARGET Mdt0::TargetWithGenexInterfaceLinkLibraries)
require_list_not_contains(directDependencies Mdt0::StaticLib)
require_list_contains(directDependencies Mdt0::Core)

# Public API
mdt_collect_shared_libraries_targets_target_depends_on(dependencies TARGET Mdt0::TargetWithStaticLibDependency)
require_list_not_contains(dependencies Mdt0::StaticLib)
require_list_contains(dependencies Mdt0::Core)

##########################################
# Test based on the documentation example
##########################################

add_library(Mdt0::ItemModel SHARED IMPORTED)
set_target_properties(Mdt0::ItemModel
  PROPERTIES
    INTERFACE_LINK_LIBRARIES Mdt0::Core
)

add_library(Mdt0::ItemEditor SHARED IMPORTED)
set_target_properties(Mdt0::ItemEditor
  PROPERTIES
    INTERFACE_LINK_LIBRARIES "Mdt0::Widgets;Mdt0::ItemModel"
)

add_library(myAppLibrary SHARED IMPORTED)
set_target_properties(myAppLibrary
  PROPERTIES
    INTERFACE_LINK_LIBRARIES Mdt0::ItemEditor
)

message(VERBOSE "TEST mdt_collect_shared_libraries_targets_target_depends_on(): documentation example")

mdt_collect_shared_libraries_targets_target_depends_on(dependencies TARGET myAppLibrary)
require_list_contains(dependencies Mdt0::ItemEditor)
require_list_contains(dependencies Mdt0::Widgets)
require_list_contains(dependencies Mdt0::ItemModel)
require_list_contains(dependencies Mdt0::Core)

#####################################################
# Test unicity if a dependency exists more than once
# in the dependency tree
#####################################################

message(VERBOSE "TEST mdt_collect_shared_libraries_targets_target_depends_on(): dependency tree containing a target multiple times")

add_library(Mdt0::LibDepOnCoreA SHARED IMPORTED)
set_target_properties(Mdt0::LibDepOnCoreA
  PROPERTIES
    INTERFACE_LINK_LIBRARIES Mdt0::Core
)

add_library(Mdt0::LibDepOnCoreB SHARED IMPORTED)
set_target_properties(Mdt0::LibDepOnCoreB
  PROPERTIES
    INTERFACE_LINK_LIBRARIES Mdt0::Core
)

add_library(Mdt0::LibDepOnCoreEntry SHARED IMPORTED)
set_target_properties(Mdt0::LibDepOnCoreEntry
  PROPERTIES
    INTERFACE_LINK_LIBRARIES "Mdt0::LibDepOnCoreA;Mdt0::LibDepOnCoreB"
)

mdt_collect_shared_libraries_targets_target_depends_on(dependencies TARGET Mdt0::LibDepOnCoreEntry)
require_list_contains(dependencies Mdt0::LibDepOnCoreA)
require_list_contains(dependencies Mdt0::LibDepOnCoreB)
require_list_contains(dependencies Mdt0::Core)
require_list_is_of_length(dependencies 3)

##########################################
# Test that circular dependencies
# not produces a infinite recursion
##########################################

message(VERBOSE "TEST mdt_collect_shared_libraries_targets_target_depends_on(): circular dependencies")

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

add_library(CircularEntry SHARED IMPORTED)
set_target_properties(CircularEntry
  PROPERTIES
    INTERFACE_LINK_LIBRARIES CircularA
)

mdt_collect_shared_libraries_targets_target_depends_on(dependencies TARGET CircularEntry)
require_list_contains(dependencies CircularA)
require_list_contains(dependencies CircularB)
require_list_is_of_length(dependencies 2)

message(VERBOSE "TEST mdt_collect_shared_libraries_targets_target_depends_on(): all static tests passed")
