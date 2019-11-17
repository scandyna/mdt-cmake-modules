
include(GenerateExportHeader)
include(MdtInstallLibrary)

add_library(Mdt_ItemModel
  Mdt/ItemModel/SortProxyModel.cpp
)

generate_export_header(Mdt_ItemModel)

target_include_directories(Mdt_ItemModel
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)
