cmake_minimum_required(VERSION 3.16)
project(tiny_robot)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(ROBOT_BACKEND "fastdds" CACHE STRING "底层接口: fastdds / ros1 / ros2/ tiny")
set_property(CACHE ROBOT_BACKEND PROPERTY STRINGS fastdds ros1 ros2 tiny)

message(STATUS "通信底层平台: ${ROBOT_BACKEND}")
message(STATUS "进程间通信: iceoryx")

if (CMAKE_INSTALL_PERFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/install" CACHE PATH "安装路径" FORCE)
endif()

find_package(yaml-cpp REQUIRED)
find_package(iceoryx_posh REQUIRED)
find_package(iceoryx_hoofs REQUIRED)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(src)

install(DIRECTORY scripts/
  DESTINATION .
  USE_SOURCE_PERMISSIONS
  FILES_MATCHING PATTEN "*.sh"
)