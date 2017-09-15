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
python3 templater.py "${filename%.*}.tmp" properties/properties.yml > "${filename%.*}"
done < <(find $1 -name '*.tpl' -print0)
