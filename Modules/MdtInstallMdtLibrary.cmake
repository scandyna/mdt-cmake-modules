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
#     VERSION_COMPATIBILITY <AnyNewerVersion|SameMajorVersion|ExactVersion>
#   )
#
# This is similar to using :command:`mdt_install_library()` like this:
#
# .. code-block:: cmake
#
#   include(MdtInstallLibrary)
#
#   set(MDT_INSTALL_PACKAGE_NAME Mdt${PROJECT_VERSION_MAJOR})
#   include(GNUInstallDirs)
#   include(MdtInstallDirs)
#
#   get_target_property(libraryName ${TARGET} LIBRARY_NAME)
#
#   mdt_install_library(
#     TARGET ${TARGET}
#     RUNTIME_DESTINATION ${CMAKE_INSTALL_BINDIR}
#     LIBRARY_DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     ARCHIVE_DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     INCLUDES_DESTINATION ${MDT_INSTALL_INCLUDEDIR}
#     EXPORT_NAME ${libraryName}
#     EXPORT_NAMESPACE Mdt${PROJECT_VERSION_MAJOR}::
#     INSTALL_NAMESPACE ${MDT_INSTALL_PACKAGE_NAME}
#     FIND_PACKAGE_PATHS ..
#     INSTALL_IS_UNIX_SYSTEM_WIDE ${MDT_INSTALL_IS_UNIX_SYSTEM_WIDE}
#     VERSION ${PROJECT_VERSION}
#     SOVERSION ${PROJECT_VERSION_MAJOR}
#     VERSION_COMPATIBILITY ${VERSION_COMPATIBILITY}
#     RUNTIME_COMPONENT Mdt_${libraryName}_Runtime
#     DEVELOPMENT_COMPONENT Mdt_${libraryName}_Dev
#   )
#
#
