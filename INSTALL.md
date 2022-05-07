[[_TOC_]]

# Install MdtCMakeModules

This section describes how to install MdtCMakeModules.

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


Some tools are required to install MdtCMakeModules:
 - Git
 - CMake
 - Make (for Linux, can be other, like Ninja)

To run the unit tests, those libraries and tools are also required:
 - Gcc
 - Qt - Optional (only required when BUILD_QT_TESTS is ON)
 - Conan - Optional (only required when BUILD_CONAN_TESTS is ON)

For a overview how to install them, see https://gitlab.com/scandyna/build-and-install-cpp

## Get the source code

Get the sources:
```bash
git clone https://github.com/scandyna/mdt-cmake-modules.git
```

## Configure on Linux (Makefiles)

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

Maybe adjust some settings:
```bash
cmake-gui .
```

## Configure on Windows using MinGW

Open a terminal that has gcc and mingw32-make in the PATH.

Configure:
```bash
mkdir build && cd build
cmake -G"MinGW Makefiles" -DCMAKE_INSTALL_PREFIX=C:\some\path ..
```

Maybe adjust some settings:
```bash
cmake-gui .
```

## Configure using CMake on Windows MSVC

Configure:
```cmd
mkdir build && cd build
cmake -G "Visual Studio 15 2017 Win64" -DCMAKE_INSTALL_PREFIX=C:\some\path ..
```

Maybe adjust some settings:
```bash
cmake-gui .
```

## Build and install

Build (will generate some install files):
```bash
cmake --build .
```

TODO: build type has no sense, but check if cmake accepts not passing --config for MSVC
Maybe:
```bash
cmake --build . --config Release
```

Install the modules:
```bash
cmake --install .
```
TODO: build type has no sense, but check if cmake accepts not passing --config for MSVC
