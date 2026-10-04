#!/bin/bash

set -e
set -u

export SHELL=/bin/bash

sh -c "$(curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ponylang/ponyup/latest-release/ponyup-init.sh)"
export PATH=$HOME/.local/share/ponyup/bin:$PATH
ponyup update ponyc release
export PATH=$HOME/.local/share/ponyup/bin/ponyc:$PATH
