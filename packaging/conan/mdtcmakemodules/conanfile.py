from conan import ConanFile
from conan.tools.env import VirtualBuildEnv
from conan.tools.cmake import CMakeToolchain, CMakeDeps, CMake, cmake_layout
from conan.tools.files import copy
import os

class MdtCMakeModulesConan(ConanFile):
  name = "mdtcmakemodules"
  license = "BSD 3-Clause"
  url = "https://gitlab.com/scandyna/mdt-cmake-modules"
  description = "Some CMake modules used in \"Multi Dev Tools\" projects"
  # We use CMake to configure/build/(test)/install
  # We also have dependencies we manage with Conan
  # We then use CMakeDeps and CMakeToolchain generators.
  # This requires the settings.
  # We will remove them in the package_id()
  # See: https://docs.conan.io/2/tutorial/creating_packages/other_types_of_packages/header_only_packages.html
  settings = "os", "compiler", "build_type", "arch"
  options = {
    "shared": [True, False]
  }
  default_options = {
    "shared": True
  }
  generators = "CMakeDeps", "VirtualBuildEnv"

  # The version can be set on the command line:
  # conan create . x.y.z@scandyna/testing ...
  # The version should usually not be relevant when installing dependencies to build a project:
  # conan install path/to/srouces ...
  # But it can be required.
  # See https://docs.conan.io/2/reference/conanfile/methods/set_version.html#reference-conanfile-methods-set-version
  def set_version(self):
    if not self.version:
      self.version = "0.0.0"

  def export_sources(self):
    source_root = os.path.join(self.recipe_folder, "../../../")
    copy(self, "Modules/*", source_root, self.export_sources_folder)
    copy(self, "CMakeLists.txt", source_root, self.export_sources_folder)
    copy(self, "LICENSE", source_root, self.export_sources_folder)

  def layout(self):
    cmake_layout(self)

  def generate(self):
    tc = CMakeToolchain(self)
    tc.variables["FROM_CONAN_PROJECT_VERSION"] = self.version
    tc.variables["INSTALL_CONAN_PACKAGE_FILES"] = "ON"
    tc.generate()

  def build(self):
    cmake = CMake(self)
    cmake.configure()
    cmake.build()

  def package(self):
    cmake = CMake(self)
    cmake.install()

  def package_id(self):
    self.info.clear()

  def package_info(self):
    self.cpp_info.bindirs = []
    self.cpp_info.libdirs = []
    self.cpp_info.includedirs = []
    build_modules = ["mdtcmakemodules-conan-cmake-modules.cmake"]
    #self.cpp_info.set_property("cmake_file_name", "Mdt0")
    self.cpp_info.set_property("cmake_build_modules", build_modules)
