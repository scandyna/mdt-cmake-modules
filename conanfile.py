from conans import ConanFile, CMake, tools
from conans.errors import ConanInvalidConfiguration
import os

class MdtCMakeModulesConan(ConanFile):
  name = "MdtCMakeModules"
  license = "BSD 3-Clause"
  url = "https://gitlab.com/scandyna/mdt-cmake-modules"
  description = "Some CMake modules used in \"Multi Dev Tools\" projects"
  exports_sources = "Modules/*", "CMakeLists.txt", "MdtCMakeModulesConfig.cmake.in", "LICENSE"

  # TODO: maybe ue package_id() , sa generate()

  def set_version(self):
    if not self.version:
      if not os.path.exists(".git"):
        raise ConanInvalidConfiguration("could not get version from git tag.")
      git = tools.Git()
      self.version = "%s" % (git.get_tag())

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

  def package_info(self):
    # cmake_find_package_multi generator must be supported
    # if we want to use packages from conan-center
    # It will generate CMake targets that have no sense here,
    # I don't know how to avoid that
    # But, at least, tell conan to add the Modules
    # to CMAKE_MODULE_PATH (and also CMAKE_PREFIX_PATH)
    #self.cpp_info.builddirs = ["Modules"]
    self.cpp_info.builddirs = [".","Modules"]

# See: https://bincrafters.readthedocs.io/en/latest/contributing_to_packages/package_guidelines_required.html
