include(MdtAddTest)

mdt_add_test(
  NAME CoreTest
  TARGET coreTest
  DEPENDENCIES Core TestLib
  SOURCE_FILES
    src/CoreTest.cpp
)
