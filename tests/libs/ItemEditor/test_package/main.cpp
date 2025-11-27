/*
 * GL-25 - See conanfile.py for more details
 */
#include <Mdt/ItemEditor/SortSetupWidget>
#include <Mdt/ItemModel/SortProxyModel>

int main()
{
  Mdt::ItemModel::SortProxyModel model;
  Mdt::ItemEditor::SortSetupWidget widget;

  widget.setup(model);
}
