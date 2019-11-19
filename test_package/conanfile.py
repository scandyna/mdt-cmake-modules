from conans import ConanFile, CMake, tools
import os

class MdtCMakeModulesTestConan(ConanFile):
  settings = "os"
  generators = "cmake_paths"

  def build(self):
    cmake = CMake(self)
    cmake.definitions["CMAKE_TOOLCHAIN_FILE"] = "%s/conan_paths.cmake" % (self.build_folder)
    cmake.configure()

  def imports(self):
    self.copy("*.dll", dst="bin", src="bin")

  def test(self):
    cmake = CMake(self)
    # We have no test to run, here we fake a bit..
