
include(MdtRuntimeEnvironment)

add_test(
  NAME RunTableEditor
  COMMAND tableEditor
)
mdt_set_test_library_env_path(NAME RunTableEditor TARGET tableEditor)

# get_test_property(RunTableEditor ENVIRONMENT envPath)
# message("RunTableEditor ENVIRONMENT: ${envPath}")


# add_test(NAME printEnv COMMAND ${CMAKE_COMMAND} -E environment)
# mdt_set_test_library_env_path(NAME printEnv TARGET tableEditor)

set(envPath)
mdt_target_libraries_to_library_env_path(envPath TARGET tableEditor)
if(WIN32)
  string(REPLACE ";" "\\;" envPath "${envPath}")
endif()

add_custom_target(
  runTableEditor_ENV_TGT ALL
  COMMAND "${CMAKE_COMMAND}" -E env ${envPath} $<TARGET_FILE:tableEditor>
  COMMENT "Run runTableEditor_ENV_TGT"
)
add_dependencies(runTableEditor_ENV_TGT tableEditor)

add_test(
  NAME RunTableEditor_ENV
  COMMAND "${CMAKE_COMMAND}" -E env ${envPath} $<TARGET_FILE:tableEditor>
)
