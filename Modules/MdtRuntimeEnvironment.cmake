# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtRuntimeEnvironment
# ---------------------
#
# Using installed shared libraries in your development
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# Introduction
# """"""""""""
#
# On Linux, only using system wide installed libraries
# will not cause any problem.
#
# In practice, libraries that are not available on the system
# (for example the latest version of Qt5) will be installed
# in a directory that is not known by the loader.
#
# When developping your own libraries,
# you probably not want to install them system wide.
#
# By using CMake on Linux, depending on one package
# providing shared libraries in one directory will not cause problems.
#
# Take a (simplified) Qt5 installation as example::
#
#   ~/opt
#      |-Qt5
#         |-5.13.1
#             |gcc_64
#                 |-lib
#                    |-cmake
#                    |-libQt5Core.so
#                    |-libQt5Gui.so
#                    |-libQt5Widgets.so
#
# Your project depends on Qt5 Widgets:
#
# .. code-block:: cmake
#
#   find_package(Qt5 COMPONENTS Widgets REQUIRED)
#   add_executable(myApp source.cpp)
#   target_link_libraries(myApp Qt5::Widgets)
#
# On Linux, ``myApp`` will build and run in the build tree out of the box.
#
# This is because CMake handles the ``RPATH``.
# ``myApp`` will have a entry in its ``RUNPATH`` pointing to the absolute path
# of the installed Qt5 library (for example ``/home/you/opt/Qt5/5.13.1/gcc_64/lib``).
#
# You can experiment it with ``objdump``::
#
#   objdump -x myApp | less
#
# While ``myApp`` depends on ``libQt5Widgets.so``,
# ``libQt5Widgets.so`` itself also depends on ``libQt5Gui.so``,
# ``libQt5Core.so`` and other shared libraries.
# All of those dependencies are resolved at runtime
# because Qt5's libraries are shipped with their ``RUNPATH`` pointing to ``$ORIGIN``.
#
# Problems comes when installing different projects,
# providing shared libraries, in different locations.
# This is, for example, the case when using a package manager like
# `Conan <https://conan.io/>`_ .
#
# Lets take a example of 2 installed libraries::
#
#   ~opt
#     |-MdtItemModel
#     |    |-lib
#     |       |-cmake
#     |       |-libMdt0ItemModel.so
#     |
#     |-MdtItemEditor
#          |-lib
#             |-cmake
#             |-libMdt0ItemEditor.so
#
# Here, ``MdtItemEditor`` depends on ``MdtItemModel``.
#
# Your project depends on MdtItemEditor:
#
# .. code-block:: cmake
#
#   find_package(Mdt0 COMPONENTS ItemEditor REQUIRED)
#   add_executable(myApp source.cpp)
#   target_link_libraries(myApp Mdt0::ItemEditor)
#
# The dependencies are resolved transitively,
# so we don't care about finding ``MdtItemModel``
# (and its own dependencies) ourselve.
#
# On Linux, CMake will generate a build system that can build ``myApp``.
#
# This time, running ``myApp`` in the build tree will fail.
# This is because ``libMdt0ItemEditor.so`` cannot find ``libMdt0ItemModel.so``.
#
# For the final application, a solution is to copy each shared library
# to a common directory.
#
# While working on a library or a application,
# setting temporary environment paths can help, at least to execute the unit tests.
#
#
# Using environment path as CMake property
# """"""""""""""""""""""""""""""""""""""""
#
# .. command:: mdt_target_libraries_to_library_env_path
#
# Get a list of full path to the directory for each dependency of a target::
#
#   mdt_target_libraries_to_library_env_path(<out_var> TARGET <target>)
#
# Example:
#
# .. code-block:: cmake
#
#   add_executable(myApp main.cpp)
#
#   target_link_libraries(myApp
#     PRIVATE Mdt0::ItemEditor
#   )
#
#   set(myAppEnv)
#   mdt_target_libraries_to_library_env_path(myAppEnv TARGET myApp)
#
# ``myAppEnv`` will contain a generator expression to build a environment path.
#
# On Linux::
#
#   LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:$ENV{LD_LIBRARY_PATH}
#
#
# On Windows::
#
#   PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:$ENV{PATH}
#
#
# TODO: is it possible to not set LD_LIBRARY_PATH for dependencies intsalled UNIX system wide ?
#
#
# .. command:: mdt_set_test_library_env_path
#
# Set the ``ENVIRONMENT`` property to a test with paths
# to the libraries the test links to::
#
#   mdt_set_test_library_env_path(NAME <test-name> TARGET <test-target>)
#
# Will get the libraries defined in the ``LINK_LIBRARIES`` property of ``test-target``,
# then the ``INTERFACE_LINK_LIBRARIES`` for each dependency.
#
# Example:
#
# .. code-block:: cmake
#
#   add_executable(myApp main.cpp)
#
#   target_link_libraries(myApp
#     PRIVATE Mdt0::ItemEditor
#   )
#
#   add_test(NAME RunMyApp COMMAND myApp)
#   mdt_set_test_library_env_path(NAME RunMyApp TARGET myApp)
#
# This will set the ``ENVIRONMENT`` property to the test like this:
#
# .. code-block:: cmake
#
#   set_tests_properties(RunMyApp
#     PROPERTIES
#       ENVIRONMENT
#         "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:$ENV{LD_LIBRARY_PATH}"
#   )
#
#
# Using environment path in the terminal
# """"""""""""""""""""""""""""""""""""""
#
# To run a executable from the shell, without running CTest,
# a environment can be set using Conan.
#
# For example, see `Conan env_info <https://docs.conan.io/en/latest/reference/conanfile/methods.html#method-package-info-env-info>`_ .
#
# In the recipe of each library, define environment in the package_info:
#
# .. code-block:: python
#
#   def package_info(self):
#     self.env_info.LD_LIBRARY_PATH.append(os.path.join(self.package_folder, "lib"))
#     self.env_info.PATH.append(os.path.join(self.package_folder, "bin"))
#
# Then, in your project, in the conanfile.txt, add the ``virtualenv`` generator:
#
# .. code-block:: text
#
#   [generators]
#   cmake_paths
#   virtualenv
#
# On Linux, setup the temporary environment:
#
# .. code-block:: bash
#
#   source activate.sh
#
# Setup the temporary environment on Windows:
#
# .. code-block:: bash
#
#   activate.bat
#
# For more precisions, see `Conan Virtualenv generator <https://docs.conan.io/en/latest/mastering/virtualenv.html>`_ .
#

