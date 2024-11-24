from conan import ConanFile
from conan.tools.env import VirtualBuildEnv
from conan.tools.cmake import CMakeToolchain, CMakeDeps, CMake, cmake_layout

class MdtCmakeModulesTestMdtHeaderOnlyConan(ConanFile):
  name = "mdtcmakemodulestests_mdtheaderonly"
  #version = "0.5"
  license = "BSD 3-Clause"
  url = "https://github.com/scandyna/mdt-cmake-modules"
  description = "Test package for MdtCmakeModules tests"
  # We use CMake to configure/build/(test)/install
  # We also have dependencies we manage with Conan
  # We then use CMakeDeps and CMakeToolchain generators.
  # This requires the settings.
  # We will remove them in the package_id()
  # See: https://docs.conan.io/2/tutorial/creating_packages/other_types_of_packages/header_only_packages.html
  settings = "os", "compiler", "build_type", "arch"
  options = {"install_namespace_package_config_files": [True, False]}
  default_options = {"install_namespace_package_config_files": True}
  generators = "CMakeDeps", "VirtualBuildEnv"
  exports_sources="src/*", "CMakeLists.txt"

  def requirements(self):
    self.requires("mdtcmakeconfig/0.1.0@scandyna/testing")

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

  def package_id(self):
    self.info.clear()

  def package_info(self):
    self.cpp_info.set_property("cmake_file_name", "Mdt0HeaderOnly")
    self.cpp_info.set_property("cmake_target_name", "Mdt0::HeaderOnly")
    self.cpp_info.libs = []
    self.cpp_info.bindirs = []
    self.cpp_info.libdirs = []
