from conans import ConanFile, CMake, tools
import os

class MdtCmakeModulesTestMdtItemEditorConan(ConanFile):
  name = "MdtCmakeModulesTests_MdtItemEditor"
  #version = "0.5"
  license = "BSD 3-Clause"
  url = "https://github.com/scandyna/mdt-cmake-modules"
  description = "Test package for MdtCmakeModules tests"
  settings = "os", "compiler", "build_type", "arch"
  options = {"shared": [True, False]}
  default_options = {"shared": True}
  requires = ["MdtCMakeModules/[>0.1]@MdtCMakeModules_tests/testing",
              "MdtCmakeModulesTests_MdtItemModel/0.1@MdtCMakeModules_tests/testing"]
  generators = "cmake_paths"
  exports_sources="*" # Conan seems to be smart enough to not copy test_package/build

  def build(self):
    cmake = CMake(self)
    cmake.definitions["CMAKE_TOOLCHAIN_FILE"] = "%s/conan_paths.cmake" % (self.build_folder)
    cmake.configure()
    cmake.build()

  def package(self):
    cmake = CMake(self)
    cmake.install()

  def package_info(self):
    self.env_info.LD_LIBRARY_PATH.append(os.path.join(self.package_folder, "lib"))

# TODO See Conan doc about instantiation (build() / package() ) When build() and package() are run in isolation, we could have problems !
