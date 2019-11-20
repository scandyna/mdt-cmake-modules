
include(GenerateExportHeader)
include(MdtInstallLibrary)

add_library(Mdt_ItemEditor
  Mdt/ItemEditor/SortSetupWidget.cpp
)

target_link_libraries(Mdt_ItemEditor
  PUBLIC
    Mdt0::ItemModel
)

generate_export_header(Mdt_ItemEditor)

target_include_directories(Mdt_ItemEditor
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

# TODO use mdt_install_mdt_library()
