# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

include(AddQt5ToCMakePrefixPath)
include(MdtPackageConfigHelpers)
include(MdtAddTest)
include(MdtRuntimeEnvironment)

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
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
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
# Project that only depends on MdtCMakeModules
# MdtFindPathInList
#################################################

add_test(NAME MdtFindPathInList_Usage
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/MdtFindPathInList/Usage" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtFindPathInList_Usage"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(MdtFindPathInList_Usage PROPERTIES DEPENDS Install_MdtCMakeModules)

add_test(NAME MdtFindPathInList_UsageInPackageConfig
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/MdtFindPathInList/UsageInPackageConfig" "${CMAKE_CURRENT_BINARY_DIR}/buildMdtFindPathInList_UsageInPackageConfig"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(MdtFindPathInList_UsageInPackageConfig PROPERTIES DEPENDS Install_MdtCMakeModules)

#################################################
# Project that installs its CMake modules
# in non default destination
# (CMake modules part of a other project)
#
# This checks mdt_install_cmake_modules()
# with custom destinations
#################################################

# TODO: The test project should maybe use MDT_CMAKE_MODULES_PATH

add_test(NAME MdtInstallCMakeModules_custom_DeployUtils_Configure
  COMMAND "${CMAKE_COMMAND}"
    -S "${CMAKE_CURRENT_SOURCE_DIR}/MdtInstallCMakeModules_custom/MdtDeployUtils"
    -B "${CMAKE_CURRENT_BINARY_DIR}/build/MdtInstallCMakeModules_custom/MdtDeployUtils"
    -G "${CMAKE_GENERATOR}"
    -A "${CMAKE_GENERATOR_PLATFORM}"
    -T "${CMAKE_GENERATOR_TOOLSET}"
    -DCMAKE_MESSAGE_LOG_LEVEL=DEBUG
    "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
    "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtDeployUtils"
)
set_tests_properties(MdtInstallCMakeModules_custom_DeployUtils_Configure PROPERTIES DEPENDS Install_MdtCMakeModules)

add_test(NAME MdtInstallCMakeModules_custom_DeployUtils_Build
  COMMAND "${CMAKE_COMMAND}"
    --build "${CMAKE_CURRENT_BINARY_DIR}/build/MdtInstallCMakeModules_custom/MdtDeployUtils"
    --config $<CONFIG>
)
set_tests_properties(MdtInstallCMakeModules_custom_DeployUtils_Build PROPERTIES DEPENDS MdtInstallCMakeModules_custom_DeployUtils_Configure)

add_test(NAME MdtInstallCMakeModules_custom_DeployUtils_Install
  COMMAND "${CMAKE_COMMAND}"
    --install "${CMAKE_CURRENT_BINARY_DIR}/build/MdtInstallCMakeModules_custom/MdtDeployUtils"
    --config $<CONFIG>
)
set_tests_properties(MdtInstallCMakeModules_custom_DeployUtils_Install PROPERTIES DEPENDS MdtInstallCMakeModules_custom_DeployUtils_Build)


add_test(NAME MdtInstallCMakeModules_custom_user_Configure
  COMMAND "${CMAKE_COMMAND}"
    -S "${CMAKE_CURRENT_SOURCE_DIR}/MdtInstallCMakeModules_custom/user"
    -B "${CMAKE_CURRENT_BINARY_DIR}/build/MdtInstallCMakeModules_custom/user"
    -G "${CMAKE_GENERATOR}"
    -A "${CMAKE_GENERATOR_PLATFORM}"
    -T "${CMAKE_GENERATOR_TOOLSET}"
    -DCMAKE_MESSAGE_LOG_LEVEL=DEBUG
    "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtDeployUtils"
)
set_tests_properties(MdtInstallCMakeModules_custom_user_Configure PROPERTIES DEPENDS MdtInstallCMakeModules_custom_DeployUtils_Install)

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
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
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
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
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
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
      "-DTEST_ADDRESS_SANITIZER=ON"
      "-DCMAKE_BUILD_TYPE=Debug"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(BuildAndRun_HelloASan PROPERTIES DEPENDS Install_MdtCMakeModules)

# TODO: re-enable once docker-images for MSVC have AddressSanitizer installed
# In current CI, MSVC 16.10 is now installed,
# so the ASAN support is detected as available.
# The build fails, probably because the ASAN module is not installed.
# See:
# - https://gitlab.com/scandyna/mdt-cmake-modules/-/jobs/1456056553
# - https://docs.microsoft.com/en-us/cpp/sanitizers/asan?view=msvc-160
# - https://gitlab.com/scandyna/docker-images/-/issues/2
if(MSVC)
  set_tests_properties(BuildAndRun_HelloASan PROPERTIES DISABLED YES)
endif()

add_test(NAME BuildAndRun_HelloMSan
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/Sanitizers" "${CMAKE_CURRENT_BINARY_DIR}/buildHelloMSan"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
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
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
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
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
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
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MultiDevTools_static"
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

###########################################################################################
# GL Issue 8: mdt_install_library() produces error for target depending on a OBJECT target
###########################################################################################

add_test(NAME GlIssue08_InstallLibWithObject
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/GlIssue08_InstallLibWithObject" "${CMAKE_CURRENT_BINARY_DIR}/build/GlIssue08_InstallLibWithObject"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/GlIssue08_InstallLibWithObject"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(GlIssue08_InstallLibWithObject PROPERTIES DEPENDS Install_MdtCMakeModules)

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
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtHeaderOnly"
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
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtHeaderOnly"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtItemModel"
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
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtItemModel"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtItemEditor"
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
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtItemModel;${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtItemEditor"
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
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtItemModel;${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtItemEditor"
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
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtItemModel"
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
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MultiDevTools"
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
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MultiDevTools"
      "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/TableEditor_Mdt"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(BuildAndRun_TableEditor_Mdt PROPERTIES DEPENDS Install_MultiDevTools)


####################################
# Test installing in common location
####################################

# Build and install MdtCMakeModules

add_test(NAME Build_MdtCMakeModules_CL_opt
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/build/MdtCMakeModules_CL_opt"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_INSTALL_PREFIX=/opt"
)

add_test(NAME Install_MdtCMakeModules_CL_opt
  COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}/build/MdtCMakeModules_CL_opt" --target install --config $<CONFIG>
)

set_tests_properties(Install_MdtCMakeModules_CL_opt
  PROPERTIES
    DEPENDS Build_MdtCMakeModules_CL_opt
    ENVIRONMENT "DESTDIR=${CMAKE_CURRENT_BINARY_DIR}"
)

# gl_issue3: configure and install a INTERFACE library

add_test(NAME ConfigureAndTest_HeaderOnly_CL_opt
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/libs/HeaderOnly" "${CMAKE_CURRENT_BINARY_DIR}/build/HeaderOnly_CL_opt"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt"
      "-DCMAKE_INSTALL_PREFIX=/opt"
      "-DINSTALL_NAMESPACE_PACKAGE_CONFIG_FILES=ON"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(ConfigureAndTest_HeaderOnly_CL_opt PROPERTIES DEPENDS Install_MdtCMakeModules_CL_opt)

add_test(NAME Install_HeaderOnly_CL_opt
  COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}/build/HeaderOnly_CL_opt" --target install --config $<CONFIG>
)
set_tests_properties(Install_HeaderOnly_CL_opt
  PROPERTIES
    DEPENDS ConfigureAndTest_HeaderOnly_CL_opt
    ENVIRONMENT "DESTDIR=${CMAKE_CURRENT_BINARY_DIR}"
)

# Build + install MdtItemModel

add_test(NAME Build_MdtItemModel_CL_opt
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/libs/ItemModel" "${CMAKE_CURRENT_BINARY_DIR}/build/MdtItemModel_CL_opt"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt"
      "-DCMAKE_INSTALL_PREFIX=/opt"
      "-DBUILD_SHARED_LIBS=ON"
      "-DINSTALL_NAMESPACE_PACKAGE_CONFIG_FILES=OFF"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(Build_MdtItemModel_CL_opt PROPERTIES DEPENDS Install_HeaderOnly_CL_opt)

add_test(NAME Install_MdtItemModel_CL_opt
  COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}/build/MdtItemModel_CL_opt" --target install --config $<CONFIG>
)
set_tests_properties(Install_MdtItemModel_CL_opt
  PROPERTIES
    DEPENDS Build_MdtItemModel_CL_opt
    ENVIRONMENT "DESTDIR=${CMAKE_CURRENT_BINARY_DIR}"
)

# Build + install MdtItemEditor

add_test(NAME Build_MdtItemEditor_CL_opt
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/libs/ItemEditor" "${CMAKE_CURRENT_BINARY_DIR}/build/MdtItemEditor_CL_opt"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt"
      "-DCMAKE_INSTALL_PREFIX=/opt"
      "-DBUILD_SHARED_LIBS=ON"
      "-DINSTALL_NAMESPACE_PACKAGE_CONFIG_FILES=OFF"
    --test-command "${CMAKE_CTEST_COMMAND}"
)
set_tests_properties(Build_MdtItemEditor_CL_opt PROPERTIES DEPENDS Install_MdtItemModel_CL_opt)

add_test(NAME Install_MdtItemEditor_CL_opt
  COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}/build/MdtItemEditor_CL_opt" --target install --config $<CONFIG>
)
set_tests_properties(Install_MdtItemEditor_CL_opt
  PROPERTIES
    DEPENDS Build_MdtItemEditor_CL_opt
    ENVIRONMENT "DESTDIR=${CMAKE_CURRENT_BINARY_DIR}"
)


####################################
# Test installing in common location
#
# This set of tests will also check
# UNIX system wide installations
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

if(BUILD_REAL_INSTALL_TESTS)

  add_test(NAME Install_MdtCMakeModules_CL_usr_Real
    COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}/buildMdtCMakeModulesCL" --target install --config $<CONFIG>
  )

  set_tests_properties(Install_MdtCMakeModules_CL_usr_Real
    PROPERTIES
      DEPENDS Build_MdtCMakeModules_CL
  )

endif()

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

if(BUILD_REAL_INSTALL_TESTS)

  add_test(NAME Install_HeaderOnly_CL_usr_Real
    COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}/buildHeaderOnlyCL" --target install --config $<CONFIG>
  )

  set_tests_properties(Install_HeaderOnly_CL_usr_Real
    PROPERTIES
      DEPENDS ConfigureAndTest_HeaderOnly_CL
  )

endif()


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

if(BUILD_REAL_INSTALL_TESTS)

  add_test(NAME Install_MdtItemModel_CL_usr_Real
    COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemModelCL" --target install --config $<CONFIG>
  )

  set_tests_properties(Install_MdtItemModel_CL_usr_Real
    PROPERTIES
      DEPENDS Build_MdtItemModel_CL
  )

endif()

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

if(BUILD_REAL_INSTALL_TESTS)

  add_test(NAME Install_MdtItemEditor_CL_usr_Real
    COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}/buildMdtItemEditorCL" --target install --config $<CONFIG>
  )

  set_tests_properties(Install_MdtItemEditor_CL_usr_Real
    PROPERTIES
      DEPENDS Build_MdtItemEditor_CL
  )

endif()

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
    --test-command "${CMAKE_CTEST_COMMAND}" -V
)
set_tests_properties(BuildAndRun_TableEditor_CL PROPERTIES DEPENDS Install_MdtItemEditor_CL)

