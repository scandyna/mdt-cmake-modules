from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMake, cmake_layout
from conan.tools.env import Environment, VirtualRunEnv

# GL-25 (https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/25)
#
# mdt_add_test() previously used set_tests_properties() with the ENVIRONMENT property
# to set paths to the dependencies.
# However, this completely replaces the test environment instead of extending it.
#
# Consequences: the ENVIRONMENT test property was set at configure time.
# At this stage, the runtime environment (PATH, LD_LIBRARY_PATH) may be empty or incomplete.
#
# When calling the test() method, conan injects a more complete runtime environment
# (PATH, LD_LIBRARY_PATH, etc..). See the VirtualRunEnv doc for more info.
# Using the ENVIRONMENT_MODIFICATION test property benefits from that,
# ENVIRONMENT dos not.

class MdtCmakeModulesTestMdtItemEditorTestConan(ConanFile):
  settings = "os", "compiler", "build_type", "arch"
  generators = "CMakeDeps", "VirtualRunEnv"

  def layout(self):
    cmake_layout(self)

  def requirements(self):
    self.requires(self.tested_reference_str)

  def build_requirements(self):
    self.test_requires("mdtcmakemodules/[>0.1]@mdtcmakemodules_tests/testing")

  def generate(self):
    tc = CMakeToolchain(self)
    tc.variables["CMAKE_MESSAGE_LOG_LEVEL"] = "DEBUG"
    tc.generate()

  def build(self):
    cmake = CMake(self)
    cmake.configure()
    cmake.build()

  def test(self):
    cmake = CMake(self)
    cmake.ctest(cli_args=["--output-on-failure", "-V"])
