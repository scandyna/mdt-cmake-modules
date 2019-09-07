from conans import ConanFile, CMake

class MdtCMakeModulesTestConan(ConanFile):
  generators = "cmake_paths"

  def build(self):
    cmake = CMake(self)
    cmake.definitions["CMAKE_TOOLCHAIN_FILE"] = "%s/conan_paths.cmake" % (self.build_folder)
    cmake.configure()

