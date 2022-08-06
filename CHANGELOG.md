
# [0.18.1] - 2022-08-06

## Added

- MdtConanBuildInfoReader module
- MdtIniFileReader module
- MdtTargetDependenciesHelpers module

## Changed

- MdtRuntimeEnvironment module: remove usage of `CMAKE_LIBRARY_PATH`, use `conanbuildinfo.txt` if it exists.
- Work on [GL issue 7](https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/7)
