[[_TOC_]]

# Build MdtCMakeModules

This section describes how to build
to work on MdtCMakeModules.

The examples use the command line.
Because CMake is supported natively by some IDE's,
using those should be relatively easy.

## Tools ans libraries

Some tools are required to work on MdtCMakeModules:
 - Git
 - CMake
 - Make (can be other, like Ninja)

Additional tools are required to generate the documentation:
 - Sphinx

To run the unit tests, those libraries and tools are also required:
 - Gcc
 - Qt - Optional (only required when BUILD_QT_TESTS is ON)

For a overview how to install them, see https://gitlab.com/scandyna/build-and-install-cpp

## Get the source code

Get the sources:
```bash
git clone https://github.com/scandyna/mdt-cmake-modules.git
```

## Build on Linux using Makefiles

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
