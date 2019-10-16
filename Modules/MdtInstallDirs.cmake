# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtInstallDirs
# ---------------------
#
# Define some relative installation directories
#
# The GNUInstallDirs module, provided by CMake, provides install directory variables as defined by the
# `GNU Coding Standards`_.
#
# .. _`GNU Coding Standards`: https://www.gnu.org/prep/standards/html_node/Directory-Variables.html
#
# The GNUInstallDirs module also provides some support for
# `Debian MultiArch`_.
#
# .. _`Multiarch`: https://wiki.debian.org/Multiarch/Implementation
#
# But some use cases are not covered.
#
#  As described in the CMake documentation,
#  ``CMAKE_INSTALL_PREFIX`` defaults to ``/usr/local`` on UNIX and ``c:/Program Files/${PROJECT_NAME}`` on Windows.
#  If a project is installed system wide on UNIX, for example in ``/usr`` or ``/usr/local``,
#  the Gnu Coding Standards should be followed.
#
#   Example::
#
#    /usr/bin/projectexecutable
#    /usr/lib/projectlib.so
#    /usr/include/projectlib.h
#    /usr/share/project-name/
#
#   On a Debian Multiarch  distribution, the installation will be like::
#
#    /usr/bin/projectexecutable
#    /usr/lib/x86_64-linux-gnu/projectlib.so
#    /usr/include/x86_64-linux-gnu/projectlib.h
#    /usr/share/project-name/
#
#   After looking at a Ubuntu 18.04 installation, lots of libraries do not put their header files directly in the include dir, but in a subdirectory::
#
#    /usr/bin/projectexecutable
#    /usr/lib/x86_64-linux-gnu/projectlib.so
#    /usr/include/x86_64-linux-gnu/project-name/projectlib.h
#    /usr/share/project-name/
#
#  It is also common to install a project to a other location,
#  in which case the organisation could be different.
#
#   Example::
#
#    ~/opt/project-name/bin/projectexecutable
#    ~/opt/project-name/lib/projectlib.so
#    ~/opt/project-name/include/projectlib.h
#    ~/opt/project-name/
#
#  A project has probably some files to install in what is defined ``DATADIR`` (and also ``DATAROOTDIR``),
#  which is mostly defined as ``share`` .
#
#  If a project is installed on Linux system wide (typically in /usr or /urs/local),
#  the data should be installed in a subdirectory, typically ``DATADIR/project-name`` .
#  The documentation should be installed in ``DOCDIR``, which is ``DATAROOTDIR/doc/project-name``
#
#  Example::
#
#   /usr/share/project-name/icons
#   /usr/share/doc/project-name
#
#  It is also common to install a project to a other location,
#  for example ~/opt/project-name .
#  In that case, ``DATADIR`` and ``DATAROOTDIR`` have no sense.
#
#  Example::
#
#   ~/opt/project-name/icons
#   ~/opt/project-name/doc
#
# Inclusion of this module defines the following variables:
#
# ``MDT_INSTALL_IS_UNIX_SYSTEM_WIDE``
#    If ``CMAKE_INSTALL_PREFIX`` starts with ``/usr``, it will be set to ``TRUE``,
#    otherwise to ``FALSE``.
#
# ``MDT_INSTALL_IS_DEBIAN_MULTIARCH_SYSTEM_WIDE``
#    The logic to determine this variable is similar to the one implemented
#    in the GNUInstallDirs module to define ``CMAKE_INSTALL_LIBDIR`` .
#
# ``MDT_INSTALL_INCLUDEDIR``
#    If ``MDT_INSTALL_IS_DEBIAN_MULTIARCH_SYSTEM_WIDE`` is ``TRUE``, it will be set to ``include/${CMAKE_LIBRARY_ARCHITECTURE}/${PROJECT_NAME}`` ,
#    else, if ``MDT_INSTALL_IS_UNIX_SYSTEM_WIDE`` is ``TRUE``, it will be set to ``include/${PROJECT_NAME}`` ,
#    otherwise it will be set to include .
#
# ``MDT_INSTALL_DATAROOTDIR``
#    If ``MDT_INSTALL_IS_UNIX_SYSTEM_WIDE`` is ``TRUE``, it will be set to ``DATAROOTDIR/${PROJECT_NAME}``
#    (which mostly expands to ``share/project-name``),
#    otherwise it will be set to ``.`` .
#
# ``MDT_INSTALL_DATADIR``
#    If ``MDT_INSTALL_IS_UNIX_SYSTEM_WIDE`` is ``TRUE``, it will be set to ``DATADIR/${PROJECT_NAME}``
#    (which mostly expands to ``share/project-name``),
#    otherwise it will be set to ``.`` .
#
# Note: if ``CMAKE_INSTALL_DATAROOTDIR`` and ``CMAKE_INSTALL_DATADIR`` are defined
# (i.e. GNUInstallDirs have been included before including MdtInstallDirs),
# they will be used to define ``MDT_INSTALL_DATAROOTDIR`` and ``MDT_INSTALL_DATADIR``,
# otherwise ``share`` will be considered.
#
# Example of a CMakeLists.txt::
#
#  project(MyProject)
#
#  find_package(MdtCMakeModules REQUIRED)
#
#  add_library(myLib myLib.cpp)
#  add_executable(myApp main.cpp)
#  target_link_libraries(myApp myLib)
#  # Other commands (f.ex. header include dirs for myLib, exports, etc..) are omited here
#
#  include(GNUInstallDirs)
#  include(MdtInstallDirs)
#
#  install(DIRECTORY ${CMAKE_SOURCE_DIR}/icons DESTINATION ${MDT_INSTALL_DATADIR})
#
# CMake uses ``CMAKE_INSTALL_PREFIX`` as root of the installation.
#
# Example of install on Linux system wide with ``CMAKE_INSTALL_PREFIX == /usr`` ::
#
#  /usr/share/project-name/icons
#
# Example of install on Windows system wide with ``CMAKE_INSTALL_PREFIX == c:/Program Files/${PROJECT_NAME}`` ::
#
#  c:/Program Files/project-name/icons
#
# Example of install to a other directory (stand-alone install) ``CMAKE_INSTALL_PREFIX == ~/opt/${PROJECT_NAME}`` ::
#
#  ~/opt/project-name/icons


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

