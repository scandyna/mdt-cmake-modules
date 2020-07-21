include(GenerateExportHeader)

add_library(Domain
  Domain.cpp
)

generate_export_header(Domain)

target_include_directories(Domain
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

target_link_libraries(Domain PUBLIC Mdt0::ItemModel)
