from conan import ConanFile
from conan.tools.env import VirtualBuildEnv
from conan.tools.cmake import CMakeToolchain, CMakeDeps, CMake, cmake_layout

class MdtCmakeModulesTestMdtItemModelConan(ConanFile):
  name = "mdtcmakemodulestests_mdtitemmodel"
  #version = "0.5"
  license = "BSD 3-Clause"
  url = "https://github.com/scandyna/mdt-cmake-modules"
  description = "Test package for MdtCmakeModules tests"
  settings = "os", "compiler", "build_type", "arch"
  options = {"shared": [True, False], "install_namespace_package_config_files": [True, False]}
  default_options = {"shared": True, "install_namespace_package_config_files": True}
  generators = "CMakeDeps", "VirtualBuildEnv"
  exports_sources="src/*", "CMakeLists.txt"

  def requirements(self):
    self.requires("mdtcmakemodulestests_mdtheaderonly/0.1@mdtcmakemodules_tests/testing")

  def build_requirements(self):
    self.test_requires("mdtcmakemodules/[>0.1]@mdtcmakemodules_tests/testing")

  def layout(self):
    cmake_layout(self)

  def generate(self):
    tc = CMakeToolchain(self)
    if self.options.install_namespace_package_config_files:
      tc.variables["INSTALL_NAMESPACE_PACKAGE_CONFIG_FILES"] = "ON"
    else:
      tc.variables["INSTALL_NAMESPACE_PACKAGE_CONFIG_FILES"] = "OFF"
    tc.generate()

  def build(self):
    cmake = CMake(self)
    cmake.configure()
    cmake.build()

  def package(self):
    cmake = CMake(self)
    cmake.install()

  def package_info(self):
    self.cpp_info.set_property("cmake_file_name", "Mdt0ItemModel")
    self.cpp_info.set_property("cmake_target_name", "Mdt0::ItemModel")
    self.cpp_info.libs = ["Mdt0ItemModel"]
