#include "Mdt/ItemEditor/SortSetupWidget.h"
#include "Mdt/ItemModel/SortProxyModel.h"

int main()
{
  Mdt::ItemEditor::SortSetupWidget widget;
  Mdt::ItemModel::SortProxyModel model;

  widget.setup(model);
}

