from conans import ConanFile, CMake, tools
#from conan.tools.cmake import CMakeToolchain
import os

class MdtCMakeModulesTestConan(ConanFile):
  #settings = "os"
  settings = "os", "compiler", "build_type", "arch"
  #generators = "cmake_paths"
  #generators = "CMakeDeps", "CMakeToolchain"
  #generators = "CMakeToolchain"
  generators = "cmake_paths", "cmake_find_package_multi"

  #def generate(self):
    #tc = CMakeToolchain(self)
    ##tc.variables["CMAKE_PREFIX_PATH"] = self.package_folder
    ##tc.variables.debug["MY_VAR"] = "/tmp"
    ##tc.variables.release["MY_VAR"] = "/tmp"
    ##tc.variables.debug["CMAKE_PREFIX_PATH"] = "/tmp"
    ##tc.blocks["find_paths"].values = {"":"/tmp"}
    #tc.generate()
    ##tc.find_paths = "/tmp"
    ##tc.blocks["find_paths"].values = "/tmp"
    ##tc.blocks["generic_system"].find_paths = self.package_folder

  def _build_with_cmake_paths(self):
    tools.mkdir("cmake_paths_folder")
    with tools.chdir("cmake_paths_folder"):
      self.output.info("Building with cmake_paths")
      cmake = CMake(self)
      cmake.definitions["CMAKE_TOOLCHAIN_FILE"] = "%s/conan_paths.cmake" % (self.build_folder)
      cmake.configure(build_folder="cmake_paths_folder")

  def _build_with_cmake_find_package_multi(self):
    self.output.info("Building with cmake_find_package_multi")
    cmake = CMake(self)
    #cmake.definitions["CMAKE_TOOLCHAIN_FILE"] = "%s/conan_paths.cmake" % (self.build_folder)
    cmake.configure()


  def build(self):
    self._build_with_cmake_paths()
    self._build_with_cmake_find_package_multi()
    #cmake = CMake(self)
    #cmake.definitions["CMAKE_TOOLCHAIN_FILE"] = "%s/conan_toolchain.cmake" % (self.build_folder)
    #cmake.definitions["CMAKE_TOOLCHAIN_FILE"] = "%s/conan_paths.cmake" % (self.build_folder)
    #cmake.configure()

  def imports(self):
    self.copy("*.dll", dst="bin", src="bin")

  def test(self):
    cmake = CMake(self)
    # We have no test to run, here we fake a bit..