include(MdtTargetProperties)

function(mdt_target_libraries_to_library_env_path out_var)

  set(options "")
  set(oneValueArgs TARGET)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_target_libraries_to_library_env_path(): ${ARG_TARGET} is not a valid target")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_target_libraries_to_library_env_path(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  set(pathList)
  set(directDependencies)
  get_target_property(directDependencies ${ARG_TARGET} LINK_LIBRARIES)
  if(directDependencies)
    foreach(directDependency ${directDependencies})
      if(TARGET ${directDependency})
        mdt_target_is_shared_library(directDependencyIsSharedLibrary TARGET ${directDependency})
        if(directDependencyIsSharedLibrary)
          string(APPEND pathList ":\$<TARGET_FILE_DIR:${directDependency}>")
        endif()
      else()
        message(WARNING "mdt_target_libraries_to_library_env_path(): library ${directDependency} will be ignored because it is not a TARGET")
        continue()
      endif()
      set(interfaceLinkDependencies)
      get_target_property(interfaceLinkDependencies ${directDependency} INTERFACE_LINK_LIBRARIES)
      if(interfaceLinkDependencies)
        foreach(interfaceLinkDependency ${interfaceLinkDependencies})
          if(TARGET ${interfaceLinkDependency})
            mdt_target_is_shared_library(interfaceLinkDependencyIsSharedLibrary TARGET ${interfaceLinkDependency})
            if(interfaceLinkDependencyIsSharedLibrary)
              string(APPEND pathList ":\$<TARGET_FILE_DIR:${interfaceLinkDependency}>")
            endif()
          else()
            message(WARNING "mdt_target_libraries_to_library_env_path(): library ${interfaceLinkDependency} will be ignored because it is not a TARGET")
            continue()
          endif()
        endforeach()
      endif(interfaceLinkDependencies)
    endforeach()
  endif(directDependencies)

  # TODO: s.a. WINEPATH
  set(pathName)
  if(APPLE)
    set(pathName "DYLD_LIBRARY_PATH")
  elseif(UNIX)
    set(pathName "LD_LIBRARY_PATH")
  elseif(WIN32)
    set(pathName "PATH")
  else()
    message(FATAL_ERROR "mdt_target_libraries_to_library_env_path(): unknown operating system")
  endif()

  set(currentEnvPath "$ENV{${pathName}}")

  set(envPath)
  if(pathList)
    set(envPath "${pathName}=$<SHELL_PATH${pathList}>")
    if(currentEnvPath)
      string(APPEND envPath ":${currentEnvPath}")
    endif()
  else()
    if(currentEnvPath)
      set(envPath "${pathName}=${currentEnvPath}")
    endif()
  endif()

  set(${out_var} ${envPath} PARENT_SCOPE)

endfunction()


function(mdt_set_test_library_env_path)

  set(options "")
  set(oneValueArgs NAME TARGET)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_NAME)
    message(FATAL_ERROR "mdt_set_test_library_env_path(): mandatory argument NAME missing")
  endif()
  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_set_test_library_env_path(): ${ARG_TARGET} is not a valid target")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_set_test_library_env_path(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  mdt_target_libraries_to_library_env_path(envPath TARGET ${ARG_TARGET})
  if(envPath)
    set_tests_properties(${ARG_NAME} PROPERTIES ENVIRONMENT "${envPath}")
  endif()

endfunction()
