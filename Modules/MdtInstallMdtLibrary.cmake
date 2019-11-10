# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtInstallMdtLibrary
# --------------------
#
# Install a "Multi-Dev-Tools" library
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_install_mdt_library
#
# Usage::
#
#   mdt_install_mdt_library(
#     TARGET <target>
#   )
#
# Will export ``target`` as ``Mdt${PROJECT_VERSION_MAJOR}::LibraryName`` import target.
# The ``LibraryName`` is the target property ``LIBRARY_NAME`` that have been set by mdt_add_mdt_library() .
#


