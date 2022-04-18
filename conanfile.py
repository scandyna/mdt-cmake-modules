from conans import ConanFile, CMake, tools
#from conan.tools.cmake import CMakeToolchain
import os

class MdtCMakeModulesConan(ConanFile):
  name = "MdtCMakeModules"
  #version = "0.6"
  license = "BSD 3-Clause"
  url = "https://gitlab.com/scandyna/mdt-cmake-modules"
  description = "Some CMake modules used in \"Multi Dev Tools\" projects"
  #generators = "cmake", "cmake_paths", "CMakeDeps", "CMakeToolchain"
  #generators = "cmake", "cmake_paths"
  #generators = "CMakeToolchain"
  exports_sources = "Modules/*", "CMakeLists.txt", "MdtCMakeModulesConfig.cmake.in", "LICENSE"

  # TODO: maybe ue package_id() , sa generate()

  # TODO should fail if no tag found ?
  # Does conan provide a semver tool ??
  def set_version(self):
    if os.path.exists(".git"):
      git = tools.Git()
      self.version = "%s" % (git.get_tag())
    #else:
      #self.version = "None"

  #def generate(self):
    #tc = CMakeToolchain(self)
    #tc.variables["MY_VAR"] = "/tmp"
    #tc.variables.debug["MY_VAR"] = "/tmp"
    #tc.variables.release["MY_VAR"] = "/tmp"
    ##tc.variables.debug["CMAKE_PREFIX_PATH"] = "/tmp"
    ##tc.blocks["find_paths"].values = {"":"/tmp"}
    #tc.generate()
    ##tc.find_paths = "/tmp"
    ##tc.blocks["find_paths"].values = "/tmp"
    ##tc.blocks["generic_system"].find_paths = self.package_folder

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

  #def package_id(self):
    #self.info.header_only()

  def package_info(self):
    #self.cpp_info.names["cmake_find_package_multi"] = ""

    # cmake_find_package_multi generator must be supported
    # if we want to use packages from conan-center
    # It will generate CMake targets that have no sense here,
    # I don't know how to avoid that
    # But, at least, tell conan to add the Modules
    # to CMAKE_MODULE_PATH (and also CMAKE_PREFIX_PATH)
    self.cpp_info.builddirs = ["Modules"]
    #self.cpp_info.libs = ["Fake"]
    #self.cpp_info.builddirs = ["cmake", "Modules"]
    #self.cpp_info.build_modules["cmake_find_package_multi"].append("cmake")

# See: https://bincrafters.readthedocs.io/en/latest/contributing_to_packages/package_guidelines_required.html
