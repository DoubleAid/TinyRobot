#!/bin/bash
set -e

# ========== 参数解析 =========
BACKEND=${1:-tiny}

# 校验后端合法性
case "$BACKEND" in
  fastdds|ros1|ros2|tiny)
    ;;
  *)
    echo "错误: 未知底层适配 "