from conans import ConanFile, CMake, tools

class MdtCMakeModulesConan(ConanFile):
  name = "MdtCMakeModules"
  #version = "0.6"
  license = "BSD 3-Clause"
  url = "https://github.com/scandyna/mdt-cmake-modules"
  description = "Some CMake modules used in \"Multi Dev Tools\" projects"
  generators = "cmake_paths"
  exports_sources = "Modules/*", "CMakeLists.txt", "MdtCMakeModulesConfig.cmake.in", "LICENSE"

  # TODO should fail if no tag found ?
  # Does conan provide a semver tool ??
  def set_version(self):
    git = tools.Git()
    self.version = "%s" % (git.get_tag())

  def build(self):
    cmake = CMake(self)
    cmake.configure()
    cmake.build()

  def package(self):
    cmake = CMake(self)
    cmake.install()
