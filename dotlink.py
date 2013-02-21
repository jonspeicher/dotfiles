#!/usr/bin/env python

import os, re, sys

repo_directory, script_filename = os.path.split(sys.argv[0])
repo_filenames = os.listdir(repo_directory)

# TBD: load user ignore patterns from file, append to list, put some or all in constant
ignore_patterns = [script_filename, 'README', '^\.']
combined_ignore_patterns = "(" + ")|(".join(ignore_patterns) + ")"
ignore_regex = re.compile(combined_ignore_patterns)

link_filenames = [filename for filename in repo_filenames if not ignore_regex.match(filename)]

print ignore_patterns
print repo_filenames
print link_filenames
