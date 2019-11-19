# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.10)
project(MdtCMakeModules VERSION 0.0.1)


list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/Modules/")

# TODO shared libraries !!

option(BUILD_TESTS "Build the tests" OFF)
if(BUILD_TESTS)
  enable_testing()
  add_subdirectory("tests")
endif()

option(BUILD_DOCS "Build the documentations" OFF)
if(BUILD_DOCS)
  add_subdirectory("doc")
endif()


#
# Install directories
#

set(MDT_INSTALL_PACKAGE_NAME Mdt0)
include(GNUInstallDirs)
include(MdtInstallDirs)

# message("Main: CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
# message(MDT_INSTALL_IS_UNIX_SYSTEM_WIDE: ${MDT_INSTALL_IS_UNIX_SYSTEM_WIDE})


# The install tree can have different form.
#
# Example: Linux system wide (CMAKE_INSTALL_PREFIX == /usr):
#  /usr/share/MdtCMakeModules/cmake/MdtCMakeModulesConfig.cmake
#  /usr/share/MdtCMakeModules/Modules
#
# Example: Linux in ~/opt (CMAKE_INSTALL_PREFIX == ~/opt):
#  ~/opt/MdtCMakeModules/cmake/MdtCMakeModulesConfig.cmake
#  ~/opt/MdtCMakeModules/Modules
#
# Example: Windows system wide (CMAKE_INSTALL_PREFIX == C:\Program Files\MdtCMakeModules)
#  C:\Program Files\MdtCMakeModules\cmake\MdtCMakeModulesConfig.cmake
#  C:\Program Files\MdtCMakeModules\Modules
#

set(MDT_CMAKE_MODULE_INSTALL_MODULES_DIR "${MDT_INSTALL_DATADIR}/Modules")
set(MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR "${MDT_INSTALL_DATADIR}/cmake")

# message("MDT_INSTALL_INCLUDEDIR: ${MDT_INSTALL_INCLUDEDIR}")
# message("MDT_CMAKE_MODULE_INSTALL_MODULES_DIR: ${MDT_CMAKE_MODULE_INSTALL_MODULES_DIR}")
# message("MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR: ${MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR}")


#
# Modules installation
#

install(
  FILES
    "Modules/AddQt5ToCMakePrefixPath.cmake"
    "Modules/FindSphinx.cmake"
    "Modules/MdtAddLibrary.cmake"
    "Modules/MdtInstallDirs.cmake"
    "Modules/MdtInstallLibrary.cmake"
    "Modules/MdtInstallMdtLibrary.cmake"
    "Modules/MdtPackageConfigHelpers.cmake"
    "Modules/MdtTargetPackageProperties.cmake"
    "Modules/MdtTargetProperties.cmake"
  DESTINATION "${MDT_CMAKE_MODULE_INSTALL_MODULES_DIR}"
)

include(CMakePackageConfigHelpers)
configure_package_config_file(
  MdtCMakeModulesConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/MdtCMakeModulesConfig.cmake
  INSTALL_DESTINATION "${MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR}"
  PATH_VARS MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR
)

install(
  FILES
    "${CMAKE_CURRENT_BINARY_DIR}/MdtCMakeModulesConfig.cmake"
#   "${CMAKE_CURRENT_BINARY_DIR}/MdtCMakeModulesVersion.cmake"
  DESTINATION "${MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR}"
)

include(MdtPackageConfigHelpers)
if(NOT MDT_INSTALL_IS_UNIX_SYSTEM_WIDE)
  mdt_install_namespace_package_config_file(
    INSTALL_NAMESPACE Mdt0
    DESTINATION "${MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR}"
  )
endif()
