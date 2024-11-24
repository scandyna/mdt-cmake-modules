from conan import ConanFile
from conan.tools.env import VirtualBuildEnv
from conan.tools.cmake import CMakeToolchain, CMakeDeps, CMake, cmake_layout
from conan.tools.files import copy
#import os


class MdtLibAConan(ConanFile):
  name = "glissue12_targetfilepath_liba"
  license = "BSD 3-Clause"
  url = "https://gitlab.com/scandyna/mdt-cmake-modules"
  description = "Test library for GlIssue12_TargetFilePath"
  settings = "os", "compiler", "build_type", "arch"
  options = {"shared": [True, False]}
  default_options = {"shared": True}
  generators = "CMakeDeps", "VirtualBuildEnv"

  def export_sources(self):
    source_root = self.recipe_folder
    copy(self, "*", source_root, self.export_sources_folder)

  def layout(self):
    cmake_layout(self)

  def requirements(self):
    self.requires("mdtcmakeconfig/0.1.0@scandyna/testing")

  def build_requirements(self):
    self.test_requires("mdtcmakemodules/0.2@mdtcmakemodules_tests/testing")

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
