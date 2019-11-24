# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

# cmake_minimum_required(VERSION 3.10)
# project(MdtCMakeModulesTest)

# The top level CMakeLists.txt will call use with CMAKE_PREFIX_PATH pointing to the Modules of this source code
# Conan test package will call use with CMAKE_PREFIX_PATH pointing to the Modules of its installed package

# find_package(MdtCMakeModules REQUIRED)

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

set_tests_properties(InstallMdtCMakeModules PROPERTIES DEPENDS BuildMdtCMakeModules)

########################################
# Test installing in different locations
########################################

# TODO: won't work for app

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

set_tests_properties(BuildMdtItemModel PROPERTIES DEPENDS InstallMdtCMakeModules)
set_tests_properties(InstallMdtItemModel PROPERTIES DEPENDS BuildMdtItemModel)

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

set_tests_properties(BuildMdtItemEditor PROPERTIES DEPENDS InstallMdtItemModel)
set_tests_properties(InstallMdtItemEditor PROPERTIES DEPENDS BuildMdtItemEditor)


# Build + run TableEditor app

add_test(NAME BuildAndRunTableEditor
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/TableEditor" "${CMAKE_CURRENT_BINARY_DIR}/buildTableEditor"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemModel;${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemEditor"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/TableEditor"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)

set_tests_properties(BuildAndRunTableEditor PROPERTIES DEPENDS BuildMdtItemEditor)

# TODO: later, should install TableEditor and run from the install location

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

####################################
# Test installing with Conan
####################################

if(BUILD_CONAN_TESTS)

  # Build and install MdtCMakeModules
  add_test(NAME Conan_Create_MdtCMakeModules
    COMMAND "${CONAN_COMMAND}"
      create "${CMAKE_SOURCE_DIR}" "MdtCMakeModules_tests/testing"
      --build
  )

  # Build and install MdtItemModel
  add_test(NAME Conan_Create_MdtItemModel
    COMMAND "${CONAN_COMMAND}"
      create "${CMAKE_CURRENT_SOURCE_DIR}/libs/ItemModel" "0.1@MdtCMakeModules_tests/testing"
      --build
  )

  set_tests_properties(Conan_Create_MdtItemModel PROPERTIES DEPENDS Conan_Create_MdtCMakeModules)

  # Build TableEditor with Conan + run the app

  # TODO --build ?
  add_test(NAME Conan_Install_TableEditor_dependecies
    COMMAND "${CONAN_COMMAND}"
      install "${CMAKE_CURRENT_SOURCE_DIR}/apps/TableEditor"
      --generator cmake_paths
      --install-folder "${CMAKE_CURRENT_BINARY_DIR}/conanBuildTableEditor"
      --build=missing
      --options *:shared=True
  )

  add_test(NAME Conan_BuildAndRun_TableEditor
    COMMAND "${CMAKE_CTEST_COMMAND}"
      --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/TableEditor" "${CMAKE_CURRENT_BINARY_DIR}/conanBuildTableEditor"
      --build-generator "${CMAKE_GENERATOR}"
      --build-options
        "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_BINARY_DIR}/conanBuildTableEditor/conan_paths.cmake"
        "-DBUILD_SHARED_LIBS=ON"
      --test-command "${CMAKE_CTEST_COMMAND}"
  )

  set_tests_properties(Conan_BuildAndRun_TableEditor PROPERTIES DEPENDS Conan_Install_TableEditor_dependecies)

endif()
