
cmake_minimum_required(VERSION 3.2)

project(MdtCMakeModulesTest)

message("CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)
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
