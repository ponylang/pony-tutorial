#!/bin/bash

# setup theme submodule
pushd themes/ananke
git submodule init
git submodule update
popd

# build it
hugo