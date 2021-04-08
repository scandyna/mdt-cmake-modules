
# Qt

Should look [PROPERTIES MAP_IMPORTED_CONFIG_](https://doc.qt.io/qt-5/cmake-get-started.html)

# Install OBJECT libraries

Abandon..

# Shared libraries (file) names

On Windows, libMyLib.dll is wrong

# Component install

mdt_install_library():
 - DEVELOPMENT_COMPONENT should default to ${PROJECT_NAME}_Dev

# dll debug env

Generate a script that create the PATH as passed to the test's ENVIRONMENT

mdt_generate_runtime_environment_script(TARGET ...)

-> OR find ctest flag that does not filter out Windows debug info,
   or the file tha ctest generates with those infos


# Others

Add badges to: GitLab CI/CD, AppVeyor CI, Bintray Conan repo/package

gcc: see -D_FORTIFY_SOURCE={0,1,2}

# Sanitizers

For address, see -static-libasan