# TODO should define:
# MDT_INSTALL_CMAKE_MODULE_DIR
# MDT_INSTALL_CMAKE_MODULE_CONFIG_DIR
# MDT_INSTALL_CMAKE_LIB_CONFIG_DIR


if("${CMAKE_INSTALL_PREFIX}" MATCHES "^/usr")
  set(MDT_INSTALL_IS_UNIX_SYSTEM_WIDE TRUE CACHE BOOL "" FORCE)
else()
  set(MDT_INSTALL_IS_UNIX_SYSTEM_WIDE FALSE CACHE BOOL "" FORCE)
endif()
mark_as_advanced(MDT_INSTALL_IS_UNIX_SYSTEM_WIDE)

set(MDT_INSTALL_IS_DEBIAN_MULTIARCH_SYSTEM_WIDE FALSE CACHE BOOL "" FORCE)
if(CMAKE_LIBRARY_ARCHITECTURE)
  if("${CMAKE_INSTALL_PREFIX}" MATCHES "^/usr/?$")
    if(CMAKE_SYSTEM_NAME MATCHES "^(Linux|kFreeBSD|GNU)$" AND NOT CMAKE_CROSSCOMPILING)
      if(EXISTS "/etc/debian_version")
        set(MDT_INSTALL_IS_DEBIAN_MULTIARCH_SYSTEM_WIDE TRUE CACHE BOOL "" FORCE)
      endif()
    endif()
  endif()
endif()
mark_as_advanced(MDT_INSTALL_IS_DEBIAN_MULTIARCH_SYSTEM_WIDE)

if(MDT_INSTALL_IS_DEBIAN_MULTIARCH_SYSTEM_WIDE)
  set(MDT_INSTALL_INCLUDEDIR "include/${CMAKE_LIBRARY_ARCHITECTURE}/${PROJECT_NAME}")
elseif(MDT_INSTALL_IS_UNIX_SYSTEM_WIDE)
  set(MDT_INSTALL_INCLUDEDIR "include/${PROJECT_NAME}")
else()
  set(MDT_INSTALL_INCLUDEDIR "include")
endif()

# Define the DATAROOTDIR regarding the existance of CMAKE_INSTALL_DATAROOTDIR (defined if GNUInstallDirs have been included)
if(CMAKE_INSTALL_DATAROOTDIR)
  set(_MDT_INSTALL_DIRS_DATAROOTDIR ${CMAKE_INSTALL_DATAROOTDIR})
else()
  set(_MDT_INSTALL_DIRS_DATAROOTDIR "share")
endif()

# Define the DATADIR regarding the existance of CMAKE_INSTALL_DATAROOTDIR (defined if GNUInstallDirs have been included)
if(CMAKE_INSTALL_DATADIR)
  set(_MDT_INSTALL_DIRS_DATADIR ${CMAKE_INSTALL_DATADIR})
else()
  set(_MDT_INSTALL_DIRS_DATADIR "share")
endif()

# TODO why seems this to work without CACHE ??
if(MDT_INSTALL_IS_UNIX_SYSTEM_WIDE)
  set(MDT_INSTALL_DATAROOTDIR "${_MDT_INSTALL_DIRS_DATAROOTDIR}/${PROJECT_NAME}")
  set(MDT_INSTALL_DATADIR "${_MDT_INSTALL_DIRS_DATADIR}/${PROJECT_NAME}")
else()
  set(MDT_INSTALL_DATAROOTDIR ".")
  set(MDT_INSTALL_DATADIR ".")
endif()
