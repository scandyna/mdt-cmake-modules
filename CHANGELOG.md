

# [0.19.2] - 2022-10-13

## Changed

- Generate package files in MdtCMakeFiles subdirectory: [GL issue 10](https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/10)


# [0.19.1] - 2022-10-09

## Changed

- Generate package files in MdtCMakeFiles subdirectory: [GL issue 10](https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/10)
- mdt_install_cmake_modules(): also consider MODULES_PATH_VARIABLE_NAME for conan package file: [GL issue 11](https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/11)


# [0.19.0] - 2022-09-03

## Changed

- MdtSanitizers: by default, build for given sanitizer using the available build configurations: [GL issue 9](https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/9)


# [0.18.3] - 2022-08-15

## Changed

- Work on [GL issue 8](https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/8)


# [0.18.2] - 2022-08-15

## Changed

- Work on [GL issue 8](https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/8)


# [0.18.1] - 2022-08-06

## Added

- MdtConanBuildInfoReader module
- MdtIniFileReader module
- MdtTargetDependenciesHelpers module

## Changed

- MdtRuntimeEnvironment module: remove usage of `CMAKE_LIBRARY_PATH`, use `conanbuildinfo.txt` if it exists.
- Work on [GL issue 7](https://gitlab.com/scandyna/mdt-cmake-modules/-/issues/7)
