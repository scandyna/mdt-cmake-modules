# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.15)

project(GlIssue08_InstallLibWithObject)

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

include(MdtInstallLibrary)
include(GNUInstallDirs)

add_library(MyLibImpl-objects OBJECT
  MyLibImpl.cpp
)
set_target_properties(MyLibImpl-objects
  PROPERTIES
    POSITION_INDEPENDENT_CODE TRUE
)

add_library(MyLib
  MyLib.cpp
)

target_link_libraries(MyLib
  PUBLIC
    MyLibImpl-objects
)

mdt_install_library(
  TARGET MyLib
  RUNTIME_DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY_DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE_DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES_DIRECTORY .
  INCLUDES_DESTINATION "include"
  EXPORT_NAME MyLib
  EXPORT_NAMESPACE Mdt0::
  INSTALL_NAMESPACE Mdt0
)
