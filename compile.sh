#!/bin/bash
set -e

# ========== 参数解析 ==============
case "$BACKEND" in
    fastdds|ros1|ros2|tiny)
        ;;
    *)
        echo "错误： 位置底层接口 '$BACKEND'"
        echo "用法： $0 [fastdds|ros1|ros2|tiny]"
        exit 1
        ;;
esac

# ========== 路径 ===============
SCRIPT_DIR = "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
INSTALL_DIR="${SCRIPT_DIR}/install"

# ========== 清理 ===============
echo "=== 清理旧构建 ==="
if [ -d "$BUILD_DIR" ]; then
    rm -rf "$BUILD_DIR"
    echo "已删除 $BUILD_DIR"
fi

if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo "已删除 $INSTALL_DIR"
fi

# ========== 配置 ================
echo ""
echo "=== 配置 CMake (底层接口: $BACKEND) ==="
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

if [ "$BACKEND" = "ros1" ]; then
    ROS_SETUP_DEFAULT="/opt/ros/noetic/setup.bash"
elif [ "$BACKEND" = "ros2" ]; then
    ROS_SETUP_DEFAULT="/opt/ros/humble/setup.bash"
else
    ROS_SETUP_DEFAULT=""
fi

cmake \
    -DROBOT_BACKEND="$BACKEND" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
    ..

# ========== 编译 ===============
echo ""
echo "=== 编译 ==="
make -j"$(nproc)"

# ========== 安装 ===============
echo ""
echo "=== 安装到 $INSTALL_DIR ==="
make install

# ========== 完成 ===============
echo ""
echo "=== 编译完成 ==="
echo "底层接口: $BACKEND"
echo "可执行文件: $INSTALL_DIR/bin/"
echo "配置文件: $INSTALL_DIR/config/"