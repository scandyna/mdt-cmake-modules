# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.10)
project(MdtCMakeModulesTest)

# The top level CMakeLists.txt will call use with CMAKE_PREFIX_PATH pointing to the Modules of this source code
# Conan test package will call use with CMAKE_PREFIX_PATH pointing to the Modules of its installed package

message("MdtCMakeModulesTest CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

find_package(MdtCMakeModules REQUIRED)

include(AddQt5ToCMakePrefixPath)
include(MdtPackageConfigHelpers)

set(QT_PREFIX_PATH CACHE PATH "Path to the root of Qt distribution. (For example: /opt/qt/Qt5/5.13.0/gcc_64). If empty, system distribution is considered.")
add_qt5_to_cmake_prefix_path("${QT_PREFIX_PATH}")

find_package(Qt5 COMPONENTS Core REQUIRED)

add_executable(hello "src/hello.cpp")
target_link_libraries(hello Qt5::Core)
add_test(NAME helloTest COMMAND hello)

########################################
# Test installing in different locations
########################################

# Build + install MdtItemModel with:
# - CMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH}"
# - CMAKE_INSTALL_PREFIX="${CMAKE_CURRENT_BINARY_DIR}/MdtItemModel"

# Build + install MdtItemEditor with:
# - CMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH};${CMAKE_CURRENT_BINARY_DIR}/MdtItemModel"
# - CMAKE_INSTALL_PREFIX="${CMAKE_CURRENT_BINARY_DIR}/MdtItemEditor"

# Build + run MyApp with:
# - CMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH};${CMAKE_CURRENT_BINARY_DIR}/MdtItemModel;${CMAKE_CURRENT_BINARY_DIR}/MdtItemEditor"



####################################
# Test installing in common location
####################################

# TODO: better: simulate a unix system wide install with DESTDIR

# Build + install MdtItemModel with:
# - CMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH}"
# - CMAKE_INSTALL_PREFIX="${CMAKE_CURRENT_BINARY_DIR}/CommonInstall"

# Build + install MdtItemEditor with:
# - CMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH};${CMAKE_CURRENT_BINARY_DIR}/CommonInstall"
# - CMAKE_INSTALL_PREFIX="${CMAKE_CURRENT_BINARY_DIR}/CommonInstall"

# Build + run MyApp with:
# - CMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH};${CMAKE_CURRENT_BINARY_DIR}/CommonInstall"
