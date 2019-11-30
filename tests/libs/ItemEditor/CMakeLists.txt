
cmake_minimum_required(VERSION 3.10)

project(MdtItemEditor VERSION 0.0.1)

message("tests MdtItemEditor CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

option(BUILD_TESTS "Build the tests" OFF)

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)
find_package(Mdt0 0.0.1 COMPONENTS ItemModel REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

set(MDT_INSTALL_PACKAGE_NAME Mdt0)
include(GNUInstallDirs)
include(MdtInstallDirs)

add_subdirectory(src)

if(BUILD_TESTS)
  enable_testing()
  add_subdirectory(tests)
endif()

if(NOT MDT_INSTALL_IS_UNIX_SYSTEM_WIDE)
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
