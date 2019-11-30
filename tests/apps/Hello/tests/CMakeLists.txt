include(MdtInstallLibrary)

add_test(
  NAME RunHello
  COMMAND hello
)

# Check that setting library environment for a test without dependencies does not produce a error
mdt_set_test_library_env_path(NAME RunHello TARGET hello)

# get_test_property(RunHello ENVIRONMENT envPath)
# message("RunHello ENVIRONMENT: ${envPath}")
