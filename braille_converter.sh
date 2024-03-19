#!/bin/bash

# Quick and Dirty Braille
# Get location of this script
x="$(dirname "$(readlink -f "$0")")"
louis_tablepath="$x/tables"
louflg=""
# Set the translation table, this one is English UEB contracted
table="en-ueb-g2.ctb"

# Function to convert a file to braille
convert_to_braille() {
    local file_path="$1"
    local file_extension="${file_path##*.}"
    local utf8=false

    if [[ "$file_extension" != "docx" && "$file_extension" != "epub" && "$file_extension" != "odt" ]]; then
        utf8=true
        temp_file=$(mktemp)
        cp "$file_path" "$temp_file"
        "$x/Utf8n" "$temp_file"
        pandoc -t plain --wrap=preserve "$temp_file" 2> /dev/null | "$x/lou_translate" "$table" > "$file_path.brl" 2> /dev/null
        rm "$temp_file"
    else
        pandoc -t plain --wrap=preserve "$file_path" 2> /dev/null | "$x/lou_translate" "$table" > "$file_path.brl" 2> /dev/null
    fi
}

# Loop through the arguments
for arg in "$@"; do
    convert_to_braille "$arg"
done

echo "Conversion to braille completed."
