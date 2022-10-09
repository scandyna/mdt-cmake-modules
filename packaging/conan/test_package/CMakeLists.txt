
cmake_minimum_required(VERSION 3.15)

project(MdtCMakeModulesTest)

if(EXISTS "${CMAKE_BINARY_DIR}/conanbuildinfo.cmake")
  include("${CMAKE_BINARY_DIR}/conanbuildinfo.cmake")
  conan_basic_setup(NO_OUTPUT_DIRS)
endif()

message(DEBUG "MdtCMakeModulesTest: CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
message(DEBUG "MdtCMakeModulesTest: CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")

message(DEBUG "MdtCMakeModulesTest: call find_package() ...")

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

message(DEBUG "MdtCMakeModulesTest: CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
message(DEBUG "MdtCMakeModulesTest: CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")

# https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/11
message(DEBUG "MdtCMakeModulesTest: MDT_CMAKE_MODULES_PATH: ${MDT_CMAKE_MODULES_PATH}")
if(NOT MDT_CMAKE_MODULES_PATH)
  message(FATAL_ERROR "TEST package failed: MDT_CMAKE_MODULES_PATH not set after find_package(MdtCMakeModules)")
endif()

include(AddQt5ToCMakePrefixPath)
include(MdtBuildOptionsUtils)
include(MdtAddLibrary)
include(MdtAddTest)
include(MdtInstallIncludes)
include(MdtInstallLibrary)
include(MdtInstallMdtLibrary)
include(MdtRuntimeEnvironment)
include(MdtInstallDirs)
include(MdtPackageConfigHelpers)
include(MdtTargetDependenciesHelpers)
include(MdtTargetProperties)
include(MdtTargetPackageProperties)
include(MdtVersionUtils)
include(MdtIniFileReader)
include(MdtConanBuildInfoReader)

# TODO: component syntax was never tested.
#       the generated CMake package configs are wrong for this syntax,
#       also, conanfile must be adjusted as well
#       Once all is done, enable this line to test that
# find_package(Mdt0 COMPONENTS CMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)
