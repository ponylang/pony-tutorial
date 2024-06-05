#!/bin/bash

set -e
set -u

cd ./code-samples/
files=$(ls | wc -l)
echo "Check $files files …"
failedFiles=()
notRunnable=0
i=0
for file in *.pony; do
    ((i++))
    percentage=$(((i*100)/files))
    echo -e "#$i Test $file … ($i/$files \u2192 $percentage %)"
    docker run -v $(pwd):/src/main docker://ghcr.io/ponylang/ponyc:latest
done
runnableFiles=$((files-notRunnable))
if [ "${#failedFiles[@]}" != 0 ]; then
    echo  -e "\e[1;31m💥 ${#failedFiles[@]}/$runnableFiles file(s) ($files total) had errors\e[0m"
    exit 1
else
    echo -e "\e[1;32m🎉 All $files files ($runnableFiles runnable) were checked successfully\e[0m"
    exit 0
fi
