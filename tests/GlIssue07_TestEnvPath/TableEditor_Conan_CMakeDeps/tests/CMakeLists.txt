include(MdtRuntimeEnvironment)

add_test(
  NAME RunTableEditor
  COMMAND tableEditor
)

mdt_set_test_library_env_path(NAME RunTableEditor TARGET tableEditor)

get_test_property(RunTableEditor ENVIRONMENT envPath)
message(DEBUG "RunTableEditor ENVIRONMENT: ${envPath}")
