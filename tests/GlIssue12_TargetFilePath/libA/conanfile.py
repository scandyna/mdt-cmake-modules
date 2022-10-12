from conans import ConanFile, tools
from conan.tools.cmake import CMakeToolchain, CMakeDeps, CMake
#from conan.tools.env import VirtualBuildEnv
import os

class MdtCommandLineArgumentsConan(ConanFile):
  name = "GlIssue12_TargetFilePath_libA"
  license = "BSD 3-Clause"
  url = "https://gitlab.com/scandyna/mdt-cmake-modules"
  description = "Test library for GlIssue12_TargetFilePath"
  settings = "os", "compiler", "build_type", "arch"
  options = {"shared": [True, False]}
  default_options = {"shared": True}
  generators = "CMakeDeps", "VirtualBuildEnv"

  def export_sources(self):
    self.copy("*", src=".", dst=".")

  def requirements(self):
    self.requires("MdtCMakeConfig/0.0.5@scandyna/testing")

  def build_requirements(self):
    self.tool_requires("MdtCMakeModules/0.2@MdtCMakeModules_tests/testing", force_host_context=True)

  def generate(self):
    tc = CMakeToolchain(self)
    #tc.variables["INSTALL_CONAN_PACKAGE_FILES"] = "ON"
    tc.generate()

  def build(self):
    cmake = CMake(self)
    cmake.configure()
    cmake.build()

  def package(self):
    cmake = CMake(self)
    cmake.install()

  def package_info(self):
    self.cpp_info.set_property("cmake_file_name", "Mdt0LibA")
    self.cpp_info.set_property("cmake_target_name", "Mdt0::LibA")
    self.cpp_info.libs = ["Mdt0LibA"]
