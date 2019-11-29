from conans import ConanFile, CMake, tools

class MdtCMakeModulesConan(ConanFile):
  name = "MdtCMakeModules"
  version = "0.5"
  license = "BSD 3-Clause"
  url = "https://github.com/scandyna/mdt-cmake-modules"
  description = "Some CMake modules used in Mdt projects"
  settings = "os"
  generators = "cmake_paths"
  exports_sources="*" # Conan seems to be smart enough to not copy test_package/build

  def build(self):
    cmake = CMake(self)
    cmake.configure()
    cmake.build()

  def package(self):
    cmake = CMake(self)
    cmake.install()

# TODO See Conan doc about instantiation (build() / package() ) When build() and package() are run in isolation, we could have problems !
  #def package_info(self):
    #self.
