#include "Domain.h"
#include <iostream>

namespace GlIssueFour{

void domainProcess()
{
  Mdt::ItemModel::SortProxyModel model;
  model.setup("GlIssueFour::Domain");

  std::cout << "GlIssueFour::domainProcess()" << std::endl;
  model.sort();
}

} // namespace GlIssueFour{
