# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# AddQt5ToCMakePrefixPath
# -------------
#
# ::
#
#   add_qt5_to_cmake_prefix_path(qt_prefix_path)
#
# Add the given path to Qt5 to the CMAKE_PREFIX_PATH
# by taking also care that it will work as expected with cmake-gui .
#
# ::
#
#   set(QT_PREFIX_PATH CACHE PATH "Path to the root of Qt distribution. (For example: /opt/qt/Qt5/5.13.0/gcc_64). If empty, system distribution is considered.")
#
# The problem is, when running cmake-gui the first time,
# find_package() will eventually find some parts of Qt in the system installation
# (for example /usr/lib/x86_64-gnu on some Linux distribution).
# Then, the user can set the QT_PREFIX_PATH by selecting it.
# QT_PREFIX_PATH will be added to CMAKE_PREFIX_PATH.
# After a second run of CMake by calling "Configure",
# variables like Qt5_DIR , Qt5Core_DIR, etc.. will not be updated.
# If some optional module was not installed system wide,
# it will be found in the Qt distribution specified.
# This will end up with a mix of both versions of Qt.
#
#
# If the argument qt_prefix_path is set,
# each variable of the form Qt5${component}_DIR set in the CACHE will be unset
# and qt_prefix_path will be to CMAKE_PREFIX_PATH .
#
# If the argument qt_prefix_path was not set, nothing is done.
# This way it is also possible to let the user use the system installed Qt5 libraries.
#
# Example:
#
# ::
#
#   set(QT_PREFIX_PATH CACHE PATH "Path to the root of Qt distribution. (For example: /opt/qt/Qt5/5.13.0/gcc_64). If empty, system distribution is considered.")
#   add_qt5_to_cmake_prefix_path("${QT_PREFIX_PATH}")
#

include(CMakeParseArguments)

function(add_qt5_to_cmake_prefix_path)
  
endfunction()
