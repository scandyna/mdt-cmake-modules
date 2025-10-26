[[_TOC_]]

# Build MdtCMakeModules

This section describes how to build
to work on MdtCMakeModules.

The examples use the command line.
Because CMake is supported natively by some IDE's,
using those should be relatively easy.

## Tests variants

MdtCMakeModules should work in some contexts.

One context is using a system package manager, like Debian apt,
or no package manager.

Another context is to work with the Conan package manager.

Qt is also a big dependency.
Checking that the modules works with Qt is also important.
For some platforms, Qt is not available and not required.

### Core tests

Checks that the modules works for a platform that does not have Qt,
and has no other dependencies than the common system ones.

### Tests with Qt

Will also check that modules works correctly with Qt,
either installed system wide and in the `PATH`,
or present in the `CMAKE_PREFIX_PATH`.

Note: this context is currently not tested in the CI.
See https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/23

### Tests with Conan

Will also check that modules works correctly when using Conan.

### Tests with Conan and Qt

Will also check that modules works correctly when using Conan
with an important dependencies graph.

## Tools ans libraries

Some tools are required to work on MdtCMakeModules:
 - Git
 - CMake
 - Make (can be other, like Ninja)

Additional tools are required to generate the documentation:
 - Sphinx

To run the tests, those libraries and tools are also required:
 - A compiler: Gcc or Clang or MinGW or MSVC
 - Conan - optional (only required when BUILD_CONAN_TESTS is ON)
 - Qt - Optional (only required when BUILD_QT_TESTS is ON and the build is not based on Conan)

For a overview how to install them, see https://gitlab.com/scandyna/build-and-install-cpp

## Get the source code

Get the sources:
```bash
git clone https://github.com/scandyna/mdt-cmake-modules.git
```

## Build and test - sandbox

TODO: -S .... -B ....

```shell

cmake --preset dev_conan_unix_makefiles_gcc_tests_with_conan ...
cmake --preset dev_conan_unix_makefiles_gcc_tests_with_conan_and_qt ...

OR

cmake --preset dev_unix_makefiles_gcc_tests_with_conan ...
cmake --preset dev_unix_makefiles_gcc_tests_with_conan_and_qt ...
```

## Note for some Linux platforms

Some tests will run ThreadSanitizer (TSan).
Those could fail with some `unexpected memory mapping` error.
To avoid this:
```shell
sudo sysctl vm.mmap_rnd_bits=28
```

See also:
- https://gitlab.com/scandyna/docker-images-ubuntu/-/issues/13


## Build on Linux using Makefiles

```bash
mkdir build && cd build
```

### Configure on Linux for core tests only

```bash
cmake --preset dev_unix_makefiles_gcc13_core_tests_only -DCMAKE_BUILD_TYPE=Debug ..
```

### Configure on Linux for tests with Qt

This will work with a system wide installed Qt:
```bash
cmake --preset dev_unix_makefiles_gcc13_tests_with_qt -DCMAKE_BUILD_TYPE=Debug ..
```

### Configure for tests with Conan


### Configure for tests with Conan and Qt



Configure using the default compiler (gcc):
```bash
mkdir build && cd build
cmake --preset dev_unix_makefiles -DCMAKE_BUILD_TYPE=Debug ..
```

Configure using Clang 6.0 and libc++
```bash
mkdir build && cd build
cmake --preset dev_unix_makefiles_clang_6_0_x86_64_libcpp -DCMAKE_BUILD_TYPE=Debug ..
```

This will use the system wide installed Qt,
which should be fine.

### Build and run tests on Linux using Makefiles

Maybe adjust some settings:
```bash
cmake-gui .
```

Build (will generate the tests):
```bash
make -j4
```

Run the tests:
```bash
ctest --output-on-failure -j4 .
```

## Build on Windows using MinGW

Open a terminal that has gcc and mingw32-make in the PATH.

Configure:
```bash
mkdir build && cd build
cmake --preset dev_mingw_makefiles ..
```

This will probably fail because Qt was not found.

Use cmake-gui to select the path to Qt
and maybe adjust some settings:
```bash
cmake-gui .
```

Build (will generate the tests):
```bash
mingw32-make -j4
```

To run the tests:
```bash
ctest --output-on-failure -j4 .
```

## Build on Windows using MSVC

Configure:
```cmd
mkdir build && cd build
cmake --preset dev_msvc_15_2017_x64 ..
```

This will probably fail because Qt was not found.

Use cmake-gui to select the path to Qt
and maybe adjust some settings:
```bash
cmake-gui .
```

To generate the tests, run the build:
```bash
cmake --build . --config Debug
```

To run the tests:
```bash
ctest --output-on-failure -C Debug -j4 .
```

## Build the documentation on Linux

Configure:
```cmd
mkdir build && cd build
cmake --preset linux_doc ..
```

Build the documentation:
```bash
make documentation
```
