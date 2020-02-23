
add_executable(algorithmTest
  src/AlgorithmTest.cpp
)

target_link_libraries(algorithmTest
  PRIVATE
    Mdt::HeaderOnly
)

add_test(
  NAME AlgorithmTest
  COMMAND algorithmTest
)
