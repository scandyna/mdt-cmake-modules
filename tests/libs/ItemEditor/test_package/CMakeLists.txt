
# GL-25 - See conanfile.py for more details

cmake_minimum_required(VERSION 3.22)
project(MdtItemEditorTest)

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)
find_package(Mdt0 0.0.1 COMPONENTS ItemEditor REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

enable_testing()

include(MdtAddTest)

mdt_add_test(
  NAME BuildAndRun_ItemEditorExecutable
  TARGET itemEditorExecutable
  DEPENDENCIES Mdt0::ItemEditor
  SOURCE_FILES
    main.cpp
)
