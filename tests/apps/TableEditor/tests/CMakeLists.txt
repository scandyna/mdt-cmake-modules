
add_test(
  NAME RunTableEditor
  COMMAND tableEditor
)

get_target_property(linkLibraries tableEditor LINK_LIBRARIES)
get_target_property(interfaceLinkLibraries tableEditor INTERFACE_LINK_LIBRARIES)

message("** tableEditor LINK_LIBRARIES: ${linkLibraries}")
message("** tableEditor INTERFACE_LINK_LIBRARIES: ${interfaceLinkLibraries}")

get_target_property(itemEditorInterfaceLinkLibraries Mdt0::ItemEditor INTERFACE_LINK_LIBRARIES)
message("** ItemEditor INTERFACE_LINK_LIBRARIES: ${itemEditorInterfaceLinkLibraries}")

include(MdtInstallLibrary)

set(runTableEditorEvironment)
mdt_target_libraries_to_library_env_path(runTableEditorEvironment TARGET tableEditor)
message("** runTableEditorEvironment: ${runTableEditorEvironment}")


set_tests_properties(RunTableEditor PROPERTIES ENVIRONMENT "${runTableEditorEvironment}")

# set(ENV{LD_LIBRARY_PATH} "/tmp")
# set_tests_properties(RunTableEditor PROPERTIES ENVIRONMENT "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:$ENV{LD_LIBRARY_PATH}")

# TODO check with aexe witout any depenencies
