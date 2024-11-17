# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/TestHelpers")

add_subdirectory(MdtFindPathInList)
add_subdirectory(MdtTargetDependenciesHelpers)
add_subdirectory(MdtIniFileReader)
add_subdirectory(MdtConanBuildInfoReader)
add_subdirectory(MdtTargetProperties)

# If LD_LIBRARY_PATH / PATH environment variable are set,
# those tests will fail.
# This is for example the case if the project is generated using Conan,
# because mdt_get_shared_libraries_directories_from_conanbuildinfo_if_exists() will be called.
# If not called, dependencies like Qt will not be available.
if(BUILD_MDT_RUNTIME_ENVIRONMENT_STATIC_TESTS)
  add_subdirectory(MdtRuntimeEnvironment)
endif()
