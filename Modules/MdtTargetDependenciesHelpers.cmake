# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

include(MdtTargetProperties)


function(mdt_append_shared_libraries_targets_to_list listVarName outList)

  set(targets ${${outList}})
  foreach(item IN LISTS ${listVarName})
    if(TARGET "${item}")
      mdt_target_is_shared_library(itemIsSharedLibrary TARGET ${item})
      if(itemIsSharedLibrary)
        list(APPEND targets "${item}")
      endif()
    endif()
  endforeach()

  set(${outList} ${targets} PARENT_SCOPE)

endfunction()


function(mdt_get_target_shared_libraries_targets_direct_dependencies outDirectDependencies)

  set(options "")
  set(oneValueArgs TARGET)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_get_target_shared_libraries_targets_direct_dependencies(): ${ARG_TARGET} is not a valid target")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_get_target_shared_libraries_targets_direct_dependencies(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(directDependencies)

  get_target_property(linkDependencies ${ARG_TARGET} LINK_LIBRARIES)
  if(linkDependencies)
    mdt_append_shared_libraries_targets_to_list(linkDependencies directDependencies)
  endif()

  get_target_property(interfaceLinkDependencies ${ARG_TARGET} INTERFACE_LINK_LIBRARIES)
  if(interfaceLinkDependencies)
    mdt_append_shared_libraries_targets_to_list(interfaceLinkDependencies directDependencies)
  endif()

  set(${outDirectDependencies} ${directDependencies} PARENT_SCOPE)

endfunction()


# Example of a dependency graph
# The vertices are the targets
# The edges are dependencies described in LINK_LIBRARIES and INTERFACE_LINK_LIBRARIES target properties
# We start from App (could have been a shared library target)
# The graph is directed, dependencies points downward.
# G and H depends on each other (circular dependency)
#
#  (App)
#  /   \
# (A) (B)
#  |   | \
# (C) (D) (E)
#   \ /    |
#   (F)   (G)<->(H)
#
#
# Starting from pseudocode from https://en.wikipedia.org/wiki/Depth-first_search
#
# procedure DFS(G, v) is
#   label v as discovered
#     for all directed edges from v to w that are in G.adjacentEdges(v) do
#       if vertex w is not labeled as discovered then
#         recursively call DFS(G, w)
#
#
# Note that we don't want (and we can't) label targets as discovered.
# Instead, we add them to a list of all discovered targets.
# This causes 1 major problem: the starting target (App in this example)
# will be part of the result.
# Algorithmic complexity also not so good,
# because we will have to find the discovered targets over and over,
# but we assume that the graph contains 10, 100 or max 1'000 elements
# (remeber: this will not be used by Conan generated cmake files, for example).
#
# The pseudocode for the transitive collect looks like:
#
# procedure DFS(target) is
#   add target to allTargets
#   put dependencies of target to directDependencies
#   for each dependency in directDependencies do
#     if dependency is not in allTargets then
#       recursively call DFS(dependency)
#

macro(mdt_collect_shared_libraries_targets_target_depends_on_transitively allTargets)

  set(options "")
  set(oneValueArgs TARGET)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG_IMPL "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT TARGET ${ARG_IMPL_TARGET})
    message(FATAL_ERROR "mdt_collect_shared_libraries_targets_target_depends_on_transitively(): ${ARG_IMPL_TARGET} is not a valid target")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_collect_shared_libraries_targets_target_depends_on_transitively(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  list(APPEND ${allTargets} ${ARG_IMPL_TARGET})

  mdt_get_target_shared_libraries_targets_direct_dependencies(directDependencies TARGET ${ARG_IMPL_TARGET})

  foreach(dependency ${directDependencies})
    list(FIND ${allTargets} ${dependency} index)
    if(${index} LESS 0)
      mdt_collect_shared_libraries_targets_target_depends_on_transitively(${allTargets} TARGET ${dependency})
    endif()
  endforeach()

endmacro()

function(mdt_collect_shared_libraries_targets_target_depends_on outDependencies)

  set(options "")
  set(oneValueArgs TARGET)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_collect_shared_libraries_targets_target_depends_on(): ${ARG_TARGET} is not a valid target")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_collect_shared_libraries_targets_target_depends_on(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  message(DEBUG "Collecting shared libraries targets ${ARG_TARGET} depends on")

  set(foundDependnecies)

  mdt_get_target_shared_libraries_targets_direct_dependencies(directDependencies TARGET ${ARG_TARGET})

  foreach(dependency ${directDependencies})
    mdt_collect_shared_libraries_targets_target_depends_on_transitively(foundDependnecies TARGET ${dependency})
  endforeach()

  message(DEBUG "Found shared libraries targets for ${ARG_TARGET}: ${foundDependnecies}")

  set(${outDependencies} ${foundDependnecies} PARENT_SCOPE)

endfunction()
