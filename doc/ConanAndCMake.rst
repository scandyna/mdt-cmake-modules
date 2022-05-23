.. _conan-and-cmake:

Conan and CMake
===============

.. contents:: Summary
  :local:


Context
^^^^^^^

Some history
""""""""""""

I used the
`cmake_paths generator <https://docs.conan.io/en/latest/reference/generators/cmake_paths.html>`_
because it is not intrusive.
It generates a ``conan_paths.cmake`` file
that adds paths to the dependencies in ``CMAKE_PREFIX_PATH``
(and also other variables and targets).

This file was passed as toolchain file to cmake,
so all the rest is pure CMake.
I can use :command:`find_package()` and targets as usual.

This worked until I had to use Clang with libc++ .
This time, I had to pass a lot of things as arguments to CMake,
that does not scale and is very error prone.

I came back to the
`cmake generator <https://docs.conan.io/en/latest/reference/generators/cmake.html>`_
(which envolved since 2016),
and accepted to make a minimal change in the top level ``CMakeLists.txt``:

.. code-block:: CMake

  if(EXISTS "${CMAKE_BINARY_DIR}/conanbuildinfo.cmake")
    include("${CMAKE_BINARY_DIR}/conanbuildinfo.cmake")
    conan_basic_setup(NO_OUTPUT_DIRS)
  endif()

When calling ``conan_basic_setup()``,
it adds the path of all the dependencies to ``CMAKE_PREFIX_PATH``,
and it also sets some flags, like those required
to use a non default C++ library (libc++ in my case).

I did not change anything else, all worked great.

At this state, I used some packages from
`the Bincrafters <https://bincrafters.github.io>`_ .

Work usually good, but had problems with complex packages, like Qt.

Later, I wanted to use packages from
`Conan center <https://conan.io/center>`_ ,
and discovered important changes in conan.

Using new generators
""""""""""""""""""""

To be able to use packages from
`Conan center <https://conan.io/center>`_ ,
we can't use the ``cmake`` generator anymore.

See also:

- `missing files for CMake find_package() #6035 <https://github.com/conan-io/conan-center-index/issues/6035>`_

The newer
`cmake_find_package <https://docs.conan.io/en/latest/reference/generators/cmake_find_package.html>`_
or
`cmake_find_package_multi <https://docs.conan.io/en/latest/reference/generators/cmake_find_package_multi.html>`_
generators has to be used.

We can also use
`CMakeDeps <https://docs.conan.io/en/latest/reference/conanfile/tools/cmake/cmakedeps.html>`_
together with
`CMakeToolchain <https://docs.conan.io/en/latest/reference/conanfile/tools/cmake/cmaketoolchain.html>`_

Those generators will generate CMake package config files
(or CMake find modules, for ``cmake_find_package``)
at the root of the build tree.

When using them, the ``CMAKE_PREFIX_PATH``
will no longer have paths to the dependencies,
but only contains the current build root.

Also, to avoid claches,
the packages from Conan center removes
the CMake package config files from upstream projects.

This way, it is not possible to use packages from Conan center
with the ``cmake`` generator anymore.

Adapting projects
^^^^^^^^^^^^^^^^^

Conan is really a amazing tool,
and I want to use it for my projects.

But, I also want to be able to use them without Conan.

For example, at some time,
I would provide Debian packages.

For that, the CMake package config files
will always be generated and installed.

For the transition phase,
I also should still support the ``cmake`` generator.

The recipes have to be adapted,
mostly in the ``package_info()`` method.

Here are some documentations usefull to update the recipes:

- The `package-info() <https://docs.conan.io/en/latest/reference/conanfile/methods.html#package-info>`_
  method

- The `cpp-info <https://docs.conan.io/en/latest/reference/conanfile/attributes.html#cpp-info>`_
  attribute

- The `CMakeDeps <https://docs.conan.io/en/latest/reference/conanfile/tools/cmake/cmakedeps.html>`_
  generator which gives a example


