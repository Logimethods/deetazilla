#!/bin/bash

set -a # turn on auto-export
. properties/configuration.properties
set -a # turn off auto-export

while IFS= read -r -d '' filename; do
echo "-------------- $filename --------------"
if [[ ${filename} == */Dockerfile.tpl || ${filename} == *.sh.tpl ]]; then
  ___intro="### GENERATED FILE, please do not modify nor store into Git ###"
fi
if [[ ${filename} == *.xml.tpl ]]; then
  ___intro="<!-- GENERATED FILE, please do not modify nor store into Git >>"
fi
eval "cat <<EOF
${___intro}
$(<$filename)
EOF
" > "${filename%.*}.tmp"
python3 python/templater.py "${filename%.*}.tmp" "properties/properties*.yml" > "${filename%.*}"
done < <(find $1 -name '*.tpl' -print0)
