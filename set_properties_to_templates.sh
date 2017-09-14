#!/bin/bash

set -a # turn on auto-export
. properties/configuration.properties
set -a # turn off auto-export

while IFS= read -r -d '' filename; do
echo "-------------- $filename --------------"
eval "cat <<EOF
# GENERATED FILE, please do not modify nor store into Git #
$(<$filename)
EOF
" > "${filename%.*}.tmp"
python3 compose/templater/templater.py "${filename%.*}.tmp" concourse/properties.yml > "${filename%.*}"
done < <(find . -name '*.tpl' -print0)
