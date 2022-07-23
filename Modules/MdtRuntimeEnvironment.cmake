# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# MdtRuntimeEnvironment
# ---------------------
#
# .. contents:: Summary
#    :local:
#
# Some test utilities
# ^^^^^^^^^^^^^^^^^^^
#
# .. command:: mdt_append_test_environment_variables_string
#
# Add a string of variables to the end of the ``ENVIRONMENT`` property of a test::
#
#   mdt_append_test_environment_variables_string(test variables_string)
#
# Example:
#
# .. code-block:: cmake
#
#   mdt_append_test_environment_variables_string(SomeTest "var1=value1;var2=value2")
#
# The `VARIABLES_STRING` is not parsed, but appended as is to the ``ENVIRONMENT`` property of the test.
# See next sections to understand this choice.
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
# Note: this will only work once all targets the test depends on have been entirely processed.
#
# A workaround is to add the missing dependencies directly to the test executable.
#
# A attempt to provide a function that sets the ``ENVIRONMENT`` for each tests that have been added to a project was made.
# Sadly, I found no way to set a test property to a test defined in a other directory than the test was created from.
#
# See also :command:`mdt_target_libraries_to_library_env_path()`
#
# See also https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/4
#
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
#
# .. command:: mdt_target_libraries_to_library_env_path
#
# Get a list of generator expression that will expand to the directory for each dependency of a target::
#
#   mdt_target_libraries_to_library_env_path(<out_var> TARGET <target> [ALWAYS_USE_SLASHES])
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
# ``myAppEnv`` will contain a list of generator expression to build a environment path.
#
#
# On Linux::
#
#   LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>
#
# If ``CMAKE_LIBRARY_PATH`` is not empty, it will be added after the targets generator expressions.
#
# If ``LD_LIBRARY_PATH`` was already set, for example to ``/opt/qt/5.15.2/gcc_64/lib`` it will also be added to the end::
#
#   LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:/opt/qt/5.15.2/gcc_64/lib
#
#
# On Windows::
#
#   PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>;$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>
#
# If ``CMAKE_LIBRARY_PATH`` is not empty, it will be added after the targets generator expressions.
#
# If ``PATH`` was already set, for example to ``C:\Qt\5.15.2\mingw73_64\bin``, it will also be added to the end::
#
#   PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>;$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>;C:\Qt\5.15.2\mingw73_64\bin
#
#
# If the ``ALWAYS_USE_SLASHES`` is present, the resulting environment variable will have slahes as separators on Windows.
# This can be used to prevent `Invalid escape sequence \\U` warning
# (see also https://stackoverflow.com/questions/13737370/cmake-error-invalid-escape-sequence-u/28565713).
#
#
# Example using cmake -E env:
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
#   mdt_target_libraries_to_library_env_path(myAppEnv TARGET myApp ALWAYS_USE_SLASHES)
#   if(WIN32)
#     string(REPLACE ";" "\\;" myAppEnv "${myAppEnv}")
#   endif()
#
#   add_custom_target(
#     runMyApp ALL
#     COMMAND "${CMAKE_COMMAND}" -E env ${myAppEnv} $<TARGET_FILE:myApp>
#   )
#   add_dependencies(runMyApp myApp)
#
# Notice that we have to replace the ``;`` by ``\\;`` on Windows.
# To know why, see below.
#
# See also: :command:`mdt_set_test_library_env_path()`
#
# Note about the implementation
# """""""""""""""""""""""""""""
#
# Notice that the ``$<SHELL_PATH:...>`` is able to handle a whole expression, so this works on Linux (also on CMake 3.10, despite it is not documented)::
#
#   LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>:$<TARGET_FILE_DIR:Mdt0::ItemModel>:$ENV{LD_LIBRARY_PATH}>
#
# Above expression can also work on Windows::
#
#   PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>$<SEMICOLON>$<TARGET_FILE_DIR:Mdt0::ItemModel>$<SEMICOLON>$ENV{PATH}>
#
# With above expression, problems begin when we want to attach it to a property:
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
#   add_test(NAME RunMyApp COMMAND myApp)
#   set_tests_properties(RunMyApp PROPERTIES ENVIRONMENT "${myAppEnv}")
#
# On Windows, all paths will be properly generated.
# See a generated ``CTestTestfile.cmake`` as example:
#
# .. code-block:: cmake
#
#   set_tests_properties(RunMyApp
#     PROPERTIES
#       ENVIRONMENT "PATH=C:\\opt\\MdtItemEditor\\bin;C:\\opt\\MdtItemModel\\bin;C:\\Qt\\5.13.1\\mingw73_32\\bin;C:\\Qt\\Tools\\mingw730_32\\bin"
#   )
#
# But, this cause a problem, due to the ``;``.
# The test will only have the first path as ``ENVIRONMENT`` property.
# All other paths will be affected as a other property, without any key.
#
# This is the reason :command:`mdt_target_libraries_to_library_env_path()`
# generates a list of generator expression, separated by the target OS native separator.
#
# This way, it is then possible to escape the ``;`` on Windows,
# at the time we want to attach it as a property of a test:
#
# .. code-block:: cmake
#
#   string(REPLACE ";" "\\;" myAppEnv "${myAppEnv}")
#
# See also: https://cmake.org/pipermail/cmake/2009-May/029425.html
#
# It was also tempted to do the replace in :command:`mdt_target_libraries_to_library_env_path()`,
# but this did not work, because CMake removes the ``\``.
#
# Here is a example to demonstrate that:
#
# .. code-block:: cmake
#
#   function(try_replace out_var)
#
#     set(someVar "A;B;C")
#     string(REPLACE ";" "\\;" someVar "${someVar}")
#
#     set(${out_var} ${someVar} PARENT_SCOPE)
#
#   endfunction()
#
#   set(testVar)
#   try_replace(testVar)
#   message(testVar: ${testVar})
#
# Above example will print ``A;B;C``, or ``ABC``, but not ``A\;B\;C``.
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

