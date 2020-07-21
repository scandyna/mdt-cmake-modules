include(GenerateExportHeader)

add_library(TestLib
  TestLib.cpp
)

generate_export_header(TestLib)

target_include_directories(TestLib
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

target_link_libraries(TestLib PUBLIC Domain)
