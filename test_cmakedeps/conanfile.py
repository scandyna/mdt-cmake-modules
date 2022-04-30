from conans import ConanFile, CMake, tools
from conan.tools.cmake import CMakeToolchain, CMakeDeps
import os

class MdtCMakeModulesTestConan(ConanFile):
  #settings = "os"
  settings = "os", "compiler", "build_type", "arch"
  generators = "CMakeToolchain", "CMakeDeps"

  def build(self):
    cmake = CMake(self)
    cmake.definitions["CMAKE_MESSAGE_LOG_LEVEL"] = "DEBUG"
    cmake.configure(source_folder="../test_package")
    cmake.build()

  def imports(self):
    self.copy("*.dll", dst="bin", src="bin")

  def test(self):
    cmake = CMake(self)
    # We have no test to run, here we fake a bit..