#########################################################################
# mdt_install_executable() test
#
# Use a simple executable that depends on ItemEditor test library.
# We not add other non std dependencies, like Qt.
# (installing required dependencies
#  is done by mdt_deploy_application() from MdtDeployUtils)
#
# A user project will then be build.
# This user project will use the above app as a CMake imported target.
# The user project also has a simple test
# that will run the app without any special environment.
#
# One goal ist to check that RPATH are set correctly for Unixes
# (note that RPATH will be empty on UNIX system wide install)
#
# A other goal is to check that the app is installed correctly and
# that the CMake package files are generated and installed correctly.
#
# To make the test run, also on Windows,
# we install the libraries and the app in a common prefix.
#
# Also check UNIX system wide install without RPATH
# (must be a real system wide install),
# but also non system wide install, with RPATH
#
# Steps:
# - Build the app
# - Install the app
# - Build and run the user project
#########################################################################

# Build and install TableEditor for /opt

add_test(NAME Build_TableEditor_CL_opt
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/TableEditor" "${CMAKE_CURRENT_BINARY_DIR}/build/TableEditor_CL_opt"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt"
      "-DCMAKE_INSTALL_PREFIX=/opt"
      "-DBUILD_SHARED_LIBS=ON"
)
set_tests_properties(Build_TableEditor_CL_opt PROPERTIES DEPENDS Install_MdtItemEditor_CL_opt)

