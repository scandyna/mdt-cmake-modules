
add_executable(sortSetupWidgetTest
  src/SortSetupWidgetTest.cpp
)

target_link_libraries(sortSetupWidgetTest
  PRIVATE
    Mdt::ItemEditor
)

add_test(
  NAME SortSetupWidgetTest
  COMMAND sortSetupWidgetTest
)

