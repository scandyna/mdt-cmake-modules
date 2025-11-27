MdtRuntimeEnvironment
---------------------

.. contents:: Summary
   :local:

Some test utilities
^^^^^^^^^^^^^^^^^^^

.. command:: mdt_append_test_environment_modification_property_variables_string

Requires at least CMake 3.22.

Add a string of variables to the end of the ``ENVIRONMENT_MODIFICATION`` property of a test::

  mdt_append_test_environment_modification_property_variables_string(SomeTest "VAR1=OP:value1;VAR2=OP:value2")

  new_alternate_f(NAME <test-name> VARIABLE <variable-name> VALUE_STRING <string>)


Example:

.. code-block:: cmake

  mdt_append_test_environment_modification_property_variables_string(SomeTest
    "LD_LIBRARY_PATH=path_list_prepend:$<SHELL_PATH:/some/path/one;$<TARGET_FILE_DIR:SomeLibraryTarget>>:$ENV{LD_LIBRARY_PATH}"
  )

  new_alternate_f(NAME SomeTest
    VARIABLE
      LD_LIBRARY_PATH
    VALUE_STRING
      "$<SHELL_PATH:/some/path/one;$<TARGET_FILE_DIR:SomeLibraryTarget>>:$ENV{LD_LIBRARY_PATH}"
  )


Is equivalent to:

.. code-block:: cmake

  set_tests_properties(SomeTest
    PROPERTIES
      ENVIRONMENT_MODIFICATION
        "LD_LIBRARY_PATH=path_list_prepend:$<SHELL_PATH:/some/path/one;$<TARGET_FILE_DIR:SomeLibraryTarget>>:$ENV{LD_LIBRARY_PATH}"
  )

If the ``ENVIRONMENT_MODIFICATION`` property was not empty,
the given string will simply be appended.


.. command:: mdt_append_test_environment_variables_string

This function is deprecated, consider :command:`new_alternate_f()`.

Add a string of variables to the end of the ``ENVIRONMENT`` property of a test::

  mdt_append_test_environment_variables_string(test variables_string)

Example:

.. code-block:: cmake

  mdt_append_test_environment_variables_string(SomeTest "var1=value1;var2=value2")

The `VARIABLES_STRING` is not parsed, but appended as is to the ``ENVIRONMENT`` property of the test.
See next sections to understand this choice.


.. command:: mdt_set_test_library_env_path

Set the ``ENVIRONMENT`` property to a test with paths
to the libraries the test links to::

  mdt_set_test_library_env_path(NAME <test-name> TARGET <test-target>)

Will get the libraries defined in the ``LINK_LIBRARIES`` property of ``test-target``,
then the ``INTERFACE_LINK_LIBRARIES`` for each dependency.

Example:

.. code-block:: cmake

  add_executable(myApp main.cpp)

  target_link_libraries(myApp
    PRIVATE Mdt0::ItemEditor
  )

  add_test(NAME RunMyApp COMMAND myApp)
  mdt_set_test_library_env_path(NAME RunMyApp TARGET myApp)

This will set the ``ENVIRONMENT`` property to the test like this:

.. code-block:: cmake

  set_tests_properties(RunMyApp
    PROPERTIES
      ENVIRONMENT
        "LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:$ENV{LD_LIBRARY_PATH}"
  )

Note: this will only work once all targets the test depends on have been entirely processed.

A workaround is to add the missing dependencies directly to the test executable.

A attempt to provide a function that sets the ``ENVIRONMENT`` for each tests that have been added to a project was made.
Sadly, I found no way to set a test property to a test defined in a other directory than the test was created from.

See also :command:`mdt_target_libraries_to_library_env_path()`

See also https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/4


.. command:: mdt_modify_test_library_env_path

Requires at least CMake 3.22.

Set the ``ENVIRONMENT_MODIFICATION`` property to a test with paths
to the libraries the test links to::

  mdt_modify_test_library_env_path(NAME <test-name> TARGET <test-target>)

This function is similar to :command:`mdt_set_test_library_env_path()`,
but it uses ``ENVIRONMENT_MODIFICATION`` for reasons explained below.

Example:

.. code-block:: cmake

  add_executable(myApp main.cpp)

  target_link_libraries(myApp
    PRIVATE Mdt0::ItemEditor
  )

  add_test(NAME RunMyApp COMMAND myApp)
  mdt_modify_test_library_env_path(NAME RunMyApp TARGET myApp)

This will set the ``ENVIRONMENT_MODIFICATION`` property to the test like this:

