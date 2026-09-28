## iceoryx

```bash
## 安装依赖和编译

sudo apt update
sudo apt install gcc g++ cmake libacl1-dev libncurses5-dev pkg-config
sudo apt install build-essential libncurses5-dev

sudo apt install libcpptoml-dev

git clone https://github.com/eclipse-iceoryx/iceoryx.git

cmake -Dbuild -Hiceoryx_meta -DCMAKE_BUILD_TYPE=Release
-DDOWNLOAD_TOML_LIB=OFF -DBUILD_SHARED_LIBS=ON -DEXAMPLES=ON
cmake --build build -j2

## 测试编译结果
./build/iox-roudi
./build/iceoryx_examples/icehello/iox-cpp-subscriber-helloworld
./build/iceoryx_examples/icehello/iox-cpp-publisher-helloworld

## 安装
sudo cmake --build build --target install
# 默认安装位置 /usr/local
# 头文件: /usr/local/include/iceoryx/v2.0.0
# 库文件: /usr/local/lib/
# 可执行文件: /usr/local/bin/iox-roudi
```