# [ONNX Runtime](https://github.com/microsoft/onnxruntime) for Apple Silicon [![PyPI](https://img.shields.io/pypi/v/onnxruntime-silicon)](https://pypi.org/project/onnxruntime-silicon/)
ONNX Runtime prebuilt wheels for Apple Silicon (M1 / ARM64)

## Install
To install the prebuilt packages, use the following command to install. The package is called **onnxruntime-silicon** but is a drop-in-replacement for the onnxruntime package.

```
pip install onnxruntime-silicon
```

## Build
To build the libraries yourself, please first install the following dependencies and run the build script.

```
brew install wget cmake protobuf git git-lfs
```

```
./build-macos.sh
```

The pre-built wheel packages should be in the `dist` directory.

## About
MIT License - Copyright (c) 2022 Florian Bruggisser
