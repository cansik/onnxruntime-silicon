#!/bin/bash -e

echo "building for $(python --version)"

version_tag="v1.16.3"
onnxruntime_dir="onnxruntime"
url=https://github.com/microsoft/onnxruntime.git

root_dir=$(pwd)
dist_dir="$root_dir/dist"
patch_dir="$root_dir/patches"

# cleanup
if [ -d "$root_dir/$onnxruntime_dir" ]; then
    if [ "$1" != "--no-clean" ]; then
        echo "found existing $onnxruntime_dir, resetting..."
        pushd "$root_dir/$onnxruntime_dir" || exit
        git fetch origin refs/tags/$version_tag:refs/tags/$version_tag
        git reset --hard --recurse-submodules $version_tag
        git clean -dfx
        popd || exit
    else
        echo "not cleaning existing $onnxruntime_dir"
    fi
else
    # download
    git clone --recurse-submodules --shallow-submodules --depth 1 --branch $version_tag $url $onnxruntime_dir
fi

pushd "$root_dir/$onnxruntime_dir" || exit

# install dependencies
pip install -r requirements-dev.txt

if [ "$1" != "--no-clean" ]; then
    # cmake generate to download dependencies
    echo "cleaning..."
    ./build.sh --clean \
        --config Release || true

    echo "updating..."
    ./build.sh --update \
        --config Release \
        --parallel \
        --skip_tests \
        --cmake_generator="Ninja"
fi
echo "building..."

./build.sh --config Release \
    --parallel \
    --compile_no_warning_as_error \
    --skip_submodule_sync \
    --osx_arch "arm64" \
    --use_coreml \
    --build_wheel \
    --wheel_name_suffix="-silicon" \
    --skip_tests \
    --enable_lto \
    --use_lock_free_queue \
    --cmake_generator="Ninja"

# TODO: trap

# check for errors in build
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Error while building, please check the log."
    exit $RESULT
fi

# wait for file to be copied
sleep 5

# copy to dist
mkdir -p "$dist_dir"
cp -a ./build/MacOS/Release/dist/*.whl "$dist_dir"

popd || exit
