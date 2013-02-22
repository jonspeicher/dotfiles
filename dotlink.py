#!/usr/bin/env python

import os, re, sys

USER_IGNORE_FILENAME_TEMPLATE = '.%s_ignore'

def stripped_lines(filename):
    try:
        with open(filename, 'r') as f:
            lines = f.readlines()
    except IOError:
        lines = []
    return [line.strip() for line in lines]

repo_directory, script_filename = os.path.split(sys.argv[0])
script_basename, script_extension = os.path.splitext(script_filename)
user_ignore_filename = USER_IGNORE_FILENAME_TEMPLATE % script_basename
repo_filenames = os.listdir(repo_directory)

BUILTIN_IGNORE_PATTERNS = [script_filename, 'README', '^\.']
user_ignore_patterns = stripped_lines(user_ignore_filename)
ignore_patterns = BUILTIN_IGNORE_PATTERNS + user_ignore_patterns
joined_ignore_patterns = "(" + ")|(".join(ignore_patterns) + ")"
ignore_regex = re.compile(joined_ignore_patterns)
not_ignored = lambda filename: not ignore_regex.match(filename)

link_filenames = filter(not_ignored, repo_filenames)

print ignore_patterns
print repo_filenames
print link_filenames
