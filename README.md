# mdt-cmake-modules
Some CMake modules used in my projects

# Install

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
make install
```

## Install using Conan




# Usage

Add the following to your ``CMakeLists.txt``:
```cmake
find_package(MdtCMakeModules REQUIRED)
list(APPEND CMAKE_MODULE_PATH "${MDT_CMAKE_MODULE_PATH}")
```

Then the required modules can be used:
```cmake
include(AddQt5ToCMakePrefixPath)
```
