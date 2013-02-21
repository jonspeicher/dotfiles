#!/usr/bin/env python

import os, sys

repo_directory, script_filename = os.path.split(sys.argv[0])
files_to_ignore = [script_filename]
files_in_repo = os.listdir(repo_directory)
print files_to_ignore, files_in_repo
