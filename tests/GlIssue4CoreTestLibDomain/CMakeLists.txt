
cmake_minimum_required(VERSION 3.10)

project(GlIssue4CoreTestLibDomain)

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)
find_package(Mdt0 0.0.1 COMPONENTS ItemModel REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

enable_testing()

add_subdirectory(libs/Core)
add_subdirectory(libs/Domain)
add_subdirectory(libs/TestLib)


# set_property(GLOBAL APPEND PROPERTY MDT_TESTS SomeTestA SomeTestB)

include(MdtAddTest)

mdt_add_test(
  NAME FromMainTest
  TARGET fromMainTest
  DEPENDENCIES Core TestLib
  SOURCE_FILES
    libs/Core/tests/src/CoreTest.cpp
)



get_property(tests GLOBAL PROPERTY MDT_TESTS)

message("tests: ${tests}")

foreach(test ${tests})
  if(NOT TEST ${test})
    message("${test} is not a test")
  endif()
#   get_property(testTarget TEST ${test} PROPERTY TEST_TARGET)
  get_test_property(${test} TEST_TARGET testTarget)
  get_test_property(${test} ENVIRONMENT testEnv)
  message("test: ${test}, target: ${testTarget}, env: ${testEnv}")
  
#   set_tests_properties(${test} PROPERTIES SOME_OTHER_PROP "Yet a other prop")
  
endforeach()


get_property(testTargets GLOBAL PROPERTY MDT_TEST_TARGETS)

message("test targets: ${testTargets}")

foreach(testTarget ${testTargets})
  if(TARGET ${testTarget})
    message("target: ${testTarget} is a target :)")
  else()
    message("target: ${testTarget} is NOT a target :(")
  endif()
endforeach()



# mdt_set_test_properties(TEST test PROPERTIES prop1 value1 prop2 value2)

# set_property(DIRECTORY "/home/philippe/dev/mdt-cmake-modules/tests/GlIssue4CoreTestLibDomain/libs/Core/tests/"
#   APPEND PROPERTY TEST_INCLUDE_FILES "/home/philippe/dev/build/mdt-cmake-modules/tests/buildGlIssue4CoreTestLibDomain/libs/Core/tests/customTestManip.cmake")

# process tests for current directory
# get subdirectories
# for each subdirectory, process tests for this directory
# get subdirectories
# for each subdirectory, process tests for this directory

# mdt_set_directory_tests_properties()

# get_cmake_property(comp_list COMPONENTS)
# message("comp_list: ${comp_list}")

# get_cmake_property(dirs SUBDIRECTORIES)
# get_property(dirs DIRECTORY . PROPERTY SUBDIRECTORIES)
# message("dirs: ${dirs}")
# foreach(dir ${dirs})
#   get_property(subdirs DIRECTORY "${dir}" PROPERTY SUBDIRECTORIES)
#   message("dir subdirs: ${subdirs}")
# endforeach()

# get_property(allTargets DIRECTORY "${PROJECT_SOURCE_DIR}/libs/Core/src" PROPERTY BUILDSYSTEM_TARGETS)
# message("Targets: ${allTargets}")
# message("Tests: ${allTests}")
