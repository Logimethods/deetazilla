#!/bin/bash

# https://stackoverflow.com/questions/10735574/include-source-script-if-it-exists-in-bash
include () {
    #  [ -f "$1" ] && source "$1" WILL EXIT...
    if [ -f $1 ]; then
        echo "source $1"
        source $1
    fi
}

set -a # turn on auto-export
include properties/configuration.properties
include properties/configuration-application.properties
set -a # turn off auto-export

while IFS= read -r -d '' filename; do
echo "-------------- $filename --------------"
if [[ ${filename} == */Dockerfile.tpl || ${filename} == *.sh.tpl ]]; then
  ___intro="### GENERATED FILE, please do not modify nor store into Git ###"
else
  ___intro=""
fi
eval "cat <<EOF
${___intro}
$(<$filename)
EOF
" > "${filename%.*}.tmp"
python3 python/templater.py "${filename%.*}.tmp" "properties/properties*.yml" > "${filename%.*}"
done < <(find $1 -name '*.tpl' -print0)
