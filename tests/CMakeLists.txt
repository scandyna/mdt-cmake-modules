# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

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

# Build and install MdtCMakeModules

add_test(NAME Build_MdtCMakeModules
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtCMakeModules"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
)

add_test(NAME Install_MdtCMakeModules
  COMMAND "${CMAKE_COMMAND}"
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMdtCMakeModules/cmake_install.cmake"
)

set_tests_properties(Install_MdtCMakeModules PROPERTIES DEPENDS Build_MdtCMakeModules)

# Simple app that only depends on MdtCMakeModules

add_test(NAME BuildAndRun_Hello
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/Hello" "${CMAKE_CURRENT_BINARY_DIR}/buildHello"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
    --test-command "${CMAKE_CTEST_COMMAND}"
)

set_tests_properties(BuildAndRun_Hello PROPERTIES DEPENDS Install_MdtCMakeModules)


# Simple application to check MdtBuildOptionsUtils module
add_test(NAME BuildAndRun_HelloCompileOptions
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/HelloCompileOptions" "${CMAKE_CURRENT_BINARY_DIR}/buildHelloCompileOptions"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(BuildAndRun_HelloCompileOptions PROPERTIES DEPENDS Install_MdtCMakeModules)

# Build + install MdtItemModel

add_test(NAME Build_MdtItemModel
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/libs/ItemModel" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemModel"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemModel"
      "-DINSTALL_NAMESPACE_PACKAGE_CONFIG_FILES=ON"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)

add_test(NAME Install_MdtItemModel
  COMMAND "${CMAKE_COMMAND}"
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemModel/cmake_install.cmake"
)

set_tests_properties(Build_MdtItemModel PROPERTIES DEPENDS Install_MdtCMakeModules)
set_tests_properties(Install_MdtItemModel PROPERTIES DEPENDS Build_MdtItemModel)

# Build + install MdtItemEditor

add_test(NAME Build_MdtItemEditor
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/libs/ItemEditor" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemEditor"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemModel"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemEditor"
      "-DINSTALL_NAMESPACE_PACKAGE_CONFIG_FILES=ON"
      "-DBUILD_SHARED_LIBS=ON"
      "-DBUILD_TESTS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)

add_test(NAME Install_MdtItemEditor
  COMMAND "${CMAKE_COMMAND}"
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemEditor/cmake_install.cmake"
)

set_tests_properties(Build_MdtItemEditor PROPERTIES DEPENDS Install_MdtItemModel)
set_tests_properties(Install_MdtItemEditor PROPERTIES DEPENDS Build_MdtItemEditor)


# Build + run TableEditor app

add_test(NAME BuildAndRun_TableEditor
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/TableEditor" "${CMAKE_CURRENT_BINARY_DIR}/buildTableEditor"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemModel;${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemEditor"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/TableEditor"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)

set_tests_properties(BuildAndRun_TableEditor PROPERTIES DEPENDS Install_MdtItemEditor)

# TODO: later, should install TableEditor and run from the install location

########################################
# Test building a superproject
########################################

add_test(NAME Build_MultiDevTools
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/MultiDevTools" "${CMAKE_CURRENT_BINARY_DIR}/buildMultiDevTools"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/MultiDevTools"
      "-DINSTALL_NAMESPACE_PACKAGE_CONFIG_FILES=ON"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(Build_MultiDevTools PROPERTIES DEPENDS Install_MdtCMakeModules)

add_test(NAME Install_MultiDevTools
  COMMAND "${CMAKE_COMMAND}"
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMultiDevTools/cmake_install.cmake"
)
set_tests_properties(Install_MultiDevTools PROPERTIES DEPENDS Build_MultiDevTools)


add_test(NAME BuildAndRun_TableEditor_Mdt
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/TableEditor_Mdt" "${CMAKE_CURRENT_BINARY_DIR}/buildTableEditor_Mdt"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/opt/MultiDevTools"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/TableEditor_Mdt"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(BuildAndRun_TableEditor_Mdt PROPERTIES DEPENDS Install_MultiDevTools)


####################################
# Test installing in common location
####################################

# Build and install MdtCMakeModules

add_test(NAME Build_MdtCMakeModules_CL
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtCMakeModulesCL"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_INSTALL_PREFIX=/usr"
)

add_test(NAME Install_MdtCMakeModules_CL
  COMMAND "${CMAKE_COMMAND}"
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMdtCMakeModulesCL/cmake_install.cmake"
)

set_tests_properties(Install_MdtCMakeModules_CL
  PROPERTIES
    DEPENDS Build_MdtCMakeModules_CL
    ENVIRONMENT "DESTDIR=${CMAKE_CURRENT_BINARY_DIR}"
)

# Build + install MdtItemModel

add_test(NAME Build_MdtItemModel_CL
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/libs/ItemModel" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemModelCL"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/usr"
      "-DCMAKE_INSTALL_PREFIX=/usr"
      "-DBUILD_SHARED_LIBS=ON"
      "-DINSTALL_NAMESPACE_PACKAGE_CONFIG_FILES=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)

set_tests_properties(Build_MdtItemModel_CL PROPERTIES DEPENDS Install_MdtCMakeModules_CL)

add_test(NAME Install_MdtItemModel_CL
  COMMAND "${CMAKE_COMMAND}"
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemModelCL/cmake_install.cmake"
)

set_tests_properties(Install_MdtItemModel_CL
  PROPERTIES
    DEPENDS Build_MdtItemModel_CL
    ENVIRONMENT "DESTDIR=${CMAKE_CURRENT_BINARY_DIR}"
)

# Build + install MdtItemEditor

add_test(NAME Build_MdtItemEditor_CL
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/libs/ItemEditor" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemEditorCL"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/usr"
      "-DCMAKE_INSTALL_PREFIX=/usr"
      "-DBUILD_SHARED_LIBS=ON"
      "-DINSTALL_NAMESPACE_PACKAGE_CONFIG_FILES=OFF"
    --test-command "${CMAKE_CTEST_COMMAND}"
)

set_tests_properties(Build_MdtItemEditor_CL PROPERTIES DEPENDS Build_MdtItemModel_CL)

add_test(NAME Install_MdtItemEditor_CL
  COMMAND "${CMAKE_COMMAND}"
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemEditorCL/cmake_install.cmake"
)

set_tests_properties(Install_MdtItemEditor_CL
  PROPERTIES
    DEPENDS Build_MdtItemEditor_CL
    ENVIRONMENT "DESTDIR=${CMAKE_CURRENT_BINARY_DIR}"
)

# Build + run TableEditor app

add_test(NAME BuildAndRun_TableEditor_CL
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/TableEditor" "${CMAKE_CURRENT_BINARY_DIR}/buildTableEditorCL"
    --build-generator "${CMAKE_GENERATOR}"
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/usr"
      "-DCMAKE_INSTALL_PREFIX=/usr"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)

set_tests_properties(BuildAndRun_TableEditor_CL PROPERTIES DEPENDS Install_MdtItemEditor_CL)


####################################
# Test installing with Conan
####################################

if(BUILD_CONAN_TESTS)

  include(conan.cmake)
  conan_cmake_settings(conanSettings)

  # Build and install MdtCMakeModules
  add_test(NAME Conan_Create_MdtCMakeModules
    COMMAND "${CONAN_COMMAND}"
      create "${CMAKE_SOURCE_DIR}" "0.2@MdtCMakeModules_tests/testing"
      ${conanSettings}
  )

  # Build and install MdtItemModel
  add_test(NAME Conan_Create_MdtItemModel
    COMMAND "${CONAN_COMMAND}"
      create "${CMAKE_CURRENT_SOURCE_DIR}/libs/ItemModel" "0.1@MdtCMakeModules_tests/testing"
      ${conanSettings}
  )
  set_tests_properties(Conan_Create_MdtItemModel PROPERTIES DEPENDS Conan_Create_MdtCMakeModules)

  # Build and install MdtItemEditor
  add_test(NAME Conan_Create_MdtItemEditor
    COMMAND "${CONAN_COMMAND}"
      create "${CMAKE_CURRENT_SOURCE_DIR}/libs/ItemEditor" "0.1@MdtCMakeModules_tests/testing"
      ${conanSettings}
  )
  set_tests_properties(Conan_Create_MdtItemEditor PROPERTIES DEPENDS Conan_Create_MdtItemModel)

  # Build TableEditor with Conan + run the app
  add_test(NAME Conan_Install_TableEditor_dependecies
    COMMAND "${CONAN_COMMAND}"
      install "${CMAKE_CURRENT_SOURCE_DIR}/apps/TableEditor"
      --generator cmake_paths
      --install-folder "${CMAKE_CURRENT_BINARY_DIR}/conanBuildTableEditor"
      --options *:shared=True
      ${conanSettings}
  )
  set_tests_properties(Conan_Install_TableEditor_dependecies PROPERTIES DEPENDS Conan_Create_MdtItemEditor)

  add_test(NAME Conan_BuildAndRun_TableEditor
    COMMAND "${CMAKE_CTEST_COMMAND}"
      --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/TableEditor" "${CMAKE_CURRENT_BINARY_DIR}/conanBuildTableEditor"
      --build-generator "${CMAKE_GENERATOR}"
      --build-options
        "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_BINARY_DIR}/conanBuildTableEditor/conan_paths.cmake"
        "-DBUILD_SHARED_LIBS=ON"
      --test-command "${CMAKE_CTEST_COMMAND}"
      ${conanSettings}
  )
  set_tests_properties(Conan_BuildAndRun_TableEditor PROPERTIES DEPENDS Conan_Install_TableEditor_dependecies)

  # Remove installed test packages

  add_test(NAME Conan_Remove_MdtCMakeModules
    COMMAND "${CONAN_COMMAND}"
      remove "MdtCmakeModules/*@MdtCMakeModules_tests/testing"
      --force
  )
  set_tests_properties(Conan_Remove_MdtCMakeModules PROPERTIES DEPENDS Conan_BuildAndRun_TableEditor)

  add_test(NAME Conan_Remove_MdtItemModel
    COMMAND "${CONAN_COMMAND}"
      remove "MdtCmakeModulesTests_MdtItemModel/0.1@MdtCMakeModules_tests/testing"
      --force
  )
  set_tests_properties(Conan_Remove_MdtItemModel PROPERTIES DEPENDS Conan_BuildAndRun_TableEditor)

  add_test(NAME Conan_Remove_MdtItemEditor
    COMMAND "${CONAN_COMMAND}"
      remove "MdtCmakeModulesTests_MdtItemEditor/0.1@MdtCMakeModules_tests/testing"
      --force
  )
  set_tests_properties(Conan_Remove_MdtItemEditor PROPERTIES DEPENDS Conan_BuildAndRun_TableEditor)

endif()
