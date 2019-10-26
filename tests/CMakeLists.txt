# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

include(AddQt5ToCMakePrefixPath)
include(MdtInstallPackageConfigFile)

set(QT_PREFIX_PATH CACHE PATH "Path to the root of Qt distribution. (For example: /opt/qt/Qt5/5.13.0/gcc_64). If empty, system distribution is considered.")
add_qt5_to_cmake_prefix_path("${QT_PREFIX_PATH}")

find_package(Qt5 COMPONENTS Core REQUIRED)

add_executable(hello "src/hello.cpp")
target_link_libraries(hello Qt5::Core)
add_test(NAME helloTest COMMAND hello)
