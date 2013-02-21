#!/usr/bin/env python

import os, sys

repo_directory, script_filename = os.path.split(sys.argv[0])
ignore_filenames = [script_filename]
repo_filenames = os.listdir(repo_directory)
link_filenames = [filename for filename in repo_filenames if filename not in ignore_filenames]
print ignore_filenames
print repo_filenames
print link_filenames
