from conans import ConanFile, CMake, tools

class MdtCMakeModulesConan(ConanFile):
  name = "MdtCMakeModules"
  version = "0.1"
  license = "BSD 3-Clause"
  url = "https://github.com/scandyna/mdt-cmake-modules"
  description = "Some CMake modules used in Mdt projects"
  generators = "cmake"

  def source(self):
    self.run("git clone https://github.com/scandyna/mdt-cmake-modules")

  def build(self):
    cmake = CMake(self)
    cmake.definitions["DETERMINE_INSTALL_ROOT_DIR"] = "OFF"
    cmake.configure(source_folder="mdt-cmake-modules")
    cmake.build()

  def package(self):
    cmake = CMake(self)
    cmake.install()

  #def package_info(self):
    #self.
