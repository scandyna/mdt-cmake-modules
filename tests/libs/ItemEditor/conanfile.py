from conans import ConanFile, CMake, tools
import os

class MdtCmakeModulesTestMdtItemEditorConan(ConanFile):
  name = "MdtCmakeModulesTests_MdtItemEditor"
  #version = "0.5"
  license = "BSD 3-Clause"
  url = "https://github.com/scandyna/mdt-cmake-modules"
  description = "Test package for MdtCmakeModules tests"
  settings = "os", "compiler", "build_type", "arch"
  options = {"shared": [True, False]}
  default_options = {"shared": True}
  requires = ["MdtCmakeModulesTests_MdtItemModel/0.1@MdtCMakeModules_tests/testing"]
  tool_requires = ["MdtCMakeModules/[>0.1]@MdtCMakeModules_tests/testing"]
  generators = "cmake_paths"
  exports_sources="src/*", "CMakeLists.txt"

  def build(self):
    cmake = CMake(self)
    cmake.definitions["CMAKE_TOOLCHAIN_FILE"] = "%s/conan_paths.cmake" % (self.build_folder)
    cmake.configure(cache_build_folder = "build")
    cmake.build()
    cmake.install()

  def package_info(self):

    # TODO: remove ?
    self.env_info.LD_LIBRARY_PATH.append(os.path.join(self.package_folder, "lib"))

    self.cpp_info.set_property("cmake_file_name", "Mdt0ItemEditor")
    self.cpp_info.set_property("cmake_target_name", "Mdt0::ItemEditor")
    self.cpp_info.libs = ["Mdt0ItemEditor"]