.. code-block:: cmake

  set_tests_properties(RunMyApp
    PROPERTIES
      ENVIRONMENT_MODIFICATION
        "LD_LIBRARY_PATH=path_list_prepend:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:$ENV{LD_LIBRARY_PATH}"
  )



Some details about test environment properties
""""""""""""""""""""""""""""""""""""""""""""""

When setting the ``ENVIRONMENT`` property of a test,
`ctest` will ignore the environment variables set at runtime.

As an example, `cmake` configure step is done with an empty, or incomplete, ``LD_LIBRARY_PATH`` and/or ``PATH``.
At this stage, the build system is generated, and the ``ENVIRONMENT`` property is set to a given test.
Later, the tests are executed in another runtime environment.
This time, the environment variable ``LD_LIBRARY_PATH`` and/or ``PATH`` is/are complete.
Because the ``ENVIRONMENT`` property was set, the runtime environment will be ignored for the test,
and it will probably fail (typically because of missing shared libraries).

Setting ``ENVIRONMENT_MODIFICATION`` property to a test will avoid this issue,
because it will be extended with the runtime environment.

A practical example is testing a package with Conan:

.. code-block:: python

  def build(self):
    cmake = CMake(self)
    # Here, environment variables like LD_LIBRARY_PATH, PATH, may be empty or incomplete for runtime
    cmake.configure()
    cmake.build()

  def test(self):
    cmake = CMake(self)
    # Conan will set runtime environment with variables like PATH, LD_LIBRARY_PATH
    cmake.ctest(cli_args=["--output-on-failure", "-V"])

See also: https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/25


Using installed shared libraries in your development
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Introduction
""""""""""""

On Linux, only using system wide installed libraries
will not cause any problem.

In practice, libraries that are not available on the system
(for example the latest version of Qt5) will be installed
in a directory that is not known by the loader.

When developping your own libraries,
you probably not want to install them system wide.

By using CMake on Linux, depending on one package
providing shared libraries in one directory will not cause problems.

Take a (simplified) Qt5 installation as example::

  ~/opt
     |-Qt5
        |-5.13.1
            |gcc_64
                |-lib
                   |-cmake
                   |-libQt5Core.so
                   |-libQt5Gui.so
                   |-libQt5Widgets.so

Your project depends on Qt5 Widgets:

.. code-block:: cmake

  find_package(Qt5 COMPONENTS Widgets REQUIRED)
  add_executable(myApp source.cpp)
  target_link_libraries(myApp Qt5::Widgets)

On Linux, ``myApp`` will build and run in the build tree out of the box.

This is because CMake handles the ``RPATH``.
``myApp`` will have a entry in its ``RUNPATH`` pointing to the absolute path
of the installed Qt5 library (for example ``/home/you/opt/Qt5/5.13.1/gcc_64/lib``).

You can experiment it with ``objdump``::

  objdump -x myApp | less

While ``myApp`` depends on ``libQt5Widgets.so``,
``libQt5Widgets.so`` itself also depends on ``libQt5Gui.so``,
``libQt5Core.so`` and other shared libraries.
All of those dependencies are resolved at runtime
because Qt5's libraries are shipped with their ``RUNPATH`` pointing to ``$ORIGIN``.

Problems comes when installing different projects,
providing shared libraries, in different locations.
This is, for example, the case when using a package manager like
`Conan <https://conan.io/>`_ .

Lets take a example of 2 installed libraries::

  ~opt
    |-MdtItemModel
    |    |-lib
    |       |-cmake
    |       |-libMdt0ItemModel.so
    |
    |-MdtItemEditor
         |-lib
            |-cmake
            |-libMdt0ItemEditor.so

Here, ``MdtItemEditor`` depends on ``MdtItemModel``.

Your project depends on MdtItemEditor:

.. code-block:: cmake

  find_package(Mdt0 COMPONENTS ItemEditor REQUIRED)
  add_executable(myApp source.cpp)
  target_link_libraries(myApp Mdt0::ItemEditor)

The dependencies are resolved transitively,
so we don't care about finding ``MdtItemModel``
(and its own dependencies) ourselve.

On Linux, CMake will generate a build system that can build ``myApp``.

This time, running ``myApp`` in the build tree will fail.
This is because ``libMdt0ItemEditor.so`` cannot find ``libMdt0ItemModel.so``.

For the final application, a solution is to copy each shared library
to a common directory.

While working on a library or a application,
setting temporary environment paths can help, at least to execute the unit tests.


Using environment path as CMake property
""""""""""""""""""""""""""""""""""""""""

Also adapt documentation for mdt_add_test(), mdt_set_test_library_env_path()

.. command:: mdt_target_libraries_to_library_env_path


