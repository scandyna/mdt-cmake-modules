#include <Mdt/ItemEditor/SortSetupWidget>
#include <Mdt/ItemModel/SortProxyModel>
#include <iostream>

int main()
{
  std::cout << "Hello Conan CMakeDeps" << std::endl;

  Mdt::ItemModel::SortProxyModel model;
  Mdt::ItemEditor::SortSetupWidget widget;

  widget.setup(model);
}
