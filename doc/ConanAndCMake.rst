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
is a set of CMake modules I use in evry projects.

After searching for houres, my first attempt was this:

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
was found, wihich one added the required path to ``CMAKE_MODULE_PATH``.

On the CI, all tests passed, seems ok.

Conflict with Mdt0Config.cmake
''''''''''''''''''''''''''''''

To be able to use the CMake component syntax,
a Mdt0Config.cmake is generated.

For more info, see :command:`mdt_install_namespace_package_config_file()`.

While working on a project using MdtCMakeModules,
using conan's ``CMakeDeps`` generator,
the Mdt0Config.cmake was picked up, producing a error.

This is because the path to MdtCMakeModules
was before the root of the build tree in the ``CMAKE_PREFIX_PATH``
(this is probably why upstream provided CMake package config files
are removed in the packages from Conan center).

So, I want to provide my CMake package config files
(for reasons explained above),
but must remove the path to them
when using a new conan generator.

This will be explained below.

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
  Each module will be include using :command:`include()`.
  See also `Can I pass CMake variables from a package using CMakeDeps / CMakeToolchain? #10976 <https://github.com/conan-io/conan/issues/10976>`_
- The path to any given CMake module must be lower case.
  So, reusing existing CamelCase.cmake modules seems not possible.
  Note that I'm possibly wrong here.
  See also `Case insensitive filesystem can't manage this" #1557 <https://github.com/conan-io/conan/issues/1557>`_

So, I don't want to include every CMake modules.
To use a function, it must be included explicitly by the user,
or a error is thrown by CMake.
Also, what about name clashes ?

Looking in the Qt recipe,
it seems that some workaround is possible.

First, create a file, for example ``my-project-conan-cmake-modules.cmake``:

.. code-block:: CMake

  # This file is only used by conan generators the generates CMake package config files

  # TODO: must I remove this ?
  # TODO: below does not work
  # list(REMOVE_ITEM CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}")

  list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/Modules")

Then, in the recipe:

.. code-block:: Python

  def package_info(self):

    build_modules = ["my-project-conan-cmake-modules.cmake"]

    # This will be used by CMakeDeps
    self.cpp_info.set_property("cmake_build_modules", build_modules)

    # This must be added for other generators
    # TODO: cmake paths ??
    self.cpp_info.build_modules["cmake_paths"] = build_modules
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
