#include <iostream>
#include <string>

int main()
{
  const std::string libFilePath(MDT0_LIBA_FILE_PATH);
  if( libFilePath.empty() ){
    std::cerr << "GlIssue12 test, path to LibA file is empty" << std::endl;
    return 1;
  }

  std::cout << "GlIssue12 test, LibA file: " << libFilePath << std::endl;

  return 0;
}
