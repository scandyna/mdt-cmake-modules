
add_test(
  NAME RunSanitizersHello
  COMMAND sanitizersHello
)

if(TEST_ADDRESS_SANITIZER AND SANITIZER_ENABLE_ADDRESS)
  mdt_set_test_asan_options(
    NAME RunSanitizersHello
    OPTIONS verbosity=1 malloc_context_size=20
  )
endif()

if(TEST_THREAD_SANITIZER AND SANITIZER_ENABLE_THREAD)
  mdt_set_test_tsan_options(
    NAME RunSanitizersHello
    OPTIONS ignore_noninstrumented_modules=true verbosity=1
  )
endif()
