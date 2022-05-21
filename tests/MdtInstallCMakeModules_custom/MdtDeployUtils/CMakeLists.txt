
cmake_minimum_required(VERSION 3.14)

project(MdtDeployUtils VERSION 0.0.1)

message(DEBUG "MdtDeployUtils CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

find_package(MdtCMakeModules REQUIRED NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH)

include(GNUInstallDirs)
include(MdtInstallCMakeModules)

set(MDT_DEPLOY_UTILS_INSTALL_CONFIG_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0DeployUtils")

mdt_install_cmake_modules(
  FILES
    Modules/ModuleA.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Mdt0DeployUtils/Modules
  EXPORT_NAME DeployUtilsCMakeModules
  EXPORT_NAMESPACE Mdt0
  NO_PACKAGE_CONFIG_FILE
  EXPORT_DESTINATION "${MDT_DEPLOY_UTILS_INSTALL_CONFIG_DIR}"
  COMPONENT ${PROJECT_NAME}_Runtime
)


include(CMakePackageConfigHelpers)
configure_package_config_file(
  Mdt0DeployUtilsConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/Mdt0DeployUtilsConfig.cmake
  INSTALL_DESTINATION "${MDT_DEPLOY_UTILS_INSTALL_CONFIG_DIR}"
  NO_SET_AND_CHECK_MACRO
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

install(
  FILES
    "${CMAKE_CURRENT_BINARY_DIR}/Mdt0DeployUtilsConfig.cmake"
  DESTINATION "${MDT_DEPLOY_UTILS_INSTALL_CONFIG_DIR}"
)
