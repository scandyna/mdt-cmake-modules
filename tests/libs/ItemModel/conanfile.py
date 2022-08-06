from conans import ConanFile, CMake, tools
import os

class MdtCmakeModulesTestMdtItemModelConan(ConanFile):
  name = "MdtCmakeModulesTests_MdtItemModel"
  #version = "0.5"
  license = "BSD 3-Clause"
  url = "https://github.com/scandyna/mdt-cmake-modules"
  description = "Test package for MdtCmakeModules tests"
  settings = "os", "compiler", "build_type", "arch"
  options = {"shared": [True, False], "install_namespace_package_config_files": [True, False]}
  default_options = {"shared": True, "install_namespace_package_config_files": True}
  requires = ["MdtCmakeModulesTests_MdtHeaderOnly/0.1@MdtCMakeModules_tests/testing"]
  tool_requires = ["MdtCMakeModules/[>0.1]@MdtCMakeModules_tests/testing"]
  generators = "cmake_paths"
  exports_sources="src/*", "CMakeLists.txt"

  def build(self):
    cmake = CMake(self)
    cmake.definitions["CMAKE_TOOLCHAIN_FILE"] = "%s/conan_paths.cmake" % (self.build_folder)
    if self.options.install_namespace_package_config_files:
      cmake.definitions["INSTALL_NAMESPACE_PACKAGE_CONFIG_FILES"] = "ON"
    else:
      cmake.definitions["INSTALL_NAMESPACE_PACKAGE_CONFIG_FILES"] = "OFF"
    cmake.configure(cache_build_folder = "build")
    cmake.build()
    cmake.install()

  def package_info(self):

    self.cpp_info.set_property("cmake_file_name", "Mdt0ItemModel")
    self.cpp_info.set_property("cmake_target_name", "Mdt0::ItemModel")
    self.cpp_info.libs = ["Mdt0ItemModel"]
