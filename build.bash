#!/bin/bash

# setup theme submodule
pushd themes/pony-doc-site
git submodule init
git submodule update
popd

# build it
hugo