MdtCMakeModules
"""""""""""""""

`MdtCMakeModules <https://gitlab.com/scandyna/mdt-cmake-modules>`_
is a set of CMake modules I use in every projects.

After searching for hours, my first attempt was this:

.. code-block:: Python

  def package_info(self):
    self.cpp_info.builddirs = [".","Modules"]

this adds the path to the installed MdtCMakeModules
to ``CMAKE_PREFIX_PATH`` and ``CMAKE_MODULE_PATH``.

In the consumer CMakeLists.txt:

.. code-block:: CMake

  find_package(MdtCMakeModules REQUIRED)

When using conan's ``cmake`` generator (or not Conan at all),
the MdtCMakeModulesConfig.cmake is found
and it adds the required path to ``CMAKE_MODULE_PATH``.

When using a new generator, like ``CMakeDeps``,
the conan generated MdtCMakeModulesConfig.cmake
was found, which  added the required path to ``CMAKE_MODULE_PATH``.

On the CI, all tests passed, seems ok.

Conflict with Mdt0Config.cmake
''''''''''''''''''''''''''''''

To be able to use the CMake component syntax,
a Mdt0Config.cmake is generated.

For more info, see :command:`mdt_install_namespace_package_config_file()`.

While working on a project using MdtCMakeModules,
using conan's ``CMakeDeps`` generator,
this upstream Mdt0Config.cmake was picked up, producing a error.

This is because the path to MdtCMakeModules
was before the root of the build tree in the ``CMAKE_PREFIX_PATH``
(this is probably why upstream provided CMake package config files
are removed in the packages from Conan center).

So, I want to provide my CMake package config files
(for reasons explained above),
but must remove the path to them
when using a new conan generator.

This will be explained below.

Should package root be removed ?
""""""""""""""""""""""""""""""""

This is a discussion about removing the package root from ``CMAKE_PREFIX_PATH``
when using generators like cmake_find_package_multi or CMakeDeps.

Those generators will generate CMake package config files
in the build folder of the user.

They should create TARGETS and attach the required properties,
like ``INTERFACE_INCLUDE_DIRECTORIES``.

Looking at conan's CMakeDeps generated package config files,
the root of the package will be added to ``CMAKE_PREFIX_PATH``
(and also to ``CMAKE_MODULE_PATH``).

Exampe of a generated MdtCMakeModules-debug-x86_64-data.cmake (partial extract):

.. code-block:: CMake

  set(MdtCMakeModules_PACKAGE_FOLDER_DEBUG "/home/me/.conan/data/MdtCMakeModules/0.0.0/scandyna/testing/package/5ab8jkhkjsfe1f23c4fae0ab88f26e3a3963jkjl")
  set(MdtCMakeModules_INCLUDE_DIRS_DEBUG "${MdtCMakeModules_PACKAGE_FOLDER_DEBUG}/include")
  set(MdtCMakeModules_BUILD_DIRS_DEBUG "${MdtCMakeModules_PACKAGE_FOLDER_DEBUG}/")

Exampe of a generated MdtCMakeModules-Target-debug.cmake (partial extract):

.. code-block:: CMake

  # FIXME: What is the result of this for multi-config? All configs adding themselves to path?
  set(CMAKE_MODULE_PATH ${MdtCMakeModules_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})
  set(CMAKE_PREFIX_PATH ${MdtCMakeModules_BUILD_DIRS_DEBUG} ${CMAKE_PREFIX_PATH})

  set_property(TARGET MdtCMakeModules::MdtCMakeModules
              PROPERTY INTERFACE_INCLUDE_DIRECTORIES
              $<$<CONFIG:Debug>:${MdtCMakeModules_INCLUDE_DIRS_DEBUG}> APPEND)

Note: attaching ``INTERFACE_INCLUDE_DIRECTORIES`` to MdtCMakeModules has no sense,
but that's all I have as example for now.

As we can see, adding the package root folder to ``CMAKE_PREFIX_PATH`` seems not so usefull
as long as we use the generated TARGETS (and we should).


MdtDeployUtils
''''''''''''''

`MdtSharedLibrariesDepencyHelpers <https://scandyna.gitlab.io/mdtdeployutils/cmake-api/Modules/MdtSharedLibrariesDepencyHelpers.html>`_
is a CMake helper module from
`MdtDeployUtils <https://gitlab.com/scandyna/mdtdeployutils>`_
to deal with shared libraries.

Current implementation uses ``CMAKE_PREFIX_PATH`` to find shared libraries
when rpath informations are missing.

This should be fixed.

Before ``CMAKE_PREFIX_PATH``, it should use a list of paths
created from all imported targets, using ``$<TARGET_FILE:tgt>``.

Important: it should only add paths to shared libraries,
and only imported targets.
Static libraries, executables and test targets have to be excluded.

Using custom CMake modules
^^^^^^^^^^^^^^^^^^^^^^^^^^

Here we would not discuss if it is good or not
to ship / use our upstream custom CMake package config files.

The thema is how to integrate custom CMake modules,
which can be helpers, like for example
`Qt CMake commands <https://doc.qt.io/qt-6/cmake-command-reference.html>`_
or
`ECMInstallIcons <https://api.kde.org/ecm/module/ECMInstallIcons.html>`_ 
or
`MdtVersionUtils <https://scandyna.gitlab.io/mdt-cmake-modules/Modules/MdtVersionUtils.html>`_ .


The way to add them is to use ``cpp_info.build_modules["generator"]``
and the new ``cpp_info.set_property("cmake_build_modules", ...)``.

There are 2 main problems to solve here:

- It seems not possible to tell Conan to add a path to ``CMAKE_MODULE_PATH``.
  Each module must be a path the the CMake module file.
  Each module will be included using :command:`include()`.
  See also `Can I pass CMake variables from a package using CMakeDeps / CMakeToolchain? #10976 <https://github.com/conan-io/conan/issues/10976>`_
- The path to any given CMake module must be lower case.
  So, reusing existing CamelCase.cmake modules seems not possible.
  Note that I'm possibly wrong here.
  See also `Case insensitive filesystem can't manage this" #1557 <https://github.com/conan-io/conan/issues/1557>`_

Also, I don't want to include every CMake modules.
To use a function, it must be included explicitly by the user,
or a error is thrown by CMake.
Also, what about name clashes ?

Looking in the Qt recipe,
it seems that some workaround is possible.

Note: below examples explains a solution to apply the workaround.
To install your CMake modules, consider :command:`mdt_install_cmake_modules()`,
which does all the CMake side stuff.

A first simple example
""""""""""""""""""""""

