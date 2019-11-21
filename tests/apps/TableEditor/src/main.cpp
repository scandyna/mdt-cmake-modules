#include <Mdt/ItemEditor/SortSetupWidget>
#include <Mdt/ItemModel/SortProxyModel>
#include <iostream>

int main()
{
  Mdt::ItemModel::SortProxyModel model;
  Mdt::ItemEditor::SortSetupWidget widget;

  widget.setup(model);
}
