
add_executable(sortProxyModelTest
  src/SortProxyModelTest.cpp
)

target_link_libraries(sortProxyModelTest
  PRIVATE
    Mdt::ItemModel
)

add_test(
  NAME SortProxyModelTest
  COMMAND sortProxyModelTest
)
