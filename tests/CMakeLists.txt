# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

# cmake_minimum_required(VERSION 3.10)
# project(MdtCMakeModulesTest)

# The top level CMakeLists.txt will call use with CMAKE_PREFIX_PATH pointing to the Modules of this source code
# Conan test package will call use with CMAKE_PREFIX_PATH pointing to the Modules of its installed package

find_package(MdtCMakeModules REQUIRED)

include(AddQt5ToCMakePrefixPath)
include(MdtPackageConfigHelpers)

set(QT_PREFIX_PATH CACHE PATH "Path to the root of Qt distribution. (For example: /opt/qt/Qt5/5.13.0/gcc_64). If empty, system distribution is considered.")
add_qt5_to_cmake_prefix_path("${QT_PREFIX_PATH}")

find_package(Qt5 COMPONENTS Core REQUIRED)

add_executable(hello "src/hello.cpp")
target_link_libraries(hello Qt5::Core)
add_test(NAME helloTest COMMAND hello)



# add_test(NAME MdtCMakeModulesTest
#   COMMAND ${CMAKE_CTEST_COMMAND}
#     --build-and-test "${CMAKE_SOURCE_DIR}/tests" "${CMAKE_BINARY_DIR}/buildAndTest"
#     --build-generator "${CMAKE_GENERATOR}"
#     --build-makeprogram ${CMAKE_MAKE_PROGRAM}
#     --build-options -D CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
#     --test-command ${CMAKE_TEST_COMMAND}
# )

message("TESTS CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

########################################
# Build and install MdtCMakeModules
########################################

add_test(NAME BuildMdtCMakeModules
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtCMakeModules"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
)

add_test(NAME InstallMdtCMakeModules
  COMMAND "${CMAKE_COMMAND}"
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMdtCMakeModules/cmake_install.cmake"
)

########################################
# Test installing in different locations
########################################


# Build + install MdtItemModel

add_test(NAME BuildMdtItemModel
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/libs/ItemModel" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemModel"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemModel"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)

add_test(NAME InstallMdtItemModel
  COMMAND "${CMAKE_COMMAND}"
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemModel/cmake_install.cmake"
)


# Build + install MdtItemEditor

add_test(NAME BuildMdtItemEditor
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/libs/ItemEditor" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemEditor"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemModel"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemEditor"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)

add_test(NAME InstallMdtItemEditor
  COMMAND "${CMAKE_COMMAND}"
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemEditor/cmake_install.cmake"
)


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