First, create a file, for example ``my_project-conan-cmake-modules.cmake``:

.. code-block:: CMake

  # This file is only used by conan generators that generates CMake package config files

  # Remove the root of the package from CMAKE_PREFIX_PATH
  # to avoid clashes when using Conan generated CMake package config files
  # We could have a trailing slash, or not, in CMAKE_PREFIX_PATH
  list(REMOVE_ITEM CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}/")
  list(REMOVE_ITEM CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}")
  # Should also handle Windows back-slash case (on Windows build machine)
  # Did not put it here because Sphinx does not like back-slashes

  list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/Modules")


In the recipe:

.. code-block:: Python

  class MyProjectConan(ConanFile):

    exports_sources = "usual files", "my_project-conan-cmake-modules.cmake"

    def package(self):
      cmake = self._configure_cmake()
      cmake.install()
      self.copy("my_project-conan-cmake-modules.cmake")

    def package_info(self):

      build_modules = ["my_project-conan-cmake-modules.cmake"]

      # This will be used by CMakeDeps
      self.cpp_info.set_property("cmake_build_modules", build_modules)

      # This must be added for other generators
      self.cpp_info.build_modules["cmake_find_package"] = build_modules
      self.cpp_info.build_modules["cmake_find_package_multi"] = build_modules


In above example, ``my_project-conan-cmake-modules.cmake``
is at the root of the source tree, relative to the ``conanfile.py``.

in the ``package()`` method, ``my_project-conan-cmake-modules.cmake``
will be installed to the root of the package.
See also the documentation of the `package() <https://docs.conan.io/en/latest/reference/conanfile/methods.html#package>`_
method to understand ``copy()``.

In the ``package_info()`` method,
we define to find ``my_project-conan-cmake-modules.cmake`` at the root of the package.

In this example, ``my_project-conan-cmake-modules.cmake`` is installed by Conan,
which makes it clear where to find this file in ``package_info()``.

A more flexible example ?
"""""""""""""""""""""""""

In above example, the ``my_project-conan-cmake-modules.cmake`` file
assumes that the CMake modules are allways installed in a predefined path
relative to the package root.

Looking at
`GNUInstallDirs <https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html>`_
,
`MdtInstallDirs <https://scandyna.gitlab.io/mdt-cmake-modules/Modules/MdtInstallDirs.html>`_
and
`MdtInstallCMakeModules <https://scandyna.gitlab.io/mdt-cmake-modules/Modules/MdtInstallCMakeModules.html>`_
we can see that the cmake modules could be installed in a different subdirectory
in the install tree.

But, we can also see the the exception is when installing to a UNIX system wide path,
which will not happen when using Conan packages.

Because we are talking about a Conan specific case,
we should not care here.

Example using a helper function to find paths in a list
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

For above example, in ``my_project-conan-cmake-modules.cmake``,
we had to deal with paths ending with trailing slashes.
We could have paths ending with a slash in the list,
but not in the given path to find, or the reverse case.
We also have to deal with backslashes.

It can be difficult to maintain such code all over the place.
We should use a helper function, like :command:`mdt_find_path_in_list()`.

This adds some packaging complexity explained in the :module:`MdtFindPathInList` module.

Now update ``my_project-conan-cmake-modules.cmake``:

