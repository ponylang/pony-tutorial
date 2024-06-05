#!/bin/bash

set -e
set -u

export SHELL=/bin/bash

sh -c "$(curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ponylang/ponyup/latest-release/ponyup-init.sh)"
ponyup update ponyc release
