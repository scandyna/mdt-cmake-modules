from conans import ConanFile, CMake, tools

class MdtCMakeModulesConan(ConanFile):
  name = "MdtCMakeModules"
  version = "0.5"
  license = "BSD 3-Clause"
  url = "https://github.com/scandyna/mdt-cmake-modules"
  description = "Some CMake modules used in Mdt projects"
  generators = "cmake"
  exports_sources="*" # Conan seems to be smart enough to not copy test_package/build

  def build(self):
    cmake = CMake(self)
    cmake.configure()
    cmake.build()

  def package(self):
    cmake = CMake(self)
    cmake.install()

  #def package_info(self):
    #self.
