include(MdtAddTest)

mdt_add_test(
  NAME CoreTest
  TARGET coreTest
  DEPENDENCIES Core TestLib Mdt0::ItemModel
  SOURCE_FILES
    src/CoreTest.cpp
)
