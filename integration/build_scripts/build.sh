#!/bin/bash

set -e

source build_functions.sh

# ./build_dz.sh

clear
echo "-----------------------------------------"
echo "build_dockerfile_inject $extension"
build_dockerfile_inject "$extension"