include(MdtTargetDependenciesHelpers)


function(mdt_append_test_environment_variables_string test_name)

  if(${ARGC} LESS 2)
    message(FATAL_ERROR "mdt_append_test_environment_variables_string(): expected a test name and a variables string")
  endif()

  if(NOT test_name)
    message(FATAL_ERROR "mdt_append_test_environment_variables_string(): test name argument missing")
  endif()

  get_test_property(${test_name} ENVIRONMENT testEnvirnoment)
  if(testEnvirnoment)
    set(testEnvirnoment "${testEnvirnoment};${ARGN}")
  else()
    set(testEnvirnoment "${ARGN}")
  endif()

  set_tests_properties(${test_name} PROPERTIES ENVIRONMENT "${testEnvirnoment}")

endfunction()


function(mdt_target_libraries_to_library_env_path out_var)

  set(options ALWAYS_USE_SLASHES)
  set(oneValueArgs TARGET)
  set(multiValueArgs "")
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR "mdt_target_libraries_to_library_env_path(): ${ARG_TARGET} is not a valid target")
  endif()
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "mdt_target_libraries_to_library_env_path(): unknown arguments passed: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  mdt_collect_shared_libraries_targets_target_depends_on(sharedLibrariesDependencies TARGET ${ARG_TARGET})

  if(WIN32 AND ARG_ALWAYS_USE_SLASHES)
    foreach(sharedLibraryDependency ${sharedLibrariesDependencies})
        list(APPEND pathList "$<TARGET_FILE_DIR:${sharedLibraryDependency}>")
    endforeach()
  else()
    foreach(sharedLibraryDependency ${sharedLibrariesDependencies})
      list(APPEND pathList "$<SHELL_PATH:$<TARGET_FILE_DIR:${sharedLibraryDependency}>>")
    endforeach()
  endif()

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

  set(pathSeparator)
  if(WIN32)
    set(pathSeparator ";")
  else()
    set(pathSeparator ":")
  endif()

  set(cmakeLibraryPath "${CMAKE_LIBRARY_PATH}")
  if(UNIX)
    string(REPLACE ";" "${pathSeparator}" cmakeLibraryPath "${cmakeLibraryPath}")
  endif()

  set(currentEnvPath "$ENV{${pathName}}")

  if(WIN32 AND ARG_ALWAYS_USE_SLASHES)
    string(REPLACE "\\" "/" currentEnvPath "${currentEnvPath}")
    string(REPLACE "\\" "/" cmakeLibraryPath "${cmakeLibraryPath}")
  endif()

  set(envPathList)
  list(LENGTH pathList pathListSize)
  if(${pathListSize} GREATER 0)
    list(GET pathList 0 firstPath)
    list(REMOVE_AT pathList 0)
    set(envPathList "${firstPath}")
    foreach(path ${pathList})
      string(APPEND envPathList "${pathSeparator}${path}")
    endforeach()
  endif()

  set(envPathContent)
  if(envPathList)
    string(APPEND envPathContent "${envPathList}")
  endif()
  if(cmakeLibraryPath)
    if(envPathContent)
      string(APPEND envPathContent "${pathSeparator}")
    endif()
    string(APPEND envPathContent "${cmakeLibraryPath}")
  endif()
  if(currentEnvPath)
    if(envPathContent)
      string(APPEND envPathContent "${pathSeparator}")
    endif()
    string(APPEND envPathContent "${currentEnvPath}")
  endif()

  set(envPath "${pathName}=${envPathContent}")

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
  if(WIN32)
    string(REPLACE ";" "\\;" envPath "${envPath}")
  endif()
  if(envPath)
#     set_tests_properties(${ARG_NAME} PROPERTIES ENVIRONMENT "${envPath}")
    mdt_append_test_environment_variables_string(${ARG_NAME} "${envPath}")
  endif()

endfunction()
