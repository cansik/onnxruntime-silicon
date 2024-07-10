# [ONNX Runtime](https://github.com/microsoft/onnxruntime) for Apple Silicon [![PyPI](https://img.shields.io/pypi/v/onnxruntime-silicon)](https://pypi.org/project/onnxruntime-silicon/)
ONNX Runtime prebuilt wheels for Apple Silicon (M1 / M2 / arm64)

⚠️ The official [ONNX Runtime](https://pypi.org/project/onnxruntime/) now includes `arm64` binaries for MacOS as well with Core ML support. Please use the official wheel package as this repository is no longer needed.

```
pip install onnxruntime
```

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

## FAQ

#### Installation

> pip install onnxruntime-silicon returns the following error: Could not find a version that satisfies the requirement onnxruntime-silicon

This indicates either that the Python version is not supported (currently only `3.8`, `3.9`, `3.10`, `3.11`) or that the python installation is not built for `arm64`. You can check this by running the following command: 

```bash
file $(which python) | grep -q arm64 && echo "Python for arm64 found" || echo "Python for arm64 has not been found"
```

#### Import ONNX Runtime

> import onnxruntime reaises the exception: ModuleNotFoundError: No module named 'onnxruntime'

It seems that onnxruntime has not been installed yet, please run `python -m pip install onnxruntime-silicon`. Check if it has been installed correctly with the following command:

```bash
python -m pip freeze | grep -q onnxruntime-silicon && echo "ONNX runtime for arm64 found" || echo "No ONNX runtime for arm64 found"
```

#### Import ONNX Runtime Silicon

> import onnxruntime-silicon raises the exception: ModuleNotFoundError: No module named 'onnxruntime-silicon'

`onnxruntime-silicon` is a dropin-replacement for `onnxruntime`. After [installing](#Install) the package, everything works the same as with the original `onnxruntime`. Import the package like this: `import onnxruntime`.

#### Another Issue

If your specific issue is not answered by the [FAQ](#FAQ) and there is not already an [issue]([url](https://github.com/cansik/onnxruntime-silicon/issues/)) solved or open, please [open a new issue](https://github.com/cansik/onnxruntime-silicon/issues/new/choose) for it. Provide the following information:

- MacOS version and architecture
- Python version and architecture
- Pip version
- ONNX Runtime version

You can also run the following command and copy paste it's output into the issue:

```bash
echo ""; \
echo "Operating System: $(uname -s) $(uname -r)"; \
echo "Architecture: $(uname -m)"; \
echo "Python Version: $(python --version 2>&1)"; \
echo "Python Architecture: $(python -c 'import platform; print(platform.architecture()[0])')"; \
echo "Python Executable: $(file $(which python))"; \
echo "PIP Version: $(pip --version | awk '{print $2}')"; \
echo ""
```

## About
MIT License - Copyright (c) 2024 Florian Bruggisser
