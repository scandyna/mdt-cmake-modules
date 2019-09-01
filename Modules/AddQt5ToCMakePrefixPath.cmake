# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# AddQt5ToCMakePrefixPath
# -----------------------
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

#=============================================================================
# Copyright 2019 Philippe Steinmann
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================

macro(add_qt5_to_cmake_prefix_path)

  # We have to use a macro to unset cache variables
  # Using macro has its caveats (see CMake doc for arguments, we also cannot use return() )

  if( (${ARGC} LESS 1) OR ("${ARGV0}" STREQUAL "") )
    # Ok, simply no path given
  elseif( NOT (${ARGC} STREQUAL "1") )
    message(FATAL_ERROR "add_qt5_to_cmake_prefix_path(): unexpected count of arguments")
  else()
    list(APPEND CMAKE_PREFIX_PATH "${ARGV0}")
  endif()

  # Remove the previously set Qt5 variables from the cache
  # We do it at each call, so the user can specify to use the system installed version without having to delete the entiere cache
  get_cmake_property(_qt5_cached_vars CACHE_VARIABLES)
  list(FILTER _qt5_cached_vars INCLUDE REGEX "^Qt5.*DIR$")
  foreach(var ${_qt5_cached_vars})
    unset(${var} CACHE)
  endforeach()

endmacro()
