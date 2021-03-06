from conans import ConanFile, CMake, tools
import os

class MdtCMakeModulesConan(ConanFile):
  name = "MdtCMakeModules"
  #version = "0.6"
  license = "BSD 3-Clause"
  url = "https://gitlab.com/scandyna/mdt-cmake-modules"
  description = "Some CMake modules used in \"Multi Dev Tools\" projects"
  generators = "cmake", "cmake_paths"
  exports_sources = "Modules/*", "CMakeLists.txt", "MdtCMakeModulesConfig.cmake.in", "LICENSE"

  # TODO should fail if no tag found ?
  # Does conan provide a semver tool ??
  def set_version(self):
    if os.path.exists(".git"):
      git = tools.Git()
      self.version = "%s" % (git.get_tag())
    #else:
      #self.version = "None"

  def configure_cmake(self):
    cmake = CMake(self)
    cmake.definitions["FROM_CONAN_PROJECT_VERSION"] = self.version

    return cmake

  def build(self):
    cmake = self.configure_cmake()
    cmake.configure()
    cmake.build()
    cmake.install()

  #def package(self):
    #cmake = CMake(self)
    #cmake.install()

# See: https://bincrafters.readthedocs.io/en/latest/contributing_to_packages/package_guidelines_required.html
