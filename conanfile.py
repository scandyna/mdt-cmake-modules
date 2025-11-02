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
    self.requires("qt/5.15.16")

  def generate(self):
    # Had attempted to get the profiles using the Conan API.
    # It is not possible to get them from here,
    # because they are not part of this recipe,
    # but arguments passed to conan in the command line.

    tc = CMakeToolchain(self)
    #tc.variables["FROM_CONAN_PROJECT_VERSION"] = self.version
    # Options are now handled with CMake presets
    # tc.variables["BUILD_TESTS"] = "ON"
    # tc.variables["BUILD_CONAN_TESTS"] = "ON"
    # tc.variables["BUILD_QT_TESTS"] = "ON"
    # tc.variables["BUILD_MDT_RUNTIME_ENVIRONMENT_STATIC_TESTS"] = "OFF"
    tc.user_presets_path = 'ConanPresets.json'
    tc.generate()
