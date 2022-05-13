
cmake_minimum_required(VERSION 3.15)

project(MdtCMakeModulesTest)

if(EXISTS "${CMAKE_BINARY_DIR}/conanbuildinfo.cmake")
  include("${CMAKE_BINARY_DIR}/conanbuildinfo.cmake")
  conan_basic_setup(NO_OUTPUT_DIRS)
endif()

message(DEBUG "MdtCMakeModulesTest: CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

message(DEBUG "MdtCMakeModulesTest: call find_package() ...")

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

message(DEBUG "MdtCMakeModulesTest: CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

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
include(MdtTargetProperties)
include(MdtTargetPackageProperties)
include(MdtVersionUtils)

# TODO: compnent syntax was never tested.
#       the generated CMake package configs are wrong for this syntax,
#       also, conanfile must be adjusted ass well
#       Once all is done, enable this line to test that
# find_package(Mdt0 COMPONENTS CMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)