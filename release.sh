#!/bin/bash

function build ()
{
    source "$1/bin/activate"
    python --version
    ./build-macos.sh
    deactivate
}

build venv38
build venv39
build venv310
build venv311