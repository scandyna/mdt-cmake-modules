
cmake_minimum_required(VERSION 3.2)

project(MdtCMakeModulesTest)

find_package(MdtCMakeModules)

message("CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")

include(MdtInstallDirs)
