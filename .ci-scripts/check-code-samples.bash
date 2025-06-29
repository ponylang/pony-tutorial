#!/bin/bash

#set -e
set -u

cd ./code-samples/
files=$(ls | wc -l)
echo "Check $files files …"
failedFiles=()
i=0
$HOME/.local/share/ponyup/bin/ponyc
ls -l
for file in *.pony; do
    ((i++))
    percentage=$(((i*100)/files))
    echo -e "#$i Test $file … ($i/$files \u2192 $percentage %)"
    #docker run -v $(pwd):/src/main docker://ghcr.io/ponylang/ponyc:latest
    #ponyc "./code-samples/$file"
    #$HOME/.local/share/ponyup/bin/ponyc "${{ github.workspace }}/code-samples/$file"
    #$HOME/.local/share/ponyup/bin/ponyc #"$GITHUB_WORKSPACE/code-samples/$file"
    #if [ $? -eq 0 ]; then
    if [ -f "$file.ll" ] && [ -f "$file.s" ]; then
        echo -e "\e[1;32m\u2705 File could be compiled successfully\e[0m"
    else
        echo -e "\e[1;31m\u274C File compilation failed\e[0m"
        failedFiles+=(file)
    fi
done
if [ "${#failedFiles[@]}" != 0 ]; then
    echo  -e "\e[1;31m💥 ${#failedFiles[@]}/$files file(s) had errors\e[0m"
    exit 1
else
    echo -e "\e[1;32m🎉 All $files files were checked successfully\e[0m"
    exit 0
fi
