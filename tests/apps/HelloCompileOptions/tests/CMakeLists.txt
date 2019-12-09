include(MdtRuntimeEnvironment)

add_test(
  NAME RunHelloCompileOptions
  COMMAND helloCompileOptions
)

mdt_set_test_library_env_path(NAME RunHelloCompileOptions TARGET helloCompileOptions)
