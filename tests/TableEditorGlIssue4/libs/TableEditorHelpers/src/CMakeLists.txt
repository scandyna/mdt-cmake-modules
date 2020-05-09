include(GenerateExportHeader)

add_library(tableEditorHelpers
  TableEditorHelpers.cpp
)

generate_export_header(tableEditorHelpers)

target_include_directories(tableEditorHelpers
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

target_link_libraries(tableEditorHelpers
  PUBLIC Mdt0::ItemEditor
)
