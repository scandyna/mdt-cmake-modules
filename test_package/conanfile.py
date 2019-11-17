from conans import ConanFile, CMake, tools
import os

# TODO shared libraries !!

class MdtCMakeModulesTestConan(ConanFile):
  settings = "os"
  generators = "cmake_paths"

  def build(self):
    cmake = CMake(self)
    cmake.definitions["CMAKE_TOOLCHAIN_FILE"] = "%s/conan_paths.cmake" % (self.build_folder)
    cmake.definitions["BUILD_TESTS"] = "ON"
    cmake.configure(source_folder="..")

  def imports(self):
    self.copy("*.dll", dst="bin", src="bin")

  def test(self):
    cmake = CMake(self)
    cmake.test()
    # We have no test to run, here we fake a bit..
