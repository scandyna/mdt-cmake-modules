# mdt-cmake-modules
Some CMake modules used in my projects

# Install

MdtCMakeModules can be installed by using CMake directly,
or the Conan package manager.

In this section, a build folder is assumed to be in the source tree,
which is only for simplicity.

## Install using CMake

Get the sources:
```bash
git clone https://github.com/scandyna/mdt-cmake-modules.git
```

Configure:
```bash
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/some/path ..
```

The configuration could also be done using cmake-gui:
```bash
cmake-gui .
```

Install the modules:
```bash
make
make install
```

## Install using Conan

This part has only sense to work on MdtCMakeModules itself.

Get the sources:
```bash
git clone https://github.com/scandyna/mdt-cmake-modules.git
```

Install the modules:
```bash
mkdir build && cd build
conan create ..
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
set(MDT_CMAKE_MODULE_PREFIX_PATH CACHE PATH "Path to the root of MdtCMakeModules. (For example: /opt/MdtCMakeModules). If empty, CMAKE_MODULE_PATH is used.")
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

It is also possible to not use find_package() and sepcify the path using CMAKE_MODULE_PATH (not recommanded):
```bash
cmake -DCMAKE_MODULE_PATH=/some/path/MdtCMakeModules/Modules ..
```

This last method requires to specify exactly where the modules are located.
This will break if the internal directory organisation changes.


## Find MdtCMakeModules with Conan

To use Conan, create a conanfile.txt:
```conan
[requires]
MdtCMakeModules/0.1@scandyna/testing

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
