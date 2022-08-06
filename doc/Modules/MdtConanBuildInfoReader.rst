MdtConanBuildInfoReader
-----------------------

.. contents:: Summary
  :local:



.. command:: mdt_conan_build_info_read_libdirs

Get the list of library directories paths::

  mdt_conan_build_info_read_libdirs(<out_var> FILE <file-path>)


.. command:: mdt_conan_build_info_read_bindirs

Get the list of binary directories paths::

  mdt_conan_build_info_read_bindirs(<out_var> FILE <file-path>)


Example:

.. code-block:: cmake

  set(conanBuildInfoFilePath "${PROJECT_BINARY_DIR}/conanbuildinfo.txt")

  if(WIN32)
    mdt_conan_build_info_read_bindirs(sharedLibrariesDirectories FILE "${conanBuildInfoFilePath}")
  else()
    mdt_conan_build_info_read_libdirs(sharedLibrariesDirectories FILE "${conanBuildInfoFilePath}")
  endif()


.. command:: mdt_get_shared_libraries_directories_from_conanbuildinfo_if_exists

Get a list of shared libraries directories from `conanbuildinfo.txt` if it exists::

  mdt_get_shared_libraries_directories_from_conanbuildinfo_if_exists(<out_var>)

This helper function will locate a `conanbuildinfo.txt` in ``CMAKE_PREFIX_PATH`` and some other paths.
If the file is found,
it will call :command:`mdt_conan_build_info_read_bindirs()` on Windows,
:command:`mdt_conan_build_info_read_libdirs()` on other platforms.

Example:

.. code-block:: cmake

  mdt_get_shared_libraries_directories_from_conanbuildinfo_if_exists(sharedLibrariesDirectories)


The path to the `conanbuildinfo.txt` can be set explicitly
using the ``MDT_CONAN_BUILD_INFO_FILE_PATH`` variable.

Example:

.. code-block:: cmake

  set(MDT_CONAN_BUILD_INFO_FILE_PATH "${PROJECT_BINARY_DIR}/conanbuildinfo.txt")
  mdt_get_shared_libraries_directories_from_conanbuildinfo_if_exists(sharedLibrariesDirectories)