Get a list of generator expression that will expand to the directory for each dependency of a target::

  mdt_target_libraries_to_library_env_path(<out_var> TARGET <target> [ALWAYS_USE_SLASHES] [PATH_LIST_VALUE_STRING_PREFIX <string>])

Example:

.. code-block:: cmake

  add_executable(myApp main.cpp)

  target_link_libraries(myApp
    PRIVATE Mdt0::ItemEditor
  )

  set(myAppEnv)
  mdt_target_libraries_to_library_env_path(myAppEnv TARGET myApp)

``myAppEnv`` will contain a list of generator expression to build a environment path.


On Linux::

  LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>

If ``LD_LIBRARY_PATH`` was already set, for example to ``/opt/qt/5.15.2/gcc_64/lib`` it will also be added to the end::

  LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>:/opt/qt/5.15.2/gcc_64/lib


On Windows::

  PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>;$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>

If ``PATH`` was already set, for example to ``C:\Qt\5.15.2\mingw73_64\bin``, it will also be added to the end::

  PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>;$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>;C:\Qt\5.15.2\mingw73_64\bin


A prefix can also be inserted at the beginning of the path list string:

.. code-block:: cmake

  mdt_target_libraries_to_library_env_path(myAppEnv TARGET myApp PATH_LIST_VALUE_STRING_PREFIX "path_list_prepend:")

resulting to (Linux example)::

  LD_LIBRARY_PATH=path_list_prepend:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>>:$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemModel>>

This format can be used for the ``ENVIRONMENT_MODIFICATION`` test property.

When using the Conan 1 package manager, the `conanbuildinfo.txt` can also be used.
On Unix, the paths of the `[libdirs]` section will be added,
or those from the `[bindirs]` section on Windows.
The `conanbuildinfo.txt` will be located in ``CMAKE_PREFIX_PATH``,
which will be set by the ``CMakeToolchain`` Conan generator.
Alternatively, a variable named ``MDT_CONAN_BUILD_INFO_FILE_PATH``
can be set to a absolute file path to the `conanbuildinfo.txt`.
See also :command:`mdt_get_shared_libraries_directories_from_conanbuildinfo_if_exists()`
This does no longer work with Conan 2.
See https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/22

