
cmake_minimum_required(VERSION 3.10)

project(TableEditorUserProject)

message("tests TableEditorUserProject CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

find_package(Git REQUIRED)
find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

include(MdtVersionUtils)

mdt_cmake_project_version_from_git_tag(GIT_TAG_VERSION DEFAULT_VERSION 0.0.0)
project(TableEditor VERSION ${GIT_TAG_VERSION})

# find_package(Mdt0 0.0.1 COMPONENTS TableEditorExecutable REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)
find_package(Mdt0 COMPONENTS TableEditorExecutable REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

enable_testing()

add_test(NAME RunTableEditor COMMAND Mdt0::TableEditorExecutable)
