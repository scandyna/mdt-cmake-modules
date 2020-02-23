# include(GenerateExportHeader)
include(MdtAddLibrary)
include(MdtInstallLibrary)

add_library(Mdt_HeaderOnly INTERFACE)

add_library(Mdt::HeaderOnly ALIAS Mdt_HeaderOnly)

# generate_export_header(Mdt_HeaderOnly)

target_include_directories(Mdt_HeaderOnly
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

mdt_install_interface_library(
  TARGET Mdt_HeaderOnly
  LIBRARY_DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES_DIRECTORY .
  INCLUDES_FILE_WITHOUT_EXTENSION
#   ADDITIONAL_INCLUDES_FILES "${CMAKE_CURRENT_BINARY_DIR}/mdt_itemmodel_export.h"
  INCLUDES_DESTINATION ${MDT_INSTALL_INCLUDEDIR}
  EXPORT_NAME HeaderOnly
  EXPORT_NAMESPACE Mdt0::
  INSTALL_NAMESPACE ${MDT_INSTALL_PACKAGE_NAME}
  FIND_PACKAGE_PATHS ..
  VERSION ${PROJECT_VERSION}
  VERSION_COMPATIBILITY ExactVersion
  DEVELOPMENT_COMPONENT Mdt_HeaderOnly_Dev
)