If the ``ALWAYS_USE_SLASHES`` is present, the resulting environment variable will have slahes as separators on Windows.
This can be used to prevent `Invalid escape sequence \\U` warning
(see also https://stackoverflow.com/questions/13737370/cmake-error-invalid-escape-sequence-u/28565713).


Example using cmake -E env:

.. code-block:: cmake

  add_executable(myApp main.cpp)

  target_link_libraries(myApp
    PRIVATE Mdt0::ItemEditor
  )

  set(myAppEnv)
  mdt_target_libraries_to_library_env_path(myAppEnv TARGET myApp ALWAYS_USE_SLASHES)
  if(WIN32)
    string(REPLACE ";" "\\;" myAppEnv "${myAppEnv}")
  endif()

  add_custom_target(
    runMyApp ALL
    COMMAND "${CMAKE_COMMAND}" -E env ${myAppEnv} $<TARGET_FILE:myApp>
  )
  add_dependencies(runMyApp myApp)

Notice that we have to replace the ``;`` by ``\\;`` on Windows.
To know why, see below.

See also :command:`mdt_collect_shared_libraries_targets_target_depends_on()`,
where some limitations are documented.


Note about the implementation
"""""""""""""""""""""""""""""

TODO: review this section about ``$<SHELL_PATH:...>``.
Since CMake 3.14, it should accept a semicolon-separated list of paths
and replace them to the target platform seperator.

Notice that the ``$<SHELL_PATH:...>`` is able to handle a whole expression, so this works on Linux (also on CMake 3.10, despite it is not documented)::

  LD_LIBRARY_PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>:$<TARGET_FILE_DIR:Mdt0::ItemModel>:$ENV{LD_LIBRARY_PATH}>

Above expression can also work on Windows::

  PATH=$<SHELL_PATH:$<TARGET_FILE_DIR:Mdt0::ItemEditor>$<SEMICOLON>$<TARGET_FILE_DIR:Mdt0::ItemModel>$<SEMICOLON>$ENV{PATH}>

With above expression, problems begin when we want to attach it to a property:

.. code-block:: cmake

  add_executable(myApp main.cpp)

  target_link_libraries(myApp
    PRIVATE Mdt0::ItemEditor
  )

  set(myAppEnv)
  mdt_target_libraries_to_library_env_path(myAppEnv TARGET myApp)

  add_test(NAME RunMyApp COMMAND myApp)
  set_tests_properties(RunMyApp PROPERTIES ENVIRONMENT "${myAppEnv}")

On Windows, all paths will be properly generated.
See a generated ``CTestTestfile.cmake`` as example:

.. code-block:: cmake

  set_tests_properties(RunMyApp
    PROPERTIES
      ENVIRONMENT "PATH=C:\\opt\\MdtItemEditor\\bin;C:\\opt\\MdtItemModel\\bin;C:\\Qt\\5.13.1\\mingw73_32\\bin;C:\\Qt\\Tools\\mingw730_32\\bin"
  )

But, this cause a problem, due to the ``;``.
The test will only have the first path as ``ENVIRONMENT`` property.
All other paths will be affected as a other property, without any key.

This is the reason :command:`mdt_target_libraries_to_library_env_path()`
generates a list of generator expression, separated by the target OS native separator.

This way, it is then possible to escape the ``;`` on Windows,
at the time we want to attach it as a property of a test:

.. code-block:: cmake

  string(REPLACE ";" "\\;" myAppEnv "${myAppEnv}")

See also: https://cmake.org/pipermail/cmake/2009-May/029425.html

It was also tempted to do the replace in :command:`mdt_target_libraries_to_library_env_path()`,
but this did not work, because CMake removes the ``\``.

Here is a example to demonstrate that:

.. code-block:: cmake

  function(try_replace out_var)

    set(someVar "A;B;C")
    string(REPLACE ";" "\\;" someVar "${someVar}")

    set(${out_var} ${someVar} PARENT_SCOPE)

  endfunction()

  set(testVar)
  try_replace(testVar)
  message(testVar: ${testVar})

Above example will print ``A;B;C``, or ``ABC``, but not ``A\;B\;C``.

Using environment path in the terminal
""""""""""""""""""""""""""""""""""""""

To run a executable from the shell, without running CTest,
a environment can be set using Conan.

For example, see `Conan env_info <https://docs.conan.io/en/latest/reference/conanfile/methods.html#method-package-info-env-info>`_ .

In the recipe of each library, define environment in the package_info:

.. code-block:: python

  def package_info(self):
    self.env_info.LD_LIBRARY_PATH.append(os.path.join(self.package_folder, "lib"))
    self.env_info.PATH.append(os.path.join(self.package_folder, "bin"))

Then, in your project, in the conanfile.txt, add the
`VirtualRunEnv <https://docs.conan.io/en/latest/reference/conanfile/tools/env/virtualrunenv.html>`_ generator:

.. code-block:: text

  [generators]
  CMakeDeps
  CMakeToolchain
  VirtualRunEnv


In the build directory, activate the runtime environment:

.. code-block:: shell

  conan install ...
  source conanrun.sh  # On Windows: .\conanrun.bat
  cmake ...

To restore the original environment:

.. code-block:: shell

  source deactivate_conanrun.sh  # On Windows: .\deactivate_conanrun.bat

See also: :command:`mdt_set_test_library_env_path()`

Rationale
^^^^^^^^^

Using Conan package manager
"""""""""""""""""""""""""""

Using legacy generators like `cmake` worked for libraries providing CMake packages.
The given targets had the required informations to create a generator expression
to extract the path to the shared libraries as explained above.

The problem occurs for libraries not providing CMake packages.
Also, the upstream created CMake packages did probably not work
properly in a context of a whole dependency tree
(typically SomeLibConfig.cmake should define find_package() calls for its dependencies).

This is probably why Conan decided to generate the CMake package config files itself
when using the new CMake generators, like CMakeDeps.

But, there is a problem with those new CMake generators:
the generated targets are not usable.
For more details, see :command:`mdt_collect_shared_libraries_targets_target_depends_on()`.

A idea was to use the environment set by Conan's ``VirtualRunEnv`` generated scripts.

The imagined workflow was:

.. code-block:: shell

  conan install ...
  source conanrun.sh  # On Windows: .\conanrun.bat
  cmake ...
  source deactivate_conanrun.sh  # On Windows: .\deactivate_conanrun.bat
  make

mdt_set_test_library_env_path() could then reuse environment variables like ``LD_LIBRARY_PATH`` or ``PATH``.

An issue is that make could call camke, this time without the Conan's environment.
After that, the environment attached to the tests will not contain
the paths to the shared libraries directory for the dependencies.

An other idea was to call the generated scripts from ``execute_process()``.
Implementing this on Linux seems not possible,
because the Bash built-in `source` function must be used.
Calling:

.. code-block:: shell

  source conanrun.sh

from CMake does not work.
See also https://stackoverflow.com/questions/29053977/cmake-execute-process-cannot-find-source-command
