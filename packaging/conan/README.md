# Create Conan packages for MdtCMakeModules

Some tools are required to create Conan packages:
 - Git
 - CMake
 - Conan

For a overview how to install them, see https://gitlab.com/scandyna/build-and-install-cpp


Get the sources:
```bash
git clone https://github.com/scandyna/mdt-cmake-modules.git
```

The package version is picked up from git tag.
If working on MdtCMakeModules, go to the root of the source tree:
```bash
git tag x.y.z
conan create packaging/conan scandyna/testing
```

To create a package without having a git tag:
```bash
conan create packaging/conan x.y.z@scandyna/testing
```
