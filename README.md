# Milk-V Duo CMake Project

## 简介

使用CMake框架编译构建上层应用程序

当前计划支持C906B C906L CA53 三个核的开发，C906B为CV1800B/SG200X运行Linux的大核，C906L为CV1800B/SG200X运行RTOS的小核，CA53为SG200X可选的第二个运行Linux的大核。

## 如何使用

以C906B作为示例

1. 克隆仓库

   ```shell
   git clone https://github.com/dreamcmi/milkv-duo-cmake
   ```

2. 使能环境变量

   ```shell
   cd milkv-duo-cmake
   source envsetup.sh
   ```

3. 编译工程

   ```shell
   cd C906B/example/helloworld
   cmake -B build && cmake --build build
   ```

4. 运行程序

   ```shell
   scp build/helloworld-C906B root@192.168.42.1:/root/
   # 上传文件为build/helloworld-C906B 具体方式请根据实际环境而定
   ```

## LICENSE

Apache 2.0

