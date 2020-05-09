include(MdtAddTest)

mdt_add_test(
  NAME TableEditorHelpersTest
  TARGET tableEditorHelpersTest
  DEPENDENCIES tableEditorHelpers
  SOURCE_FILES
    src/TableEditorHelpersTest.cpp
)
