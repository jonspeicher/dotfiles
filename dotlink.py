#!/usr/bin/env python

import os, re, sys

def stripped_lines(filename):
    try:
        with open(filename, 'r') as f:
            lines = f.readlines()
    except IOError:
        lines = []
    return [line.strip() for line in lines]

repo_directory, script_filename = os.path.split(sys.argv[0])
repo_filenames = os.listdir(repo_directory)

# TBD: load user ignore patterns from file, append to list, put some or all in constant
user_ignore_filename = '.dotlink_ignore'
user_ignore_patterns = stripped_lines(user_ignore_filename)
print user_ignore_patterns
ignore_patterns = [script_filename, 'README', '^\.']
joined_ignore_patterns = "(" + ")|(".join(ignore_patterns) + ")"
ignore_regex = re.compile(joined_ignore_patterns)
not_ignored = lambda filename: not ignore_regex.match(filename)

link_filenames = filter(not_ignored, repo_filenames)

print ignore_patterns
print repo_filenames
print link_filenames
