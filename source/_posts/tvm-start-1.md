---
title: TVM新人入坑-跑通demo
date: 2025-06-06 19:11:17
tags:
---

本来要在npu上玩的，结果zh的机器tm的不知为什么卡又掉了，必须得系统关机之后物理重启电源。等修完估计答辩也没一两天了，windows上弄个能跑的demo先。

本文内容时效性截至2025.6.7

tvm version 0.21.dev0

<!-- more -->

[TVM官方文档](tvm.apache.org/docs/)

# 从源码安装

WSL Ubuntu 24.04

## dependencies

* CMake (>= 3.24.0)
* LLVM (recommended >= 15)
* Git
* A recent C++ compiler supporting C++ 17, at the minimum
* Python (>= 3.8)
* (Optional) Conda (Strongly Recommended)
  ```bash
  conda create -n tvm-build-venv -c conda-forge `
  llvmdev>=15 `
  git `
  python=3.11

  conda activate tvm-build-venv
  ```
  全部依赖用conda管理，剩下clang cmake直接 `apt install clang cmake libzstd-dev`

  最新的conda直接下载cmake会用4.0的测试版，导致configuration出错。

  没有llvm也能编译，但这样没有cpu支持。

## 下载tvm源码

```bash
git clone --recursive https://github.com/apache/tvm tvm
```

## 编译安装

```bash
cd tvm
rm -rf build && mkdir build && cd build
# Specify the build configuration via CMake options
cp ../cmake/config.cmake .
```

打开自己需要的开关

```bash
# controls default compilation flags (Candidates: Release, Debug, RelWithDebInfo)
echo "set(CMAKE_BUILD_TYPE RelWithDebInfo)" >> config.cmake

# LLVM is a must dependency for compiler end
echo "set(USE_LLVM \"llvm-config --ignore-libllvm --link-static\")" >> config.cmake
echo "set(HIDE_PRIVATE_SYMBOLS ON)" >> config.cmake

# GPU SDKs, turn on if needed
echo "set(USE_CUDA   ON)" >> config.cmake
echo "set(USE_METAL  OFF)" >> config.cmake
echo "set(USE_VULKAN OFF)" >> config.cmake
echo "set(USE_OPENCL OFF)" >> config.cmake

# cuBLAS, cuDNN, cutlass support, turn on if needed
echo "set(USE_CUBLAS ON)" >> config.cmake
echo "set(USE_CUDNN  OFF)" >> config.cmake
echo "set(USE_CUTLASS OFF)" >> config.cmake
```

cmake还需要设置architecture 我的RTX 1650对应是86

```cmake
set(CMAKE_CUDA_ARCHITECTURES 86)
```

python集成需要Cython包
```bash
pip install Cython
```

编译

```bash
cmake .. -DCMAKE_C_COMPILER=xx -DCMAKE_CXX_COMPILER=xx && cmake --build . --parallel $(nproc)
```

最后会有 `libtvm.so` 和 `libtvm_runtime.so` 这两动态库。

配置pythonpath来使用，这种情况符合tvm的开发者，频繁修改源码并编译应用的情况。

```bash
export TVM_HOME=/path-to-tvm
export PYTHONPATH=$TVM_HOME/python:$PYTHONPATH
```

如果只是使用tvm，也可以pip安装

```bash
export TVM_LIBRARY_PATH=/path-to-tvm/build
pip install -e /path-to-tvm/python
```

使用conda则需全程注意自己所处的环境。

## 检查安装

```bash
python -c "import tvm; print(tvm.__file__)"
```

一般需要根据error装几个包才通。

然后检查TVM Library能否正常使用，文档似乎没有跟进最新的结构，要查看的 `tvm._ffi` 实际上并不存在

不过文档在刷知乎的时候就看到被喷写的和屎一样，有心理预期。` 

```python
import tvm
print(tvm.base._LIB)
```

`base` 直接移动到了外面和 `ffi` 并列

查看构建选项的实际支持

```bash
python -c "import tvm; print('\n'.join(f'{k}: {v}' for k, v in tvm.support.libinfo().items()))"
```