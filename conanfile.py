from conans import ConanFile, tools
from conan.tools.cmake import CMake, CMakeToolchain
import os

class MdtCMakeModulesConan(ConanFile):
  name = "MdtCMakeModules"
  license = "BSD 3-Clause"
  url = "https://gitlab.com/scandyna/mdt-cmake-modules"
  description = "Some CMake modules used in \"Multi Dev Tools\" projects"
  # Using CMakeToolchain and the new CMake helper
  # should help to have a more unified build.
  # But, it requires the settings.
  # So, add them here and erase them in the package_id()
  settings = "os", "arch", "compiler", "build_type"
  exports_sources = "Modules/*", "CMakeLists.txt", "MdtCMakeModulesConfig.cmake.in", "LICENSE", "mdt_cmake_modules-conan-cmake-modules.cmake"
  generators = "CMakeToolchain"

  # The version can be set on the command line:
  # conan create . x.y.z@scandyna/testing ...
  # It can also be set by a git tag (case of deploy in the CI/CD)
  # The version should usually not be revelant when installing dependencies to build this project:
  # conan install path/to/srouces ...
  # But it can be required. See https://docs.conan.io/en/latest/reference/conanfile/attributes.html#version
  def set_version(self):
    if not self.version:
      if os.path.exists(".git"):
        git = tools.Git()
        self.version = "%s" % (git.get_tag())
      else:
        self.version = "0.0.0"
    self.output.info( "%s: version is %s" % (self.name, self.version) )

  def generate(self):
    tc = CMakeToolchain(self)
    tc.variables["FROM_CONAN_PROJECT_VERSION"] = self.version
    tc.generate()

  def build(self):
    cmake = CMake(self)
    cmake.configure()
    cmake.build()

  def package(self):
    cmake = CMake(self)
    cmake.install()
    self.copy("mdt_cmake_modules-conan-cmake-modules.cmake")

  def package_id(self):
    self.info.header_only()

  def package_info(self):

    self.cpp_info.includedirs = []
    build_modules = ["mdt_cmake_modules-conan-cmake-modules.cmake"]

    # This will be used by CMakeDeps
    self.cpp_info.set_property("cmake_build_modules", build_modules)

    # This must be added for other generators
    self.cpp_info.build_modules["cmake_find_package"] = build_modules
    self.cpp_info.build_modules["cmake_find_package_multi"] = build_modules

# See: https://bincrafters.readthedocs.io/en/latest/contributing_to_packages/package_guidelines_required.html
