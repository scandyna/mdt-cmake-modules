
cmake_minimum_required(VERSION 3.15)
project(GlIssue12_TargetFilePath_app VERSION 0.0.0)

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)
find_package(Mdt0 REQUIRED COMPONENTS LibA NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

include(MdtTargetProperties)

enable_testing()

include(MdtAddTest)

mdt_add_test(
  NAME Run_app
  TARGET app
  SOURCE_FILES
    main.cpp
)

mdt_target_file_genex(targetFileGenex TARGET Mdt0::LibA)

message("***** targetFileGenex GENEX: ${targetFileGenex}")

add_custom_target(printGenxSandbox ALL
  COMMAND ${CMAKE_COMMAND} -E echo "+++++ targetFileGenex: ${targetFileGenex}"
)

target_compile_definitions(app PRIVATE MDT0_LIBA_FILE_PATH="${targetFileGenex}")
