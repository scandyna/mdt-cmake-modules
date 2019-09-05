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
make
make install
```

## Install using Conan




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

## Find MdtCMakeModules from your project

In your CMakeLists.txt you can provide a cache variable:
```cmake
set(MDT_CMAKE_MODULE_PATH CACHE PATH "Path to the root of MdtCMakeModules. (For example: /opt/MdtCMakeModules). If empty, CMAKE_MODULE_PATH is used.")
if(MDT_CMAKE_MODULE_PATH)
  list(APPEND CMAKE_MODULE_PATH "${MDT_CMAKE_MODULE_PATH}")
endif()
```

Above method lets the user choose the path to MdtCMakeModules with cmake-gui .

Configuring the project could also be done on the command-line:
```bash
cmake -DMDT_CMAKE_MODULE_PATH=/some/path ..
```

CMAKE_MODULE_PATH can also be used directly:
```bash
cmake -DCMAKE_MODULE_PATH=/some/path ..
```

Note also that not creating MDT_CMAKE_MODULE_PATH,
but adding the path directly to CMAKE_PREFIX_PATH will work.
Adding the path to CMAKE_MODULE_PATH is also fine.
