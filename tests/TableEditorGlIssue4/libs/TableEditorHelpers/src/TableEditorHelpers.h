#ifndef TABLE_EDITOR_HELPERS_H
#define TABLE_EDITOR_HELPERS_H

#include <Mdt/ItemEditor/SortSetupWidget>
#include <Mdt/ItemModel/SortProxyModel>
#include "tableeditorhelpers_export.h"

class TABLEEDITORHELPERS_EXPORT TableEditorHelpers
{
 public:

  void setupSorting();

 private:

  Mdt::ItemEditor::SortSetupWidget mSetupWidget;
  Mdt::ItemModel::SortProxyModel mModel;
};

#endif // #ifndef TABLE_EDITOR_HELPERS_H
