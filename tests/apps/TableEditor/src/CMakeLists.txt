include(MdtInstallExecutable)

add_executable(tableEditor
  main.cpp
)

target_link_libraries(tableEditor
  PRIVATE
    Mdt0::ItemEditor
)

mdt_install_executable(
  TARGET tableEditor
  RUNTIME_DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY_DESTINATION ${CMAKE_INSTALL_LIBDIR}
  EXPORT_NAME TableEditorExecutable
  EXPORT_NAMESPACE Mdt0
  INSTALL_IS_UNIX_SYSTEM_WIDE ${MDT_INSTALL_IS_UNIX_SYSTEM_WIDE}
  RUNTIME_COMPONENT ${PROJECT_NAME}_Runtime
  DEVELOPMENT_COMPONENT ${PROJECT_NAME}_Devel
)
