from conans import ConanFile, CMake, tools
import os

class MdtCMakeModulesTestConan(ConanFile):
  #settings = "os"
  settings = "os", "compiler", "build_type", "arch"
  generators = "cmake_paths"
  #generators = "cmake_paths", "cmake_find_package_multi"

  #def _build_with_cmake_paths(self):
    #tools.mkdir("cmake_paths_folder")
    #with tools.chdir("cmake_paths_folder"):
      #self.output.info("Building with cmake_paths")
      #cmake = CMake(self)
      #cmake.definitions["CMAKE_TOOLCHAIN_FILE"] = "%s/conan_paths.cmake" % (self.build_folder)
      #cmake.configure(build_folder="cmake_paths_folder")

  #def _build_with_cmake_find_package_multi(self):
    #self.output.info("Building with cmake_find_package_multi")
    #cmake = CMake(self)
    ##cmake.definitions["CMAKE_TOOLCHAIN_FILE"] = "%s/conan_paths.cmake" % (self.build_folder)
    #cmake.configure()


  def build(self):
    cmake = CMake(self)
    cmake.definitions["CMAKE_MESSAGE_LOG_LEVEL"] = "DEBUG"
    cmake.definitions["CMAKE_TOOLCHAIN_FILE"] = "%s/conan_paths.cmake" % (self.build_folder)
    cmake.configure()
    #self._build_with_cmake_paths()
    #self._build_with_cmake_find_package_multi()

  def imports(self):
    self.copy("*.dll", dst="bin", src="bin")

  def test(self):
    cmake = CMake(self)
    # We have no test to run, here we fake a bit..
