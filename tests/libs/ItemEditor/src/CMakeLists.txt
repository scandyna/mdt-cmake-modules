
include(GenerateExportHeader)
include(MdtInstallMdtLibrary)

add_library(Mdt_ItemEditor
  Mdt/ItemEditor/SortSetupWidget.cpp
)

add_library(Mdt::ItemEditor ALIAS Mdt_ItemEditor)

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

set_target_properties(Mdt_ItemEditor
  PROPERTIES
    LIBRARY_NAME ItemEditor
)

mdt_install_mdt_library(
  TARGET Mdt_ItemEditor
  VERSION_COMPATIBILITY ExactVersion
)
