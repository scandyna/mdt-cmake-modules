# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtFindPathInList
# -----------------
#
# .. contents:: Summary
#    :local:
#
# Explain problem
#
#
# Usage
# ^^^^^
#
# Internal usage for package config files
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
#
# Deploy details
# ^^^^^^^^^^^^^^
#
# :command:`mdt_find_path_in_list()` will be used in some CMake packages files we create.
#
# In those packages files we don't want to depend on ``MdtCMakeModules``.
#
# Example::
#
#   ~/opt
#      |-MdtCMakeModules
#      |        |-Modules
#      |           |-MdtFindPathInList.cmake
#      |-LibA
#      |   |-lib
#      |      |-cmake
#      |          |-LibA
#      |          |   |-MdtFindPathInList.cmake
#      |          |   |-LibAConfig.cmake
#      |          |-Modules
#      |-LibB
#      |   |-lib
#      |      |-cmake
#      |          |-LibB
#      |          |   |-MdtFindPathInList.cmake
#      |          |   |-LibBConfig.cmake
#      |          |-Modules
#
#
# Example using ``MdtCMakeModules`` and ``LibA``
#
# .. code-block:: cmake
#
#   find_package(MdtCMakeModules REQUIRED)
#   find_package(LibA REQUIRED)
#
#   include(MdtFindPathInList)
#
#
# First call to :command:`find_package()` will add ``~/opt/MdtCMakeModules/Modules`` to ``CMAKE_MODULE_PATH``.
#
# Second call to :command:`find_package()` will include ``MdtFindPathInList.cmake`` from ``LibA``.
#
# In the user project, we then include ``MdtFindPathInList``.
# Question: which is implementation that will be available in the user project ?
# Will it be the version from ``LibA`` or the one from ``MdtCMakeModules`` ?
#
# Example using ``LibA`` and ``LibB``
#
# .. code-block:: cmake
#
#   find_package(LibA REQUIRED)
#   find_package(LibB REQUIRED)
#
# Question: which implementation of ``mdt_find_path_in_list()`` will be used in ``LibB`` ?
# The one from ``LibA`` or the one from ``LibB`` ?
#
# To be safe, we could do it this way::
#
#   ~/opt
#      |-MdtCMakeModules
#      |        |-Modules
#      |           |-MdtFindPathInList.cmake
#      |-LibA
#      |   |-lib
#      |      |-cmake
#      |          |-LibA
#      |          |   |-LibAMdtFindPathInList.cmake
#      |          |   |-LibAConfig.cmake
#      |          |-Modules
#      |-LibB
#      |   |-lib
#      |      |-cmake
#      |          |-LibB
#      |          |   |-LibBMdtFindPathInList.cmake
#      |          |   |-LibBConfig.cmake
#      |          |-Modules
#
#
# As example, ``LibAMdtFindPathInList.cmake`` will provide :command:`LibA_mdt_find_path_in_list()`,
# so we know that each part will use its proper implementation.
#
# Why care which version is used ?
# """"""""""""""""""""""""""""""""
#
# If ``LibA`` was installed using a old version of ``MdtCMakeModules``,
# which contains a bug in the implementation of ``LibA_mdt_find_path_in_list()``,
# it will not impact all other parts.
#
# It would be sufficient to rebuild and install ``LibA``
# with a newer version of ``MdtCMakeModules``, that fixes the bug.
# The newly generated ``LibAMdtFindPathInList.cmake`` will then also have a correct implementation of :command:`LibA_mdt_find_path_in_list()`.
#
#
# TODO TRY: implement in a MdtFindPathInList.cmake.in then generate with configure_file(),
#  so function name can be changed.
#
# In both include MdtFindPathInList_impl.cmake ( mdt_find_path_in_list_impl() ) ?
#
