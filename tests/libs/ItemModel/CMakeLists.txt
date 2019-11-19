
cmake_minimum_required(VERSION 3.10)

project(MdtItemModel VERSION 0.0.1)

message("tests MdtItemModel CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

set(MDT_INSTALL_PACKAGE_NAME Mdt0)
include(GNUInstallDirs)
include(MdtInstallDirs)
include(MdtPackageConfigHelpers)

add_subdirectory(src)

if(NOT MDT_INSTALL_IS_UNIX_SYSTEM_WIDE)
  mdt_install_namespace_package_config_file(
    INSTALL_NAMESPACE Mdt0
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0
    COMPONENT Mdt_Dev
  )
  mdt_install_namespace_package_config_version_file(
    INSTALL_NAMESPACE Mdt0
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY ExactVersion
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0
    COMPONENT Mdt_Dev
  )
endif()
