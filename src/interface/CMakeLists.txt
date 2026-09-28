cmake_minimum_required(VERSION 3.16)
project(robot_interface LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(yaml-cpp REQUIRED)
find_package(iceoryx_posh REQUIRED)
find_package(iceoryx_hoofs REQUIRED)

add_subdirectory(src/base_interface)

if (ROBOT_BACKEND STREQUAL "ros2")
    find_package(rclcpp REQUIRED)
    find_package(sensor_msgs REQUIRED)
    set(IFACE_BACKEND_LIB       ros2_interface)
    set(IFACE_BACKEND_HEADER    "ros2_interface.h")
    set(IFACE_BACKEND_CLASS     robot::ROS2Interface)
elseif(ROBOT_BACKEND STREQUAL "ros1")
    find_package(catkin REQUIRED COMPONENTS roscpp sensor_msgs)
    set(IFACE_BACKEND_LIB       ros1_interface)
    set(IFACE_BACKEND_HEADER    "ros1_interface.h")
    set(IFACE_BACKEND_CLASS     robot::ROS1Interface)
elseif(ROBOT_BACKEND STREQUAL "fastdds")
    set(IFACE_BACKEND_LIB       fastdds_interface)
    set(IFACE_BACKEND_HEADER    "fastdds_interface.h")
    set(IFACE_BACKEND_CLASS     robot::FastDDsInterface)
elseif(ROBOT_BACKEND STREQUAL "tiny")
    set(IFACE_BACKEND_LIB       tiny_interface)
    set(IFACE_BACKEND_HEADER    "tiny_interface.h")
    set(IFACE_BACKEND_CLASS     robot::TinyInterface)
else()
    message(FATAL_ERROR "未知底层接口: ${ROBOT_BACKEND}")
endif()

add_subdirectory(src/implements)

# -------------------------------------------------------------
# 网关可执行文件
# -------------------------------------------------------------
add_executable(interface src/interface_main.cpp)

target_compile_definitions(interface PRIVATE
    IFACE_BACKEND_HEADER="${IFACE_BACKEND_HEADER}"
    IFACE_BACKEND_CLASS=${IFACE_BACKEND_CLASS}
    SOURCE_CONFIG_PATH="${CMAKE_CURRENT_SOURCE_DIR}/config/interface_config.yaml"
)

target_link_libraries(interface PRIVATE
    ${IFACE_BACKEND_LIB}
    base_interface
    robot_types
    logger
    iceoryx_posh::iceoryx_posh
)

install(TARGETS interface
    RUNTIME DESTINATION bin
)

install(FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/config/interface_config.yaml
    ${CMAKE_CURRENT_SOURCE_DIR}/config/roudi_config.toml
    DESTINATION config
)