.. code-block:: CMake

  # This file is only used by conan generators that generates CMake package config files

  include("${CMAKE_CURRENT_LIST_DIR}/MyProjectConanMdtFindPathInList.cmake")

  # Remove the root of the package from CMAKE_PREFIX_PATH
  # to avoid clashes when using Conan generated CMake package config files
  MyProjectConan_mdt_find_path_in_list(CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}" PATH_INDEX)
  if(${PATH_INDEX} GREATER_EQUAL 0)
    list(REMOVE_AT CMAKE_PREFIX_PATH ${PATH_INDEX})
  endif()

  # Add the path to our CMake modules if not already
  MyProjectConan_mdt_find_path_in_list(CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/Modules" PATH_INDEX)
  if(${PATH_INDEX} LESS 0)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/Modules")
  endif()

  unset(PATH_INDEX)

Update the (main) ``CMakeLists.txt``:

.. code-block:: CMake

  option(INSTALL_CONAN_PACKAGE_FILES "Install files required for recent conan generators, like CMakeDeps" OFF)

  if(INSTALL_CONAN_PACKAGE_FILES)

    set(MdtFindPathInList_FUNCTION_NAME MyProjectConan_mdt_find_path_in_list)
    configure_file("${MDT_CMAKE_MODULES_PATH}/MdtFindPathInList.cmake.in" MyProjectConanMdtFindPathInList.cmake @ONLY)

    install(
      FILES
        "${CMAKE_BINARY_DIR}/MyProjectConanMdtFindPathInList.cmake"
      DESTINATION .
    )

  endif()

Update the recipe:

.. code-block:: Python

  from conan.tools.cmake import CMake, CMakeToolchain, CMakeDeps

  class MyProjectConan(ConanFile):

    exports_sources = "usual files", "my_project-conan-cmake-modules.cmake"
    generators = "CMakeToolchain", "CMakeDeps"

    def generate(self):
      tc = CMakeToolchain(self)
      tc.variables["INSTALL_CONAN_PACKAGE_FILES"] = "ON"
      tc.generate()

    def package(self):
      cmake = CMake(self)
      cmake.install()

    def package_info(self):

      build_modules = ["my_project-conan-cmake-modules.cmake"]

      # This will be used by CMakeDeps
      self.cpp_info.set_property("cmake_build_modules", build_modules)

      # This must be added for other generators
      self.cpp_info.build_modules["cmake_find_package"] = build_modules
      self.cpp_info.build_modules["cmake_find_package_multi"] = build_modules

Using a custom CMake modules install function
"""""""""""""""""""""""""""""""""""""""""""""

It can be usefull to use a custom function to install CMake modules,
like `MdtInstallCMakeModules <https://scandyna.gitlab.io/mdt-cmake-modules/Modules/MdtInstallCMakeModules.html>`_ .

Despite this is somewhat overengineering, and adds some coupling,
we could generate ``my_project-conan-cmake-modules.cmake``.

This generated file will probably have the same logic as the generated ``MyProjectCMakeModules.cmake`` one, for example.
Note: here we talk about our CMake function generated files, not Conan generated file.

Because ``my_project-conan-cmake-modules.cmake`` is generated by CMake,
it has to be installed by CMake.

Here, the helper function should be clear about where ``my_project-conan-cmake-modules.cmake``
will be installed.

The simplest is to put it at the root of the package.

In this case, the interresting parts of the ``conanfile.py`` could look like:

.. code-block:: Python

  class MyProjectConan(ConanFile):

    exports_sources = "usual files"

    def package(self):
      cmake = self._configure_cmake()
      cmake.install()

    def package_info(self):

      build_modules = ["my_project-conan-cmake-modules.cmake"]

      # This will be used by CMakeDeps
      self.cpp_info.set_property("cmake_build_modules", build_modules)

      # This must be added for other generators
      self.cpp_info.build_modules["cmake_find_package"] = build_modules
      self.cpp_info.build_modules["cmake_find_package_multi"] = build_modules


Tool requirements
^^^^^^^^^^^^^^^^^

When using generators like ``CMakeDeps`` and the recommanded
build and host profile as arguments to conan,
the recipe has to be adapted in the tools requirements.

.. code-block:: Python

  MyPkg(ConanFile)
    # Old variant
    #build_requires = "MdtCMakeModules/0.17.1@scandyna/testing"
    tool_requires = "MdtCMakeModules/0.17.1@scandyna/testing"
    generators = "CMakeDeps", "CMakeToolchain"


When using ``--profile:build xx`` and ``--profile:host xx`` like this:

.. code-block:: shell

  conan create . --profile:build xx and --profile:host xx

the dependencies declared in ``build_requires`` and ``tool_requires``
will not generate the required files.

We have to declare those in the ``build_requirements()`` method
and use the ``force_host_context`` argument:

.. code-block:: Python

  def build_requirements(self):
    self.tool_requires("MdtCMakeModules/0.17.1@scandyna/testing", force_host_context=True)

See also:

- https://github.com/conan-io/conan/issues/9951
- https://docs.conan.io/en/latest/migrating_to_2.0/recipes.html#requirements
- https://github.com/conan-io/conan/issues/10272
