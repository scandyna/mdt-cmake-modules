
add_executable(tableEditor
  main.cpp
)

target_link_libraries(tableEditor
  PRIVATE
    Mdt0::ItemEditor
)

