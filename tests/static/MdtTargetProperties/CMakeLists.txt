# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.15)

project(MdtTargetPropertiesStaticTests LANGUAGES CXX)

include(MdtTargetProperties)

##########################################
# mdt_is_conan_runtime_target_genex()
##########################################

message(VERBOSE "TEST mdt_is_conan_runtime_target_genex(): ITEM: fake")

mdt_is_conan_runtime_target_genex(isConanRuntimeTargetGenex ITEM fake)
if(${isConanRuntimeTargetGenex})
  message(FATAL_ERROR "Test failed: 'fake' is not a Conan runtime target")
endif()


message(VERBOSE "TEST mdt_is_conan_runtime_target_genex(): ITEM: $<$<CONFIG:Debug>:>")

mdt_is_conan_runtime_target_genex(isConanRuntimeTargetGenex ITEM $<$<CONFIG:Debug>:>)
if(${isConanRuntimeTargetGenex})
  message(FATAL_ERROR "Test failed: '$<$<CONFIG:Debug>:>' is not a Conan runtime target")
endif()


message(VERBOSE "TEST mdt_is_conan_runtime_target_genex(): ITEM: $<$<CONFIG:Debug>:CONAN_LIB::qt_Qt5_Core_Qt5Core_DEBUG>")

mdt_is_conan_runtime_target_genex(isConanRuntimeTargetGenex ITEM $<$<CONFIG:Debug>:CONAN_LIB::qt_Qt5_Core_Qt5Core_DEBUG>)
if(NOT ${isConanRuntimeTargetGenex})
  message(FATAL_ERROR "Test failed: '$<$<CONFIG:Debug>:CONAN_LIB::qt_Qt5_Core_Qt5Core_DEBUG>' is a Conan runtime target")
endif()


message(VERBOSE "TEST mdt_is_conan_runtime_target_genex(): ITEM: $<$<CONFIG:Release>:CONAN_LIB::qt_Qt5_Core_Qt5Core_RELEASE>")

mdt_is_conan_runtime_target_genex(isConanRuntimeTargetGenex ITEM $<$<CONFIG:Release>:CONAN_LIB::qt_Qt5_Core_Qt5Core_RELEASE>)
if(NOT ${isConanRuntimeTargetGenex})
  message(FATAL_ERROR "Test failed: '$<$<CONFIG:Release>:CONAN_LIB::qt_Qt5_Core_Qt5Core_RELEASE>' is a Conan runtime target")
endif()


message(VERBOSE "TEST mdt_is_conan_runtime_target_genex(): all static tests passed")
