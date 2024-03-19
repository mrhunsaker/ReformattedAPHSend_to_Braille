#!/usr/bin/env zsh
#
####################################################################################################
# Copyright 2023 Michael Ryan Hunsaker, M.Ed., Ph.D.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This script converts all rtf files in the specified folder to markdown files
####################################################################################################

setopt extended_glob

# Check if an argument (folder path) is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <folder_path>"
    exit 1
fi

# Change to the specified folder
cd "$1" || exit 1

# Create a folder to store the markdown files
if [[ ! -a ./ScriptingTextOverall ]]; then
    mkdir -p ./ScriptingTextOverall
fi

# Create a file to store the combined lectures
if [[ ! -a ./combinedLectures.md ]]; then
    touch ./combinedLectures.md
fi

# Output all rtf files as markdown files and move to ./ScriptingTextOverall as individual files
for i in ./**/scripting*Text/*.rtf(.); do
    echo "$i"
    echo " "
    # Get the filename without the extension
    FILENAME=$(echo "$i:t:r")
    echo "FILENAME = $FILENAME"
    echo " "
    # Convert $i to $FILENAME.md
    pandoc "$i" --read rtf --wrap=none --write markdown --output "$FILENAME.md" --verbose --log=./pandocLog --tab-stop=4
    # Move $FILENAME.md to ./ScriptingTextOverall
    cp "$FILENAME.md" "./ScriptingTextOverall/$FILENAME.md"
    # Write $FILENAME.md to combinedLectures.md with a markdown H1 header and $FILENAME as the H1 title
    echo "# $FILENAME:" >> "./combinedLectures.md"
    echo >> "./combinedLectures.md"
    cat "$FILENAME.md" >> "./combinedLectures.md"
    echo >> "./combinedLectures.md"
    echo "$FILENAME.md copied to ./ScriptingTextOverall/$FILENAME.md"
    echo " "
    # Format $FILENAME.md for final output
    sed -i 's/\\//g' "./ScriptingTextOverall/$FILENAME.md"
    sed -i 's/Brian Hartgen: /\*\*Brian Hartgen\*\*: \n\n/g' "./ScriptingTextOverall/$FILENAME.md"
    sed -i 's/JAWS: /\*\*JAWS\*\*: \n\n /g' "./ScriptingTextOverall/$FILENAME.md"
    echo "./ScriptingTextOverall/$FILENAME.md has been formatted"
    echo " "
    # Remove $FILENAME.md
    rm "$FILENAME.md"
    echo " "
    echo "$FILENAME.md deleted"
    # Sleep for 0.25 seconds between each file
    sleep 0.25
done

# Format combinedLectures.md for final output
sed -i 's/\\//g' "./combinedLectures.md"
sed -i 's/Brian Hartgen: /\*\*Brian Hartgen\*\*: \n\n/g' "./combinedLectures.md"
sed -i 's/JAWS: /\*\*JAWS\*\*: \n\n /g' "./combinedLectures.md"

# End of script