add_test(NAME Install_TableEditor_CL_opt
  COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}/build/TableEditor_CL_opt" --target install --config $<CONFIG>
)
set_tests_properties(Install_TableEditor_CL_opt
  PROPERTIES
    DEPENDS Build_TableEditor_CL_opt
    ENVIRONMENT "DESTDIR=${CMAKE_CURRENT_BINARY_DIR}"
)

# Build and run the user project

add_test(NAME BuildAndRun_TableEditorUserProject_CL_opt
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/TableEditorUserProject" "${CMAKE_CURRENT_BINARY_DIR}/build/TableEditorUserProject_CL_opt"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/opt"
      "-DBUILD_SHARED_LIBS=ON"
    --test-command "${CMAKE_CTEST_COMMAND}" -V
)
set_tests_properties(BuildAndRun_TableEditorUserProject_CL_opt PROPERTIES DEPENDS Install_TableEditor_CL_opt)

# Build and install TableEditor for /usr

if(BUILD_REAL_INSTALL_TESTS)

  add_test(NAME Build_TableEditor_CL_usr
    COMMAND "${CMAKE_CTEST_COMMAND}"
      --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/TableEditor" "${CMAKE_CURRENT_BINARY_DIR}/build/TableEditor_CL_usr"
      --build-generator "${CMAKE_GENERATOR}"
      --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
      --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
      --build-config $<CONFIG>
      --build-options
        "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/usr"
        "-DCMAKE_INSTALL_PREFIX=/usr"
        "-DBUILD_SHARED_LIBS=ON"
  )
  set_tests_properties(Build_TableEditor_CL_usr PROPERTIES DEPENDS Install_MdtItemEditor_CL_usr_Real)

  add_test(NAME Install_TableEditor_CL_usr_Real
    COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}/build/TableEditor_CL_usr" --target install --config $<CONFIG>
  )
  set_tests_properties(Install_TableEditor_CL_usr_Real
    PROPERTIES
      DEPENDS Build_TableEditor_CL_usr
  )

  # Build and run the user project

  add_test(NAME BuildAndRun_TableEditorUserProject_CL_usr_Real
    COMMAND "${CMAKE_CTEST_COMMAND}"
      --build-and-test "${CMAKE_SOURCE_DIR}/tests/apps/TableEditorUserProject" "${CMAKE_CURRENT_BINARY_DIR}/build/TableEditorUserProject_CL_usr"
      --build-generator "${CMAKE_GENERATOR}"
      --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
      --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
      --build-config $<CONFIG>
      --build-options
        "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/usr"
        "-DBUILD_SHARED_LIBS=ON"
      --test-command "${CMAKE_CTEST_COMMAND}" -V
  )
  set_tests_properties(BuildAndRun_TableEditorUserProject_CL_usr_Real PROPERTIES DEPENDS Install_TableEditor_CL_usr_Real)

