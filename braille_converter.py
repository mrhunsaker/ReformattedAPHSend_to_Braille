import os
import subprocess
import sys
import tempfile

# Quick and Dirty Braille
# Get location of this file
x = os.path.dirname(os.path.realpath(__file__))
louis_tablepath = os.path.join(x, 'tables')
louflg = ""
# Set the translation table, this one is English UEB contracted
table = "en-ueb-g2.ctb"

# pandoc to text then LouTran to braille with .brl appended to original file name, avoiding UTF-8 encoding when appropriate:
utf8 = False

def convert_to_braille(file_path):
    global utf8
    file_extension = os.path.splitext(file_path)[1].lower()
    if file_extension not in [".docx", ".epub", ".odt"]:
        utf8 = True
        temp_file = tempfile.NamedTemporaryFile(delete=False)
        temp_file_path = temp_file.name + file_extension
        temp_file.close()
        subprocess.run(["cp", file_path, temp_file_path])
        subprocess.run([os.path.join(x, "Utf8n"), temp_file_path])
        pandoc_command = ["pandoc", "-t", "plain", "--wrap=preserve", temp_file_path]
        lou_translate_command = [os.path.join(x, "lou_translate"), table]
        with open(file_path + ".brl", "w") as brl_file:
            subprocess.run(pandoc_command, stdout=subprocess.PIPE, stderr=open(os.devnull, 'w'))
            subprocess.run(lou_translate_command, stdin=subprocess.PIPE, stdout=brl_file, stderr=open(os.devnull, 'w'))
        os.remove(temp_file_path)
    else:
        pandoc_command = ["pandoc", "-t", "plain", "--wrap=preserve", file_path]
        lou_translate_command = [os.path.join(x, "lou_translate"), table]
        with open(file_path + ".brl", "w") as brl_file:
            subprocess.run(pandoc_command, stdout=subprocess.PIPE, stderr=open(os.devnull, 'w'))
            subprocess.run(lou_translate_command, stdin=subprocess.PIPE, stdout=brl_file, stderr=open(os.devnull, 'w'))

# Loop through the arguments
for arg in sys.argv[1:]:
    convert_to_braille(arg)

# Open editor (optional)
# subprocess.run(["bz.jar", sys.argv[1] + ".brl"])

# Copy to a card (optional)
# target = "f:"
# subprocess.run(["cp", sys.argv[1] + ".brl", target])

print("Conversion to braille completed.")
