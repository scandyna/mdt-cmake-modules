from conans import ConanFile, CMake, tools
import os

class MdtCmakeModulesTestMdtHeaderOnlyConan(ConanFile):
  name = "MdtCmakeModulesTests_MdtHeaderOnly"
  #version = "0.5"
  license = "BSD 3-Clause"
  url = "https://github.com/scandyna/mdt-cmake-modules"
  description = "Test package for MdtCmakeModules tests"
  options = {"install_namespace_package_config_files": [True, False]}
  default_options = {"install_namespace_package_config_files": True}
  requires = "MdtCMakeModules/[>0.1]@MdtCMakeModules_tests/testing"
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