endif()

################################################################################
# GL issue 12
# Get the path to a target file that also works with Conan CMakeDeps generator
# https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/12
#
# Here we check with classic install, that works with $<TARGET_FILE:Mdt0::LibA>
################################################################################

add_test(NAME GlIssue12_TargetFilePath_libA_Configure
  COMMAND "${CMAKE_COMMAND}"
    -S "${CMAKE_CURRENT_SOURCE_DIR}/GlIssue12_TargetFilePath/libA"
    -B "${CMAKE_CURRENT_BINARY_DIR}/build/GlIssue12_TargetFilePath/libA"
    -G "${CMAKE_GENERATOR}"
    -A "${CMAKE_GENERATOR_PLATFORM}"
    -T "${CMAKE_GENERATOR_TOOLSET}"
    -DCMAKE_BUILD_TYPE=$<CONFIG>
    -DCMAKE_MESSAGE_LOG_LEVEL=DEBUG
    "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules"
    "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/GlIssue12_TargetFilePath/libA"
)
set_tests_properties(GlIssue12_TargetFilePath_libA_Configure PROPERTIES DEPENDS Install_MdtCMakeModules)

add_test(NAME GlIssue12_TargetFilePath_libA_Build
  COMMAND "${CMAKE_COMMAND}"
    --build "${CMAKE_CURRENT_BINARY_DIR}/build/GlIssue12_TargetFilePath/libA"
    --config $<CONFIG>
)
set_tests_properties(GlIssue12_TargetFilePath_libA_Build PROPERTIES DEPENDS GlIssue12_TargetFilePath_libA_Configure)

