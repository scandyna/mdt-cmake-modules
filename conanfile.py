#
# This recipe is only used to install Qt
# when tests with Qt are required.
#
# For package recipe, see packaging/conan/
#
from conan import ConanFile
from conan.tools.env import VirtualBuildEnv
from conan.tools.cmake import CMakeToolchain, CMakeDeps, CMake

class MdtCMakeModulesConan(ConanFile):
  name = "mdtcmakemodules"
  license = "BSD 3-Clause"
  url = "https://gitlab.com/scandyna/mdt-cmake-modules"
  description = "Some CMake modules used in \"Multi Dev Tools\" projects"
  settings = "os", "compiler", "build_type", "arch"
  generators = "CMakeDeps", "VirtualBuildEnv"

  def requirements(self):
    self.requires("qt/5.15.6")

  def generate(self):
    tc = CMakeToolchain(self)
    #tc.variables["FROM_CONAN_PROJECT_VERSION"] = self.version
    tc.variables["BUILD_TESTS"] = "ON"
    tc.variables["BUILD_CONAN_TESTS"] = "ON"
    tc.variables["BUILD_QT_TESTS"] = "ON"
    tc.variables["BUILD_MDT_RUNTIME_ENVIRONMENT_STATIC_TESTS"] = "OFF"
    tc.generate()
