# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtAddLibrary
# ---------------------
#
# Add a "Multi-Dev-Tools" library::
#
#   mdt_add_library(
#     NAMESPACE NameSpace
#     LIBRARY_NAME LibraryName
#     SOURCE_FILES
#       file1.cpp
#       file2.cpp
#   )
#
# This will create a target ``NameSpace::LibraryName`` .
# This will create a target ``NameSpace_LibraryName`` and also a Alias Target ``NameSpace::LibraryName`` .
#
# Example::
#
#   mdt_add_library(
#     NAMESPACE Mdt
#     LIBRARY_NAME Led
#     SOURCE_FILES
#       Mdt/Led.cpp
#   )
#
# This will create a target ``Mdt::Led`` .
# This will create a target ``Mdt_Led`` and also a Alias Target ``Mdt::Led`` .
#
# Install a library::
#
#   mdt_install_library(
#     INSTALL_NAMESPACE InstallNameSpace
#     TARGET Target
#   )
#
# Will export ``Target`` as ``InstallNameSpace::LibraryName`` import target.
# The ``LibraryName`` is the target property ``LIBRARY_NAME`` that have been added by mdt_add_library() .
# This will also export the ``ProjectNameSpace_LibraryName`` target as ``LibraryName`` and install it as the ``Mdt${PROJECT_VERSION_MAJOR}::`` namespace.
#
# Example::
#
#   mdt_install_library(
#     INSTALL_NAMESPACE Mdt0
#     TARGET Mdt::Led
#   )
#
# Will export ``Mdt::Led`` as ``Mdt0::Led`` import target.
# This will also export the ``Mdt_Led`` target as ``Led`` and install it as the ``Mdt0::`` namespace.
#
# Once the library is installed, the user should be able to find it using CMake ``find_package()`` in its ``CMakeLists.txt``::
#
#   find_package(Mdt0 COMPONENTS Led REQUIRED)
#   add_executable(myApp source.cpp)
#   target_link_libraries(myApp Mdt0::Led)
#
# Example of a system wide install of MdtLed on a Debian MultiArch (`CMAKE_INSTALL_PREFIX=/usr`)::
#
#   /usr/include/x86_64-linux-gnu/Mdt0/Mdt/Led.h
#   /usr/lib/x86_64-linux-gnu/libMdt0Led.so.0.x.y
#   /usr/lib/x86_64-linux-gnu/cmake/Mdt0/Mdt0Config.cmake
#   /usr/lib/x86_64-linux-gnu/cmake/Mdt0Led/Mdt0LedConfig.cmake
#
# The ``/usr/lib/x86_64-linux-gnu/cmake/Mdt0/Mdt0Config.cmake`` will be installed
# by the ``Mdt0`` package, which will be a dependency of ``Mdt0Led`` package
# (A distribution will to allow that the same file is handled by diffrent packages).
#
# Example of a stand-alone install on Linux (`CMAKE_INSTALL_PREFIX=~/opt/MdtLed`)::
#
#   ~/opt/MdtLed/include/Mdt/Led.h
#   ~/opt/MdtLed/lib/libMdt0Led.so.0.x.y
#   ~/opt/MdtLed/lib/cmake/Mdt0/Mdt0Config.cmake
#   ~/opt/MdtLed/lib/cmake/Mdt0Led/Mdt0LedConfig.cmake
#
# Here, ``~/opt/MdtLed/lib/cmake/Mdt0/Mdt0Config.cmake`` will be generated automatically,
# allowing the usage of the component syntax of ``find_package()`` .
#
