# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

include(AddQt5ToCMakePrefixPath)
include(MdtPackageConfigHelpers)
include(MdtAddTest)


#######################################################
# Build a simple Qt executable
# Check also that it can run when Qt is not in the PATH
#######################################################

if(BUILD_QT_TESTS)
  mdt_add_test(
    NAME HelloQt
    TARGET helloQt
    DEPENDENCIES Qt5::Core
    SOURCE_FILES
      "src/hello.cpp"
  )
endif()

###################################
# Build and install MdtCMakeModules
# Will be used by several tests
###################################

add_test(NAME Build_MdtCMakeModules
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtCMakeModules"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
      "-DCMAKE_CONFIGURATION_TYPES=Debug"
      "-DBUILD_TESTS=OFF"
)

add_test(NAME Install_MdtCMakeModules
  COMMAND "${CMAKE_COMMAND}"
    -DCMAKE_INSTALL_CONFIG_NAME=$<CONFIG>
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMdtCMakeModules/cmake_install.cmake"
)
set_tests_properties(Install_MdtCMakeModules PROPERTIES DEPENDS Build_MdtCMakeModules)


#################################################
# Simple app that only depends on MdtCMakeModules
#################################################

add_test(NAME BuildAndRun_Hello
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/Hello" "${CMAKE_CURRENT_BINARY_DIR}/buildHello"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
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
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(BuildAndRun_HelloCompileOptions PROPERTIES DEPENDS Install_MdtCMakeModules)

################################################
# Build a simple executable that uses Sanitizers
################################################

add_test(NAME BuildAndRun_HelloASan
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/Sanitizers" "${CMAKE_CURRENT_BINARY_DIR}/buildHelloASan"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
      "-DTEST_ADDRESS_SANITIZER=ON"
      "-DCMAKE_BUILD_TYPE=Debug"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(BuildAndRun_HelloASan PROPERTIES DEPENDS Install_MdtCMakeModules)


add_test(NAME BuildAndRun_HelloMSan
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/Sanitizers" "${CMAKE_CURRENT_BINARY_DIR}/buildHelloMSan"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
      "-DTEST_MEMORY_SANITIZER=ON"
      "-DCMAKE_BUILD_TYPE=Debug"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(BuildAndRun_HelloMSan PROPERTIES DEPENDS Install_MdtCMakeModules)


add_test(NAME BuildAndRun_HelloUBSan
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/Sanitizers" "${CMAKE_CURRENT_BINARY_DIR}/buildHelloUBSan"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
      "-DTEST_UNDEFINED_SANITIZER=ON"
      "-DCMAKE_BUILD_TYPE=Debug"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(BuildAndRun_HelloUBSan PROPERTIES DEPENDS Install_MdtCMakeModules)


add_test(NAME BuildAndRun_HelloTSan
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/Sanitizers" "${CMAKE_CURRENT_BINARY_DIR}/buildHelloTSan"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
      "-DTEST_THREAD_SANITIZER=ON"
      "-DCMAKE_BUILD_TYPE=Debug"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(BuildAndRun_HelloTSan PROPERTIES DEPENDS Install_MdtCMakeModules)

######################################################################
# gl_issue2: mdt_install_library() produces error for STATIC librariy
######################################################################

# Compile and install a static library

add_test(NAME Build_MultiDevTools_Static
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/MultiDevTools" "${CMAKE_CURRENT_BINARY_DIR}/buildMultiDevToolsStatic"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/MultiDevTools"
      "-DINSTALL_NAMESPACE_PACKAGE_CONFIG_FILES=ON"
      "-DBUILD_SHARED_LIBS=OFF"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(Build_MultiDevTools_Static PROPERTIES DEPENDS Install_MdtCMakeModules)

add_test(NAME Install_MultiDevTools_Static
  COMMAND "${CMAKE_COMMAND}"
    -DCMAKE_INSTALL_CONFIG_NAME=$<CONFIG>
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMultiDevToolsStatic/cmake_install.cmake"
)
set_tests_properties(Install_MultiDevTools_Static PROPERTIES DEPENDS Build_MultiDevTools_Static)

########################################
# Test installing in different locations
########################################

# gl_issue3: configure and install a INTERFACE library

add_test(NAME ConfigureAndTest_HeaderOnly
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/libs/HeaderOnly" "${CMAKE_CURRENT_BINARY_DIR}/buildHeaderOnly"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtHeaderOnly"
      "-DINSTALL_NAMESPACE_PACKAGE_CONFIG_FILES=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(ConfigureAndTest_HeaderOnly PROPERTIES DEPENDS Install_MdtCMakeModules)

add_test(NAME Install_HeaderOnly
  COMMAND "${CMAKE_COMMAND}"
    -DCMAKE_INSTALL_CONFIG_NAME=$<CONFIG>
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildHeaderOnly/cmake_install.cmake"
)
set_tests_properties(Install_HeaderOnly PROPERTIES DEPENDS ConfigureAndTest_HeaderOnly)


# Build + install MdtItemModel

add_test(NAME Build_MdtItemModel
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/libs/ItemModel" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemModel"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/opt/MdtHeaderOnly"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemModel"
      "-DINSTALL_NAMESPACE_PACKAGE_CONFIG_FILES=ON"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(Build_MdtItemModel PROPERTIES DEPENDS Install_HeaderOnly)

add_test(NAME Install_MdtItemModel
  COMMAND "${CMAKE_COMMAND}"
    -DCMAKE_INSTALL_CONFIG_NAME=$<CONFIG>
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemModel/cmake_install.cmake"
)
set_tests_properties(Install_MdtItemModel PROPERTIES DEPENDS Build_MdtItemModel)

# Build + install MdtItemEditor

add_test(NAME Build_MdtItemEditor
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/libs/ItemEditor" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemEditor"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
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
    -DCMAKE_INSTALL_CONFIG_NAME=$<CONFIG>
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemEditor/cmake_install.cmake"
)

set_tests_properties(Build_MdtItemEditor PROPERTIES DEPENDS Install_MdtItemModel)
set_tests_properties(Install_MdtItemEditor PROPERTIES DEPENDS Build_MdtItemEditor)


# Build + run TableEditor app

add_test(NAME BuildAndRun_TableEditor
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/TableEditor" "${CMAKE_CURRENT_BINARY_DIR}/buildTableEditor"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemModel;${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemEditor"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/opt/TableEditor"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)

set_tests_properties(BuildAndRun_TableEditor PROPERTIES DEPENDS Install_MdtItemEditor)

# TODO: later, should install TableEditor and run from the install location

#######################################################################
# gl_issue4
# mdt_add_test() does not add dependencies in ENVIRONMENT transitively
# A project looks like:
# apps
#  |--TableEditor
#  |      |--src
#  |      |   |--main.cpp
# libs
#  |--TableEditorHelpers
#           |--src
#           |   |--TableEditorHelpers.h
#           |   |--TableEditorHelpers.cpp
#           |--tests
#                |--src
#                    |--TableEditorHelpersTest.cpp
#
#
# In libs/TableEditorHelpers, a target named tableEditorHelpers is created.
# tableEditorHelpers has a PUBLIC dependecy to Mdt0::ItemEditor (external library)
#
# Mdt0::ItemEditor also depends on Mdt0::ItemModel.
#
# In libs/TableEditorHelpers/tests, a target named tableEditorHelpersTest is created.
# tableEditorHelpersTest has a dependecy to tableEditorHelpers
#
# To be able to run tableEditorHelpersTest,
# TableEditorHelpersTest must have its ENVIRONMENT PATH
# containing all the dependencies, transitively
#######################################################################

add_test(NAME BuildAndTest_TableEditorGlIssue4
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/TableEditorGlIssue4" "${CMAKE_CURRENT_BINARY_DIR}/buildTableEditorGlIssue4"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemModel;${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemEditor"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)

set_tests_properties(BuildAndTest_TableEditorGlIssue4 PROPERTIES DEPENDS Install_MdtItemEditor)

#######################################################################
# gl_issue4 - New case from 21.07.2020
# libs
#   |-Core
#   |   |-src
#   |   |-tests
#   |-Domain
#   |   |-src
#   |-TestLib
#       |-src
#
# In Core, we tests that have a PUBLIC dependency on TestLib.
# TestLib also has a PUBLIC dependency on Domain.
# Domain has a PUBLIC dependency on Mdt0::PlainText_QtCore.
#
# To summarize:
# CoreTests -> TestLib -> Domain -> Mdt0::PlainText_QtCore
#
# Here we will replace Mdt0::PlainText_QtCore by Mdt0::ItemModel:
# CoreTests -> TestLib -> Domain -> Mdt0::ItemModel
#######################################################################

add_test(NAME BuildAndTest_GlIssue4CoreTestLibDomain
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/GlIssue4CoreTestLibDomain" "${CMAKE_CURRENT_BINARY_DIR}/buildGlIssue4CoreTestLibDomain"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/opt/MdtItemModel"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)

set_tests_properties(BuildAndTest_GlIssue4CoreTestLibDomain PROPERTIES DEPENDS Install_MdtItemEditor)

# See https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/4
set_tests_properties(BuildAndTest_GlIssue4CoreTestLibDomain PROPERTIES DISABLED YES)

########################################
# Test building a superproject
########################################

add_test(NAME Build_MultiDevTools
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/MultiDevTools" "${CMAKE_CURRENT_BINARY_DIR}/buildMultiDevTools"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
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
    -DCMAKE_INSTALL_CONFIG_NAME=$<CONFIG>
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMultiDevTools/cmake_install.cmake"
)
set_tests_properties(Install_MultiDevTools PROPERTIES DEPENDS Build_MultiDevTools)


add_test(NAME BuildAndRun_TableEditor_Mdt
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/TableEditor_Mdt" "${CMAKE_CURRENT_BINARY_DIR}/buildTableEditor_Mdt"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
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
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_INSTALL_PREFIX=/usr"
)

add_test(NAME Install_MdtCMakeModules_CL
  COMMAND "${CMAKE_COMMAND}"
    -DCMAKE_INSTALL_CONFIG_NAME=$<CONFIG>
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildMdtCMakeModulesCL/cmake_install.cmake"
)

set_tests_properties(Install_MdtCMakeModules_CL
  PROPERTIES
    DEPENDS Build_MdtCMakeModules_CL
    ENVIRONMENT "DESTDIR=${CMAKE_CURRENT_BINARY_DIR}"
)


# gl_issue3: configure and install a INTERFACE library

add_test(NAME ConfigureAndTest_HeaderOnly_CL
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/libs/HeaderOnly" "${CMAKE_CURRENT_BINARY_DIR}/buildHeaderOnlyCL"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/usr"
      "-DCMAKE_INSTALL_PREFIX=/usr"
      "-DINSTALL_NAMESPACE_PACKAGE_CONFIG_FILES=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(ConfigureAndTest_HeaderOnly_CL PROPERTIES DEPENDS Install_MdtCMakeModules_CL)

add_test(NAME Install_HeaderOnly_CL
  COMMAND "${CMAKE_COMMAND}"
    -DCMAKE_INSTALL_CONFIG_NAME=$<CONFIG>
    -P "${CMAKE_CURRENT_BINARY_DIR}/buildHeaderOnlyCL/cmake_install.cmake"
)
set_tests_properties(Install_HeaderOnly_CL
  PROPERTIES
    DEPENDS ConfigureAndTest_HeaderOnly_CL
    ENVIRONMENT "DESTDIR=${CMAKE_CURRENT_BINARY_DIR}"
)


# Build + install MdtItemModel

add_test(NAME Build_MdtItemModel_CL
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/libs/ItemModel" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemModelCL"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/usr"
      "-DCMAKE_INSTALL_PREFIX=/usr"
      "-DBUILD_SHARED_LIBS=ON"
      "-DINSTALL_NAMESPACE_PACKAGE_CONFIG_FILES=OFF"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(Build_MdtItemModel_CL PROPERTIES DEPENDS Install_HeaderOnly_CL)

add_test(NAME Install_MdtItemModel_CL
  COMMAND "${CMAKE_COMMAND}"
    -DCMAKE_INSTALL_CONFIG_NAME=$<CONFIG>
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
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/usr"
      "-DCMAKE_INSTALL_PREFIX=/usr"
      "-DBUILD_SHARED_LIBS=ON"
      "-DINSTALL_NAMESPACE_PACKAGE_CONFIG_FILES=OFF"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(Build_MdtItemEditor_CL PROPERTIES DEPENDS Install_MdtItemModel_CL)

add_test(NAME Install_MdtItemEditor_CL
  COMMAND "${CMAKE_COMMAND}"
    -DCMAKE_INSTALL_CONFIG_NAME=$<CONFIG>
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
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
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

  # Build and install MdtHeaderOnly
  add_test(NAME Conan_Create_MdtHeaderOnly
    COMMAND "${CONAN_COMMAND}"
      create "${CMAKE_CURRENT_SOURCE_DIR}/libs/HeaderOnly" "0.1@MdtCMakeModules_tests/testing"
      ${conanSettings}
  )
  set_tests_properties(Conan_Create_MdtHeaderOnly PROPERTIES DEPENDS Conan_Create_MdtCMakeModules)

  # Build and install MdtItemModel
  add_test(NAME Conan_Create_MdtItemModel
    COMMAND "${CONAN_COMMAND}"
      create "${CMAKE_CURRENT_SOURCE_DIR}/libs/ItemModel" "0.1@MdtCMakeModules_tests/testing"
      ${conanSettings}
  )
  set_tests_properties(Conan_Create_MdtItemModel PROPERTIES DEPENDS Conan_Create_MdtHeaderOnly)

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
      --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
      --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
      --build-config $<CONFIG>
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