add_test(NAME GlIssue12_TargetFilePath_libA_Install
  COMMAND "${CMAKE_COMMAND}"
    --install "${CMAKE_CURRENT_BINARY_DIR}/build/GlIssue12_TargetFilePath/libA"
    --config $<CONFIG>
)
set_tests_properties(GlIssue12_TargetFilePath_libA_Install PROPERTIES DEPENDS GlIssue12_TargetFilePath_libA_Build)


add_test(NAME GlIssue12_TargetFilePath_app_BuildAndRun
  COMMAND "${CMAKE_CTEST_COMMAND}"
    --build-and-test "${CMAKE_CURRENT_SOURCE_DIR}/GlIssue12_TargetFilePath/app" "${CMAKE_CURRENT_BINARY_DIR}/build/GlIssue12_TargetFilePath/app"
    --build-generator "${CMAKE_GENERATOR}"
    --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
    --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
    --build-config $<CONFIG>
    --build-options
      "-DCMAKE_MESSAGE_LOG_LEVEL=DEBUG"
      "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}/myHome/opt/MdtCMakeModules;${CMAKE_CURRENT_BINARY_DIR}/GlIssue12_TargetFilePath/libA"
    --test-command "${CMAKE_CTEST_COMMAND}" -V
)
set_tests_properties(GlIssue12_TargetFilePath_app_BuildAndRun PROPERTIES DEPENDS GlIssue12_TargetFilePath_libA_Install)


####################################
# Test installing with Conan
####################################

