
cmake_minimum_required(VERSION 3.14)

project(user VERSION 0.0.1)

message(DEBUG "user CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

find_package(Mdt0DeployUtils REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

include(ModuleA)
