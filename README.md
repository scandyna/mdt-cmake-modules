# mdt-cmake-modules

NOTE TODO add badges to: GitLab CI/CD, AppVeyor CI, Bintray Conan repo/package

Some CMake modules used in my projects

For the available CMake modules and their usage,
see the [documentation page](https://scandyna.gitlab.io/mdt-cmake-modules)

# Install

Some tools are required to install MdtCMakeModules:
 - Git
 - CMake
 - Conan - Optional, only required to create a Conan package

Additional tool are required to generate the documentation:
 - Make
 - Sphinx

To run the unit tests, those libraries and tools are also required:
 - Gcc
 - Qt
 - Conan - Optional

For a overview how to install them, see https://gitlab.com/scandyna/build-and-install-cpp

MdtCMakeModules can be installed by using CMake directly,
or the Conan package manager.

In this section, a build folder is assumed to be in the source tree,
which is only for simplicity.

## Get the source code

Get the sources:
```bash
git clone https://github.com/scandyna/mdt-cmake-modules.git
```

## Install using CMake on Linux (Makefiles)

Configure:
```bash
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/some/path ..
```

The install prefix path could be Linux system wide:
```bash
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
```

Example for a stand-alone install:
```bash
cmake -DCMAKE_INSTALL_PREFIX=~/opt/MdtCMakeModules ..
```

The configuration could also be done using cmake-gui:
```bash
cmake-gui .
```

To generate the documentation and the tests, run the build:
```bash
make -j4
```

To run the tests:
```bash
ctest --output-on-failure .
```

Install the modules:
```bash
make install
```

## Install using CMake on Windows MinGW

Open a terminal that has gcc and mingw32-make in the PATH.

Configure:
```bash
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=C:\some\path ..
```

The configuration could also be done using cmake-gui:
```bash
cmake-gui .
```

To generate the documentation and the tests, run the build:
```bash
mingw32-make -j4
```

To run the tests:
```bash
ctest --output-on-failure .
```

Install the modules:
```bash
mingw32-make install
```

## Install using CMake on Windows MSVC

Configure:
```cmd
mkdir build && cd build
cmake -G "Visual Studio 15 2017" -A x64 -DCMAKE_INSTALL_PREFIX=C:\some\path ..
```

The configuration could also be done using cmake-gui:
```bash
cmake-gui .
```

To generate the tests, run the build:
```bash
cmake --build . --config Release
```

To run the tests:
```bash
ctest --output-on-failure -C Release .
```

Install the modules:
```cmd
cmake --build . --target INSTALL --config Release
```

## Create a Conan package

Get the sources:
```bash
git clone https://github.com/scandyna/mdt-cmake-modules.git
```

Create the package:
```bash
conan create mdt-cmake-modules user/channel
```

# Usage

Add the following to your ``CMakeLists.txt``:
```cmake
find_package(MdtCMakeModules REQUIRED)
```

This will also add the path to the installed MdtCMakeModules
to CMAKE_MODULE_PATH (if not allready exists).

Then the required modules can be used:
```cmake
include(AddQt5ToCMakePrefixPath)
```

## Find MdtCMakeModules with CMake

In your CMakeLists.txt you can provide a cache variable:
```cmake
set(MDT_CMAKE_MODULE_PREFIX_PATH CACHE PATH "Path to the root of MdtCMakeModules. (For example: /opt/MdtCMakeModules).")
if(MDT_CMAKE_MODULE_PREFIX_PATH)
  list(APPEND CMAKE_PREFIX_PATH "${MDT_CMAKE_MODULE_PREFIX_PATH}")
endif()

find_package(MdtCMakeModules REQUIRED)
```

Above method lets the user choose the path to MdtCMakeModules with cmake-gui .

Configuring the project could also be done on the command-line:
```bash
cmake -DMDT_CMAKE_MODULE_PREFIX_PATH=/some/path/MdtCMakeModules ..
```

CMAKE_PREFIX_PATH can also be used directly:
```bash
cmake -DCMAKE_PREFIX_PATH=/some/path/MdtCMakeModules ..
```

It is also possible to not use find_package() and sepcify the path using CMAKE_MODULE_PATH (not recommended):
```bash
cmake -DCMAKE_MODULE_PATH=/some/path/MdtCMakeModules/Modules ..
```

This last method requires to specify exactly where the modules are located.
This will break if the internal directory organisation changes.


## Find MdtCMakeModules with Conan

To use Conan, create a conanfile.txt:
```conan
[requires]
MdtCMakeModules/[>=0.10.6]@scandyna/testing

[generators]
cmake_paths
```

Add the remote:
```bash
conan remote add scandyna https://api.bintray.com/conan/scandyna/public-conan
```

Install the dependencies:
```bash
mkdir build && cd build
conan install ..
```

Configure your project:
```bash
cmake -DCMAKE_TOOLCHAIN_FILE=conan_paths.cmake ..
cmake-gui .
```
