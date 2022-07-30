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

  # TODO: maybe use PROJECT_BINARY_DIR ?
  set(conanBuildInfoFilePath "${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.txt")

  if(WIN32)
    mdt_conan_build_info_read_bindirs(sharedLibrariesDirectories FILE "${conanBuildInfoFilePath}")
  else()
    mdt_conan_build_info_read_libdirs(sharedLibrariesDirectories FILE "${conanBuildInfoFilePath}")
  endif()
