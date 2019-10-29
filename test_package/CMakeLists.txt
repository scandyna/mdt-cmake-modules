
cmake_minimum_required(VERSION 3.2)

project(MdtCMakeModulesTest)

message("CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

find_package(MdtCMakeModules)
include(MdtInstallDirs)
include(MdtPackageConfigHelpers)
