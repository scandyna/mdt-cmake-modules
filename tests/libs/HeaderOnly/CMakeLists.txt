cmake_minimum_required(VERSION 3.10)

project(MdtHeaderOnly VERSION 0.0.1)

option(BUILD_TESTS "Build the tests" OFF)
option(INSTALL_NAMESPACE_PACKAGE_CONFIG_FILES "Install the package configuration files to support the component syntax of find_package()" OFF)

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

set(MDT_INSTALL_PACKAGE_NAME Mdt0)
include(GNUInstallDirs)
include(MdtInstallDirs)
include(MdtPackageConfigHelpers)

add_subdirectory(src)

if(BUILD_TESTS)
  enable_testing()
  add_subdirectory(tests)
endif()

if(INSTALL_NAMESPACE_PACKAGE_CONFIG_FILES)
  mdt_install_namespace_package_config_file(
    INSTALL_NAMESPACE ${MDT_INSTALL_PACKAGE_NAME}
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${MDT_INSTALL_PACKAGE_NAME}
    COMPONENT Mdt_Dev
  )
  mdt_install_namespace_package_config_version_file(
    INSTALL_NAMESPACE ${MDT_INSTALL_PACKAGE_NAME}
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY ExactVersion
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${MDT_INSTALL_PACKAGE_NAME}
    COMPONENT Mdt_Dev
  )
endif()
