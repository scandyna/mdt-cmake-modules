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
# But some use cases are not covered:
#
#  As described in the CMake documentation,
#  ``CMAKE_INSTALL_PREFIX`` defaults to ``/usr/local`` on UNIX and ``c:/Program Files/${PROJECT_NAME}`` on Windows.
#  If a project is installed system wide on UNIX, for example in ``/usr`` or ``/usr/local``,
#  the Gnu Coding Standards should be followed.
#
#   Example:
#    /usr/bin/projectexecutable
#    /usr/lib/x86_64-linux-gnu/projectlib.so
#    /usr/share/project-name/
#
#  It is also common to install a project to a other location,
#  in which case the organisation could be different.
#
#   Example:
#    ~/opt/project-name/bin/projectexecutable
#    ~/opt/project-name/lib/projectlib.so
#    ~/opt/project-name/
#
#  A project has probably some files to install in what is defined ``DATADIR`` (and also ``DATAROOTDIR``),
#  which is defined as ``share`` .
#
#  If a project is installed on Linux system wide (typically in /usr or /urs/local),
#  the data should be installed in a subdirectory, typically ``DATADIR/project-name`` .
#  The documentation should be installed in ``DOCDIR``, which is ``DATAROOTDIR/doc/project-name``
#
#  Example:
#   /usr/share/project-name/themes
#   /usr/share/doc/project-name
#
#  It is also common to install a project to a other location,
#  for example ~/opt/project-name .
#  In that case, the files should be installed in ``DATADIR`` directly.
#
#  Example:
#   ~/opt/project-name/share/themes
#   ~/opt/project-name/doc
#
# Inclusion of this module defines the following variables:
#
# ``MDT_INSTALL_IS_UNIX_SYSTEM_WIDE``
#    If ``CMAKE_INSTALL_PREFIX`` starts with ``/usr``, it will be set to ``TRUE``,
#    otherwise to ``FALSE``.
#
# ``MDT_INSTALL_ROOTDIR``
#    If ``MDT_INSTALL_IS_UNIX_SYSTEM_WIDE`` is ``TRUE``, it will be set to ``.``.
#    If ``CMAKE_INSTALL_PREFIX`` ends with ``${PROJECT_NAME}``, it will also be set to ``.``.
#    Otherwise it will be set to ``${PROJECT_NAME}``.
#
# ``MDT_INSTALL_DATAROOTDIR``
#    Either ``DATAROOTDIR/${PROJECT_NAME}`` for Unix system wide installation,
#    otherwise ``DATAROOTDIR``
#
# ``MDT_INSTALL_DATADIR``
#    Either ``DATADIR/${PROJECT_NAME}`` for Unix system wide installation,
#    otherwise ``DATADIR``
#
# Note: if ``CMAKE_INSTALL_DATAROOTDIR`` and ``CMAKE_INSTALL_DATADIR`` are defined
# (i.e. GNUInstallDirs have been included before including MdtInstallDirs),
# they will be used to define ``MDT_INSTALL_DATAROOTDIR`` and ``MDT_INSTALL_DATADIR``,
# otherwise ``share`` will be considered.
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

if("${CMAKE_INSTALL_PREFIX}" MATCHES "^/usr")
  set(MDT_INSTALL_IS_UNIX_SYSTEM_WIDE TRUE CACHE BOOL "" FORCE)
else()
  set(MDT_INSTALL_IS_UNIX_SYSTEM_WIDE FALSE CACHE BOOL "" FORCE)
endif()
mark_as_advanced(MDT_INSTALL_IS_UNIX_SYSTEM_WIDE)


# If the user does not provide any install root directory, we set the default one,
# else we let what he has set
if(NOT MDT_INSTALL_ROOTDIR)
  unset(MDT_INSTALL_ROOTDIR CACHE)
endif()
if( MDT_INSTALL_IS_UNIX_SYSTEM_WIDE OR ("${CMAKE_INSTALL_PREFIX}" MATCHES "^?${PROJECT_NAME}/?$") )
  set(MDT_INSTALL_ROOTDIR "." CACHE STRING "Relative root install directory")
else()
  set(MDT_INSTALL_ROOTDIR "${PROJECT_NAME}" CACHE STRING "Relative root install directory")
endif()

if(CMAKE_INSTALL_DATAROOTDIR)
  set(_MDT_INSTALL_DIRS_DATAROOTDIR ${CMAKE_INSTALL_DATAROOTDIR})
else()
  set(_MDT_INSTALL_DIRS_DATAROOTDIR "share")
endif()

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
  set(MDT_INSTALL_DATAROOTDIR "${MDT_INSTALL_ROOTDIR}/${_MDT_INSTALL_DIRS_DATAROOTDIR}")
  set(MDT_INSTALL_DATADIR "${MDT_INSTALL_ROOTDIR}/${_MDT_INSTALL_DIRS_DATADIR}")
endif()
