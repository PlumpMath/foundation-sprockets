#!/usr/local/bin/zsh
# TODO: This doesn't work with bash. Maybe I should fix that

# Convert scss imports to sprockets requires
replace_regexp='\/\/= require .\/\1'

#destination
cp -r bower_components/foundation/scss scss_sprockets
cp -r bower_components/foundation/js js
cp -r bower_components/foundation/css css

# Files with one import per line
standard_regexp='@import[[:space:]]+"(.*)?";'
standard_files=`grep -rE "$standard_regexp" scss_sprockets | cut -d':' -f1`

while read -r f; do
  sed -E -i.bak "s/$standard_regexp/$replace_regexp/" $f
  rm $f.bak
done <<< $standard_files

# Files with many file imports for one @import
bulk_import_import_regexp='^@import[[:space:]]*$'
bulk_import_file_regexp='^[[:space:]]*"(.*)?"[,;]'
bulk_import_files=`grep -rE "$bulk_import_import_regexp" scss_sprockets | cut -d':' -f1`

while read -r f; do
  sed -E -i.bak "s/$bulk_import_import_regexp/ /" $f
  sed -E -i.bak "s/$bulk_import_file_regexp/$replace_regexp/" $f
  rm $f.bak
done <<< $bulk_import_files

