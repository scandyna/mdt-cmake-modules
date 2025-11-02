from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMake, cmake_layout
from conan.tools.env import VirtualRunEnv
import os

class MdtCMakeModulesTestpackageConan(ConanFile):
  settings = "os", "compiler", "build_type", "arch"
  generators = "CMakeDeps", "VirtualBuildEnv"

  def layout(self):
    cmake_layout(self)

  def requirements(self):
    self.requires(self.tested_reference_str)

  def generate(self):
    tc = CMakeToolchain(self)
    tc.variables["CMAKE_MESSAGE_LOG_LEVEL"] = "DEBUG"
    tc.generate()

  def build(self):
    cmake = CMake(self)
    cmake.configure()
    cmake.build()

  def test(self):
    cmake = CMake(self)
    # We have no test to run, here we fake a bit..
