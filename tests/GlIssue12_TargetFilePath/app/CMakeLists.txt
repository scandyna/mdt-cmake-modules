
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

# get_target_property(targetType Mdt0::LibA TYPE)
# message("******* Mdt0::LibA target type: ${targetType}")
# 
# get_target_property(linkDependencies Mdt0::LibA LINK_LIBRARIES)
# message("******* Mdt0::LibA LINK_LIBRARIES: ${linkDependencies}")
# 
# get_target_property(interfaceLinkDependencies Mdt0::LibA INTERFACE_LINK_LIBRARIES)
# message("******* Mdt0::LibA INTERFACE_LINK_LIBRARIES: ${interfaceLinkDependencies}")

# TODO: how to extract the
#
# we could maybe assume that

# TODO: see conan generated targets:
#     set_property(TARGET Mdt0::LibA
#                  PROPERTY INTERFACE_LINK_LIBRARIES
#                  $<$<CONFIG:Debug>:${GlIssue12_TargetFilePath_libA_OBJECTS_DEBUG}>
#                  $<$<CONFIG:Debug>:${GlIssue12_TargetFilePath_libA_LIBRARIES_TARGETS}>
#                  APPEND)
#
# We could assume that the second dependency in INTERFACE_LINK_LIBRARIES is the library:
#   $<$<CONFIG:Debug>:${GlIssue12_TargetFilePath_libA_LIBRARIES_TARGETS}
#
# Also, the "second dependnecy" would be something like CONAN_LIB::xxxx

# foreach(dep ${interfaceLinkDependencies})
#   message("***** dep: ${dep}")
# endforeach()

# set(genexSandbox "$<TARGET_EXISTS:$<TARGET_PROPERTY:Mdt0::LibA,INTERFACE_LINK_LIBRARIES>>")

# set(debugTargetGenex   $<$<CONFIG:Debug>:CONAN_LIB::GlIssue12_TargetFilePath_libA_Mdt0LibA_DEBUG>)
# set(releaseTargetGenex $<$<CONFIG:Release>:CONAN_LIB::GlIssue12_TargetFilePath_libA_Mdt0LibA_RELEASE>)
# set(targetGenex ${debugTargetGenex}${releaseTargetGenex})
# set(targetFileGenex $<TARGET_FILE:${targetGenex}>)

# add_custom_target(printGenxSandbox ALL
#   COMMAND ${CMAKE_COMMAND} -E echo "++++++++ targetFileGenex: ${targetFileGenex}"
# )

# target_compile_definitions(app PRIVATE MDT0_LIBA_FILE_PATH="${targetFileGenex}")

# list(GET interfaceLinkDependencies 1 mdt0ConanLibA)
# message("******* mdt0ConanLibA: ${mdt0ConanLibA}")
# 
# message("******* GENEX_EVAL ${mdt0ConanLibA}: $<GENEX_EVAL:${mdt0ConanLibA}>")
# 
# add_custom_target(printMdt0ConanLibA ALL
#   COMMAND ${CMAKE_COMMAND} -E echo "++++++++ printMdt0ConanLibA: ${mdt0ConanLibA}"
# )
# 
# add_custom_target(printMdt0ConanLibAFile ALL
#   COMMAND ${CMAKE_COMMAND} -E echo "++++++++ printMdt0ConanLibAFile: $<TARGET_FILE:${mdt0ConanLibA}>"
# )


# get_target_property(conanTargetType CONAN_LIB::GlIssue12_TargetFilePath_libA_Mdt0LibA_DEBUG TYPE)
# message("******* CONAN_LIB::GlIssue12_TargetFilePath_libA_Mdt0LibA_DEBUG target type: ${conanTargetType}")
# 
# get_target_property(interfaceLinkDependencies CONAN_LIB::GlIssue12_TargetFilePath_libA_Mdt0LibA_DEBUG INTERFACE_LINK_LIBRARIES)
# message("******* CONAN_LIB::GlIssue12_TargetFilePath_libA_Mdt0LibA_DEBUG INTERFACE_LINK_LIBRARIES: ${interfaceLinkDependencies}")
# 
# # add_custom_target(printConanTarget ALL
# #   COMMAND ${CMAKE_COMMAND} -E echo "++++++++ $<TARGET_FILE:CONAN_LIB::GlIssue12_TargetFilePath_libA_Mdt0LibA_DEBUG>"
# # )
# 
# get_target_property(conanTargetType GlIssue12_TargetFilePath_libA_DEPS_TARGET TYPE)
# message("******* GlIssue12_TargetFilePath_libA_DEPS_TARGET target type: ${conanTargetType}")
# 
# get_target_property(interfaceLinkDependencies GlIssue12_TargetFilePath_libA_DEPS_TARGET INTERFACE_LINK_LIBRARIES)
# message("******* GlIssue12_TargetFilePath_libA_DEPS_TARGET INTERFACE_LINK_LIBRARIES: ${interfaceLinkDependencies}")


# get_target_property(targetType ${interfaceLinkDependencies} TYPE)
# message("******* ${interfaceLinkDependencies} target type: ${interfaceLinkDependencies}")


# target_compile_definitions(app PRIVATE MDT0_LIBA_FILE_PATH="$<TARGET_FILE:Mdt0::LibA>")



