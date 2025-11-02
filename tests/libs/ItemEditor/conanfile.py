from conan import ConanFile
from conan.tools.env import VirtualBuildEnv
from conan.tools.cmake import CMakeToolchain, CMakeDeps, CMake, cmake_layout

class MdtCmakeModulesTestMdtItemEditorConan(ConanFile):
  name = "mdtcmakemodulestests_mdtitemeditor"
  #version = "0.5"
  license = "BSD 3-Clause"
  url = "https://github.com/scandyna/mdt-cmake-modules"
  description = "Test package for MdtCmakeModules tests"
  settings = "os", "compiler", "build_type", "arch"
  package_type = "library"
  options = {"shared": [True, False]}
  default_options = {"shared": True}
  generators = "CMakeDeps", "VirtualBuildEnv"
  exports_sources="src/*", "CMakeLists.txt"

  # See: https://docs.conan.io/en/latest/reference/conanfile/attributes.html#short-paths
  # Should only be enabled if building on Windows causes problems
  short_paths = True

  def requirements(self):
    self.requires("mdtcmakemodulestests_mdtitemmodel/0.1@mdtcmakemodules_tests/testing", transitive_headers=True)

  def build_requirements(self):
    self.test_requires("mdtcmakemodules/[>0.1]@mdtcmakemodules_tests/testing")

  def layout(self):
    cmake_layout(self)

  def generate(self):
    tc = CMakeToolchain(self)
    tc.generate()

  def build(self):
    cmake = CMake(self)
    cmake.configure()
    cmake.build()

  def package(self):
    cmake = CMake(self)
    cmake.install()

  def package_info(self):
    self.cpp_info.set_property("cmake_file_name", "Mdt0ItemEditor")
    self.cpp_info.set_property("cmake_target_name", "Mdt0::ItemEditor")
    self.cpp_info.libs = ["Mdt0ItemEditor"]
