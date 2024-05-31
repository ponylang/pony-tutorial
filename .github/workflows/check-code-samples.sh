cd ./code-samples/
files=$(ls | wc -l)
echo "Check $files files …"
failedFiles=()
i=0
for file in *.pony; do # actors-sequential.pony
    ((i++))
    percentage=$(((i*100)/files))
    echo -e "#$i Test $file … ($i/$files \u2192 $percentage %)"
    contents=$(cat "$file") # code-samples/
    #echo "contents: $contents"
    regex='^"""\n(?<line>^(?<key>[a-z_]+):\s?(?<value>.*?)$\n)+"""' # TODO: Get frontmatter from AST
    regex='^"""\n(.*)\n"""'
    expectations=$(jq --arg file "${file}" ".[\"$file\"]" ../code-samples.json) # -r
    #echo "Expectations for $file $expectations"
    expectedStdout=$(echo "$expectations" | jq '.stdout')
    expectedStderr=$(echo "$expectations" | jq '.stderr')
    expectedExitcode=$(echo "$expectations" | jq '.exitcode')
    #echo "stdout for $file: "
    #echo "$contents" | grep -e $regex
    if [ $(echo "$contents" | grep -qe $regex) ]; then # TODO: fix regex
        frontmatter="${BASH_REMATCH[0]}"
        readarray -d "\n" -t lines <<< frontmatter
        echo "Expectations 1: ${lines[0]}"
    fi
    if [[ "$contents" =~ $regex ]]; then
        frontmatter="${BASH_REMATCH[0]}"
        readarray -d "\n" -t lines <<< frontmatter
        echo "Expectations: ${lines[0]}"
    fi
    encoded=$(sed -E -e ':a;N;$!ba;s/\r\n|\r|\n/\\n/g' "$file") #code-samples/
    encoded=${encoded//\"/\\\"}
    encoded=${encoded//   /\\t}
    json="{\"code\": \"$encoded\", \"separate_output\": true, \"color\": true, \"branch\": \"release\"}"
    #echo "Send $json…"
    response=$(curl -s --header "Content-Type: application/json" \
        --request POST \
        --data "$json" \
        "https://playground.ponylang.io/evaluate.json")
    success=$(echo "$response" | jq '.success')
    actualStdout=$(echo "$response" | jq '.stdout')
    actualStderr=$(echo "$response" | jq '.stderr')
    if $success && ! [ -z "$expectations" ] && [ "$expectedExitcode" = "0" ] && [ "$actualStdout" = "$expectedStdout" ]; then
        echo -e "\u2705 File fulfilled expectations"
    elif ! $success && ! [ -z "$expectations" ] && [ "$expectedExitcode" = "1" ] && [ "$actualStderr" = "$expectedStderr" ]; then
        echo -e "\u2705 File fulfilled expectations"
    else
        failedFiles+=(file)
        echo -e "\u274C File didn't fulfill expectations"
        if [ "$expectedExitcode" = "0" ]; then
            echo "Success = true (actual: $success), stdout = $expectedStdout (actual: ${actualStdout-null})"
        else
            echo "Success = false (actual: $success), stderr = $expectedStderr (actual: ${actualStderr-null})"
        fi
        echo $response
        echo $expectations
        echo $expectedExitcode
    fi
    #break
done
if [ "${#failedFiles[@]}" != 0 ]; then
    echo -e "💥 ${#failedFiles[@]}/$files file(s) had errors"
else
    echo -e "🎉 All $files files were checked successfully"
fi