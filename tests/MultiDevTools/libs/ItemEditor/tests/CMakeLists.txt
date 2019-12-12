include(MdtAddTest)

mdt_add_test(
  NAME SortSetupWidgetTest
  TARGET sortSetupWidgetTest
  DEPENDENCIES Mdt::ItemEditor
  SOURCE_FILES
    src/SortSetupWidgetTest.cpp
)