if(BUILD_CONAN_TESTS)

  include(conan.cmake)
  conan_cmake_settings(conanSettings)

  # Build and install MdtCMakeModules into the local cache
  add_test(NAME Conan_Create_MdtCMakeModules
    COMMAND "${CONAN_COMMAND}"
      create "${CMAKE_SOURCE_DIR}/packaging/conan" "0.2@MdtCMakeModules_tests/testing"
      ${conanSettings}
  )
  # Using the CMakeToolchain conan generator (see project's conanfile.py),
  # the CMAKE_C_COMPILER and CMAKE_CXX_COMPILER are not set in the conan_toolchain.cmake
  # So, we have to specify them here
  # See:
  #  https://github.com/conan-io/conan/issues/9962
  #  https://github.com/conan-io/conan/issues/8122
  mdt_append_test_environment_variables_string(Conan_Create_MdtCMakeModules
    "CONAN_CMAKE_GENERATOR=${CMAKE_GENERATOR};CC=${CMAKE_C_COMPILER};CXX=${CMAKE_CXX_COMPILER}"
  )

  # Build and install MdtHeaderOnly
  add_test(NAME Conan_Create_MdtHeaderOnly
    COMMAND "${CONAN_COMMAND}"
      create "${CMAKE_CURRENT_SOURCE_DIR}/libs/HeaderOnly" "0.1@MdtCMakeModules_tests/testing"
      ${conanSettings}
  )
  set_tests_properties(Conan_Create_MdtHeaderOnly PROPERTIES DEPENDS Conan_Create_MdtCMakeModules)
  mdt_append_test_environment_variables_string(Conan_Create_MdtHeaderOnly "CONAN_CMAKE_GENERATOR=${CMAKE_GENERATOR};CONAN_PRINT_RUN_COMMANDS=1")

  # Build and install MdtItemModel
  add_test(NAME Conan_Create_MdtItemModel
    COMMAND "${CONAN_COMMAND}"
      create "${CMAKE_CURRENT_SOURCE_DIR}/libs/ItemModel" "0.1@MdtCMakeModules_tests/testing"
      ${conanSettings}
  )
  set_tests_properties(Conan_Create_MdtItemModel PROPERTIES DEPENDS Conan_Create_MdtHeaderOnly)
  mdt_append_test_environment_variables_string(Conan_Create_MdtItemModel "CONAN_CMAKE_GENERATOR=${CMAKE_GENERATOR}")

  # Build and install MdtItemEditor
  add_test(NAME Conan_Create_MdtItemEditor
    COMMAND "${CONAN_COMMAND}"
      create "${CMAKE_CURRENT_SOURCE_DIR}/libs/ItemEditor" "0.1@MdtCMakeModules_tests/testing"
      ${conanSettings}
  )
  set_tests_properties(Conan_Create_MdtItemEditor PROPERTIES DEPENDS Conan_Create_MdtItemModel)
  mdt_append_test_environment_variables_string(Conan_Create_MdtItemEditor "CONAN_CMAKE_GENERATOR=${CMAKE_GENERATOR}")

  # Build TableEditor with Conan + run the app
  add_test(NAME Conan_Install_TableEditor_dependecies
    COMMAND "${CONAN_COMMAND}"
      install "${CMAKE_CURRENT_SOURCE_DIR}/apps/TableEditor"
      --generator cmake_paths
      --install-folder "${CMAKE_CURRENT_BINARY_DIR}/conanBuildTableEditor"
      --options *:shared=True
      ${conanSettings}
  )
  set_tests_properties(Conan_Install_TableEditor_dependecies
    PROPERTIES DEPENDS Conan_Create_MdtItemEditor)

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

  # Build and run a simple executable
  # This project uses Conan CMakeDeps generator
  # Goal is to check mdt_set_test_library_env_path()
  # See https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/7
  #
  # As above tests, we don't want to depend on Qt here,
  # otherwise  we would have to describe a Qt dependency
  # with some version in the test's conanfile,
  # and building Qt with conan is currently problematic (2.06.2022)

  add_test(NAME Conan_Install_TableEditor_CMakeDeps_GlIssue07_dependencies
    COMMAND "${CONAN_COMMAND}"
      install "${CMAKE_CURRENT_SOURCE_DIR}/GlIssue07_TestEnvPath/TableEditor_Conan_CMakeDeps"
      --install-folder "${CMAKE_CURRENT_BINARY_DIR}/build/GlIssue07_TestEnvPath/TableEditor_Conan_CMakeDeps"
      --options *:shared=True
      ${conanSettings}
  )
  set_tests_properties(Conan_Install_TableEditor_CMakeDeps_GlIssue07_dependencies PROPERTIES DEPENDS Conan_Create_MdtItemEditor)

  add_test(NAME Conan_BuildAndRun_TableEditor_CMakeDeps_GlIssue07
    COMMAND "${CMAKE_CTEST_COMMAND}"
      --build-and-test "${CMAKE_SOURCE_DIR}/tests/GlIssue07_TestEnvPath/TableEditor_Conan_CMakeDeps" "${CMAKE_CURRENT_BINARY_DIR}/build/GlIssue07_TestEnvPath/TableEditor_Conan_CMakeDeps"
      --build-generator "${CMAKE_GENERATOR}"
      --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
      --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
      --build-config $<CONFIG>
      --build-options
        "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_BINARY_DIR}/build/GlIssue07_TestEnvPath/TableEditor_Conan_CMakeDeps/conan_toolchain.cmake"
      --test-command "${CMAKE_CTEST_COMMAND}" --output-on-failure
      ${conanSettings}

  )
  set_tests_properties(Conan_BuildAndRun_TableEditor_CMakeDeps_GlIssue07 PROPERTIES DEPENDS Conan_Install_TableEditor_CMakeDeps_GlIssue07_dependencies)
  # See remarks for Conan_Create_MdtCMakeModules
  mdt_append_test_environment_variables_string(Conan_BuildAndRun_TableEditor_CMakeDeps_GlIssue07
    "CONAN_CMAKE_GENERATOR=${CMAKE_GENERATOR};CC=${CMAKE_C_COMPILER};CXX=${CMAKE_CXX_COMPILER}"
  )

  ###################################################################################
  # GL issue 12
  # Get the path to a target file that also works with Conan CMakeDeps generator
  # https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/12
  #
  # Here we install libA with conan
  # Then, app, wich uses CMakeDeps generator, will use Conan generated package files
  ###################################################################################

  add_test(NAME GlIssue12_TargetFilePath_libA_Conan_Create
    COMMAND "${CONAN_COMMAND}"
      create "${CMAKE_CURRENT_SOURCE_DIR}/GlIssue12_TargetFilePath/libA" "0.0.0@MdtCMakeModules_tests/testing"
      ${conanSettings}
  )
  set_tests_properties(GlIssue12_TargetFilePath_libA_Conan_Create PROPERTIES DEPENDS Conan_Create_MdtCMakeModules)
  mdt_append_test_environment_variables_string(GlIssue12_TargetFilePath_libA_Conan_Create
    "CONAN_CMAKE_GENERATOR=${CMAKE_GENERATOR};CC=${CMAKE_C_COMPILER};CXX=${CMAKE_CXX_COMPILER}"
  )

  add_test(NAME GlIssue12_TargetFilePath_app_Conan_Install
    COMMAND "${CONAN_COMMAND}"
      install "${CMAKE_CURRENT_SOURCE_DIR}/GlIssue12_TargetFilePath/app"
      --install-folder "${CMAKE_CURRENT_BINARY_DIR}/build/GlIssue12_TargetFilePath/app_conan"
      --options *:shared=True
      ${conanSettings}
  )
  set_tests_properties(GlIssue12_TargetFilePath_app_Conan_Install PROPERTIES DEPENDS GlIssue12_TargetFilePath_libA_Conan_Create)

  add_test(NAME GlIssue12_TargetFilePath_app_Conan_BuildAndRun
    COMMAND "${CMAKE_CTEST_COMMAND}"
      --build-and-test "${CMAKE_CURRENT_SOURCE_DIR}/GlIssue12_TargetFilePath/app" "${CMAKE_CURRENT_BINARY_DIR}/build/GlIssue12_TargetFilePath/app_conan"
      --build-generator "${CMAKE_GENERATOR}"
      --build-generator-platform "${CMAKE_GENERATOR_PLATFORM}"
      --build-generator-toolset "${CMAKE_GENERATOR_TOOLSET}"
      --build-config $<CONFIG>
      --build-options
        "-DCMAKE_MESSAGE_LOG_LEVEL=DEBUG"
        "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_BINARY_DIR}/build/GlIssue12_TargetFilePath/app_conan/conan_toolchain.cmake"
      --test-command "${CMAKE_CTEST_COMMAND}" -V
  )
  set_tests_properties(GlIssue12_TargetFilePath_app_Conan_BuildAndRun PROPERTIES DEPENDS GlIssue12_TargetFilePath_app_Conan_Install)
  # See remarks for Conan_Create_MdtCMakeModules
  mdt_append_test_environment_variables_string(GlIssue12_TargetFilePath_app_Conan_BuildAndRun
    "CONAN_CMAKE_GENERATOR=${CMAKE_GENERATOR};CC=${CMAKE_C_COMPILER};CXX=${CMAKE_CXX_COMPILER}"
  )

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
