# mdt-cmake-modules

Some CMake modules used in my projects

[![pipeline status](https://gitlab.com/scandyna/mdt-cmake-modules/badges/experimental/pipeline.svg)](https://gitlab.com/scandyna/mdt-cmake-modules/-/pipelines/latest)

[[_TOC_]]

# Usage

Add the following to your ``CMakeLists.txt``:
```cmake
find_package(MdtCMakeModules REQUIRED)
```

This will also add the path to the installed MdtCMakeModules
to ``CMAKE_MODULE_PATH`` (if not allready exists).

Then the required modules can be used:
```cmake
include(AddQt5ToCMakePrefixPath)
```

For the available CMake modules and their usage,
see the [documentation page](https://scandyna.gitlab.io/mdt-cmake-modules)

## Project using Conan

If you use [Conan](https://conan.io/),
add MdtCMakeModules as requirement:
```conan
[tool_requires]
MdtCMakeModules/x.y.z@scandyna/testing

[generators]
CMakeDeps
CMakeToolchain
```

Add the remote:
```bash
conan remote add gitlab https://gitlab.com/api/v4/projects/25668674/packages/conan
```

Install the dependencies:
```bash
mkdir build && cd build
conan install .. --profile your_profile -s build_type=Debug
```

Configure your project:
```bash
cmake -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake ..
```

Maybe adjust some settings:
```bash
cmake-gui .
```

Build:
```bash
cmake --build . --config Debug
```

To run the tests:
```bash
ctest --output-on-failure -C Debug -j4 .
```

## Manual install

It is also possible to install MdtCMakeModules locally.
See [INSTALL](INSTALL.md).

Then, configure your project and specify
the path of the installed MdtCMakeModules:
```bash
cmake -DCMAKE_PREFIX_PATH=/some/path/MdtCMakeModules ..
```

### Find MdtCMakeModules with CMake

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


# Work on MdtCMakeModules

## Build

See [BUILD](BUILD.md).

## Create Conan package

See [README](packaging/conan/README.md) in the conan packaging folder.
