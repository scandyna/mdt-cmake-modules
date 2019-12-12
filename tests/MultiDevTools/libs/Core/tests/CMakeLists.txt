
add_executable(algorithmTest
  src/AlgorithmTest.cpp
)

target_link_libraries(sortProxyModelTest
  PRIVATE
    Mdt::ItemModel
)

add_test(
  NAME AlgorithmTest
  COMMAND algorithmTest
)
