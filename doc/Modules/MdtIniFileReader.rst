MdtIniFileReader
----------------

.. contents:: Summary
  :local:


.. command:: mdt_ini_file_read_section_content

Read the content of given section from given INI file::

  mdt_ini_file_read_section_content(<out_var> FILE <file-path> SECTION <section-name> [LIMIT_FILE_BYTE_COUNT] <max-num>)

Example:

.. code-block:: cmake

  mdt_ini_file_read_section_content(libraryDirectories
    FILE "${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.txt"
    SECTION "libdirs"
  )

See also the :module:`MdtConanBuildInfoReader` module.
