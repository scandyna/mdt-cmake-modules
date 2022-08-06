# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.14)

##################################################################
# Project definition with versionning got from git tag or by Conan
##################################################################

find_package(Git REQUIRED)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/Modules/")
include(MdtVersionUtils)

set(INITIAL_PROJECT_VERSION)
if(FROM_CONAN_PROJECT_VERSION)
  set(INITIAL_PROJECT_VERSION ${FROM_CONAN_PROJECT_VERSION})
else()
  mdt_cmake_project_version_from_git_tag(INITIAL_PROJECT_VERSION DEFAULT_VERSION 0.0.0)
endif()

project(MdtCMakeModules VERSION ${INITIAL_PROJECT_VERSION})

unset(INITIAL_PROJECT_VERSION)

message(STATUS "PROJECT_VERSION: ${PROJECT_VERSION}")


# TODO shared libraries !!

include(MdtBuildOptionsUtils)

mdt_set_available_build_types(Release Debug)
option(BUILD_TESTS "Build the tests" OFF)
option(BUILD_CONAN_TESTS "Build packaging with Conan tests" OFF)
option(BUILD_QT_TESTS "Build the tests depending on Qt" OFF)
option(INSTALL_CONAN_PACKAGE_FILES "Install files required for recent conan generators, like CMakeDeps" OFF)

# MdtFindPathInList
# See its documentation to understang why it is generated
set(MdtFindPathInList_FUNCTION_NAME mdt_find_path_in_list)
configure_file(Modules/MdtFindPathInList.cmake.in MdtFindPathInList.cmake @ONLY)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_BINARY_DIR}")


if(BUILD_CONAN_TESTS)
  find_program(CONAN_COMMAND NAMES conan)
endif()

if(BUILD_QT_TESTS)
  include(AddQt5ToCMakePrefixPath)
  set(QT_PREFIX_PATH CACHE PATH "Path to the root of Qt distribution. (For example: /opt/qt/Qt5/5.13.0/gcc_64). If empty, system distribution is considered.")
  add_qt5_to_cmake_prefix_path("${QT_PREFIX_PATH}")
  find_package(Qt5 COMPONENTS Core REQUIRED)
endif()

if(BUILD_TESTS)
  option(
    BUILD_REAL_INSTALL_TESTS
    "Build tests that installs components system wide. This should only be enabled in virtualized environment, like a Docker image."
    OFF
  )
endif()

option(BUILD_DOCS "Build the documentations" OFF)
if(BUILD_DOCS)
  add_subdirectory("doc")
endif()


#
# Install directories
#

set(MDT_INSTALL_PACKAGE_NAME MdtCMakeModules)
include(GNUInstallDirs)
include(MdtInstallDirs)

include(MdtInstallCMakeModules)

# message("Main: CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
# message(MDT_INSTALL_IS_UNIX_SYSTEM_WIDE: ${MDT_INSTALL_IS_UNIX_SYSTEM_WIDE})


# set(MDT_CMAKE_MODULE_INSTALL_MODULES_DIR "${MDT_INSTALL_DATADIR}/Modules")
set(MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR "${MDT_INSTALL_DATADIR}/cmake")

# message("MDT_INSTALL_INCLUDEDIR: ${MDT_INSTALL_INCLUDEDIR}")
# message("MDT_CMAKE_MODULE_INSTALL_MODULES_DIR: ${MDT_CMAKE_MODULE_INSTALL_MODULES_DIR}")
# message("MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR: ${MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR}")


mdt_install_cmake_modules(
  FILES
    "Modules/AddQt5ToCMakePrefixPath.cmake"
    "Modules/FindSphinx.cmake"
    "Modules/MdtAddLibrary.cmake"
    "Modules/MdtInstallCMakeModules.cmake"
    "Modules/MdtInstallDirs.cmake"
    "Modules/MdtInstallLibrary.cmake"
    "Modules/MdtInstallMdtLibrary.cmake"
    "Modules/MdtInstallExecutable.cmake"
    "Modules/MdtPackageConfigHelpers.cmake"
    "Modules/MdtTargetDependenciesHelpers.cmake"
    "Modules/MdtTargetPackageProperties.cmake"
    "Modules/MdtTargetProperties.cmake"
    "Modules/MdtInstallIncludes.cmake"
    "Modules/MdtRuntimeEnvironment.cmake"
    "Modules/MdtSanitizers.cmake"
    "Modules/MdtVersionUtils.cmake"
    "Modules/MdtBuildOptionsUtils.cmake"
    "Modules/MdtAddTest.cmake"
    "Modules/MdtFindPathInList.cmake.in"
    "${CMAKE_BINARY_DIR}/MdtFindPathInList.cmake"
    "Modules/MdtIniFileReader.cmake"
    "Modules/MdtConanBuildInfoReader.cmake"
  EXPORT_NAME CMakeModules
  EXPORT_NAMESPACE Mdt
  INSTALL_CONAN_CMAKE_PACKAGE_FILE ${INSTALL_CONAN_PACKAGE_FILES}
  INSTALL_IS_UNIX_SYSTEM_WIDE ${MDT_INSTALL_IS_UNIX_SYSTEM_WIDE}
  MODULES_PATH_VARIABLE_NAME MDT_CMAKE_MODULES_PATH
)

include(MdtPackageConfigHelpers)
if(NOT MDT_INSTALL_IS_UNIX_SYSTEM_WIDE)
  mdt_install_namespace_package_config_file(
    INSTALL_NAMESPACE Mdt0
    DESTINATION "${MDT_CMAKE_MODULE_INSTALL_CONFIG_DIR}"
  )
endif()

if(BUILD_TESTS)

  enable_testing()

  add_subdirectory(tests)

  # Add static tests
  # Those are tests that runs at configuration time
  # Let them at the very end, because they play with targets and environment
  # As example, see:
  # https://gitlab.com/scandyna/mdt-cmake-modules/-/jobs/2760800579
  #  -- Conan: Settings= -s;build_type=Debug;-s;compiler=gcc;-s;compiler.version=7;-s;compiler.libcxx=libc++
  #  the wrong libcxx was set here
  # related test then failed because of that:
  # https://gitlab.com/scandyna/mdt-cmake-modules/-/jobs/2760800583
  add_subdirectory(tests/static)

endif()


#
# Debug informations
#

# message(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
# message(STATUS "CMAKE_CONFIGURATION_TYPES: ${CMAKE_CONFIGURATION_TYPES}")
