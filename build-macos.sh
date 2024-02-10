#!/bin/bash -e

echo "building for $(python --version)"

version_tag="v1.16.3"
onnxruntime_dir="onnxruntime"
url=https://github.com/microsoft/onnxruntime.git

root_dir=$(pwd)
dist_dir="$root_dir/dist"
patch_dir="$root_dir/patches"
no_clean=0
generator="Unix Makefiles"
lto=0

function print_help() {

    cat <<EOF
Clones the repo: $url [tag:$version_tag] or resets, if it
already exists, and launches the build.

usage: ./build-mac.sh [options]

options:
    -h,--help		show this help message and exit
    -v,--version	shows onxruntime version
    --no-clean		suppresses resetting / cleaning and updating the repo,
			therefore try avoiding full rebuild

    --ninja		use ninja as build tool (sets corresponding CMake generator)
    --lto		enable LTO (expect slower build times).

caveats:
    --no-clean depends on suppressed build stages' success and will fail if
    that's not met.
EOF
}

while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
        print_help
        exit
        ;;
    -v | --version)
        echo $version_tag
        exit
        ;;
    --no-clean)
        no_clean=1
        ;;
    --ninja)
        generator=Ninja
        ;;
    --ninja)
        lto=1
        ;;
    *)
        print_help
        exit
        ;;
    esac
    shift
done

# cleanup
if [ -d "$root_dir/$onnxruntime_dir" ]; then
    echo "found existing $onnxruntime_dir"

    if [ $no_clean = "0" ]; then
        echo "resetting existing $onnxruntime_dir"
        pushd "$root_dir/$onnxruntime_dir" || exit
        git fetch origin refs/tags/$version_tag:refs/tags/$version_tag
        git reset --hard --recurse-submodules $version_tag
        git clean -dfx
        popd || exit

    else
        echo "not resetting existing $onnxruntime_dir"
    fi
else
    # download
    git clone --recurse-submodules --shallow-submodules --depth 1 --branch $version_tag $url $onnxruntime_dir
fi

pushd "$root_dir/$onnxruntime_dir" || exit

# install dependencies
pip install -r requirements-dev.txt

if [ $no_clean = "0" ]; then
    # cmake generate to download dependencies
    echo "cleaning..."
    ./build.sh --clean \
        --config Release || true

    echo "updating..."
    ./build.sh --update \
        --config Release \
        --parallel \
        --skip_tests \
        --cmake_generator="$generator"
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
    ${lto:+--enable_lto} \
    --use_lock_free_queue \
    --cmake_generator="$generator"

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
