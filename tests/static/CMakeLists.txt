# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/TestHelpers")

add_subdirectory(MdtFindPathInList)
add_subdirectory(MdtTargetDependenciesHelpers)
add_subdirectory(MdtIniFileReader)
add_subdirectory(MdtConanBuildInfoReader)
add_subdirectory(MdtRuntimeEnvironment)
