#!/usr/bin/env python

import os, re, sys

repo_directory, script_filename = os.path.split(sys.argv[0])
ignore_filenames = [script_filename, 'README', '^\.']
ignore_regex = "(" + ")|(".join(ignore_filenames) + ")"
repo_filenames = os.listdir(repo_directory)
link_filenames = [filename for filename in repo_filenames if not re.match(ignore_regex, filename)]

print ignore_filenames
print ignore_regex
print repo_filenames
print link_filenames
