#!/bin/bash

echo "building for $(python --version)"

version_tag="v1.15.0"
onnxruntime_dir="onnxruntime"

# cleanup
rm -rf $onnxruntime_dir

# download
git clone --recurse-submodules --shallow-submodules --depth 1 --branch $version_tag https://github.com/microsoft/onnxruntime.git $onnxruntime_dir

root_dir=$(pwd)
dist_dir="$root_dir/dist"

pushd "$root_dir/$onnxruntime_dir" || exit
# install dependencies
pip install -r requirements-dev.txt

# build
./build.sh --clean
./build.sh --skip-keras-test --skip_tests --config "Release" --parallel 8 --enable_pybind --build_wheel --wheel_name_suffix=-silicon --osx_arch "arm64" --apple_deploy_target 11 --use_coreml

# copy to dist
mkdir -p "$dist_dir"
cp -a ./build/MacOS/Release/dist/*.whl "$dist_dir"

popd || exit
