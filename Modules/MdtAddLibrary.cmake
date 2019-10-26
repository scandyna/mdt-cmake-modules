# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtAddLibrary
# ---------------------
#
# Add a library::
#
#   mdt_add_library(
#     NAMESPACE NameSpace
#     LIBRARY_NAME LibraryName
#     [PUBLIC_DEPENDENCIES <dependencies>]
#     [PRIVATE_DEPENDENCIES <dependencies>]
#     SOURCE_FILES
#       file1.cpp
#       file2.cpp
#   )
#
# This will create a target ``NameSpace_LibraryName`` and also a ALIAS target ``NameSpace::LibraryName`` .
# To define other properties to the target, use ``NameSpace_LibraryName``
# (CMake will trow errors if ``NameSpace::LibraryName`` is used).
#
# Note: each dependency passed to PUBLIC_DEPENDENCIES and PRIVATE_DEPENDENCIES must be a target.
#
# Example::
#
#   mdt_add_library(
#     NAMESPACE Mdt
#     LIBRARY_NAME Led
#     PUBLIC_DEPENDENCIES Mdt::Core Qt5::Widgets
#     SOURCE_FILES
#       Mdt/Led.cpp
#   )
#
# This will create a target ``Mdt_Led`` and a alias target ``Mdt::Led`` .
#
# Add a "Multi-Dev-Tools" library::
#
#   mdt_add_mdt_library(
#     LIBRARY_NAME LibraryName
#     SOURCE_FILES
#       file1.cpp
#       file2.cpp
#   )
#
# This will create a target ``Mdt_LibraryName`` and a alias target ``Mdt::LibraryName`` .
#
# TODO for install, do not include GNUInstallDirs and MdtInstallDirs, but document that they are required
#      this allows the user to do some setup before..
#
# TODO Public and Private dependencies
#
# Install a library::
#
#   mdt_install_library(
#     INSTALL_NAMESPACE InstallNameSpace
#     TARGET Target
#     [RUNTIME_COMPONENT <component-name>]
#     [DEVELOPMENT_COMPONENT <component-name>]
#   )
#
# The ``LibraryName`` is the target property ``LIBRARY_NAME`` that have been set by mdt_add_library() .
# Will export ``Target`` as ``InstallNameSpace::LibraryName`` import target.
#
# A property ``INTERFACE_FIND_PACKAGE_NAME`` with a value ``${INSTALL_NAMESPACE}${LIBRARY_NAME}`` will also be added to the target if not allready set.
# This property will then be used to generate a package config file to find it later by the user of the installed library.
# See also this discussion: https://gitlab.kitware.com/cmake/cmake/issues/17006
# This idea comes from the BCM modules: https://bcm.readthedocs.io/en/latest/index.html
#
# Example::
#
#   # This should be set at the top level CMakeLists.txt
#   set(MDT_INSTALL_PACKAGE_NAME Mdt0)
#   include(GNUInstallDirs)
#   include(MdtInstallDirs)
#
#   mdt_install_library(
#     INSTALL_NAMESPACE Mdt0
#     TARGET Mdt_Led
#   )
#
# Will export ``Mdt_Led`` as ``Mdt0::Led`` import target.
# The ``INTERFACE_FIND_PACKAGE_NAME`` will be set to ``Mdt0Led`` .
#
# The ``INSTALL_NAMESPACE`` argument will be used for..... example: lib${InstallNameSpace}LibraryName.so.${VERSION??}.${VERSION??}.${VERSION??}
#
# Despite MDT_INSTALL_PACKAGE_NAME and INSTALL_NAMESPACE argument are both set to Mdt0 (which is recomended for coherence), their usage are different....
#  TODO Also document: name clashes on system wide install on Linux
#
# Several components will be created:
#  - Mdt_Led_Runtime: lib, cmake, ..................
#  - Mdt_Led_Dev: headers, cmake ?? ................
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
# Install a "Multi-Dev-Tools" library::
#
#   mdt_install_mdt_library(
#     TARGET Target
#   )
#
# Will export ``Target`` as ``Mdt${PROJECT_VERSION_MAJOR}::LibraryName`` import target.
# The ``LibraryName`` is the target property ``LIBRARY_NAME`` that have been set by mdt_add_mdt_library() .
#
#
#
