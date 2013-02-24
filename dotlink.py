#!/usr/bin/env python

import os, re, sys

USER_IGNORE_FILENAME_TEMPLATE = '.%s_ignore'
BUILTIN_IGNORE_PATTERNS = ['README', '^\.']
BUILTIN_PLATFORM_PATTERNS = ['.*']

def stripped_lines(filename):
    try:
        with open(filename, 'r') as file_to_read:
            lines = file_to_read.readlines()
    except IOError:
        lines = []
    return [line.strip() for line in lines]

repo_directory, script_filename = os.path.split(sys.argv[0])
script_basename, script_extension = os.path.splitext(script_filename)
user_ignore_filename = USER_IGNORE_FILENAME_TEMPLATE % script_basename
repo_filenames = os.listdir(repo_directory)

user_ignore_patterns = stripped_lines(user_ignore_filename)
ignore_patterns = BUILTIN_IGNORE_PATTERNS + user_ignore_patterns + [script_filename]
joined_ignore_patterns = "(" + ")|(".join(ignore_patterns) + ")"
ignore_regex = re.compile(joined_ignore_patterns)
not_ignored = lambda filename: not ignore_regex.match(filename)

platforms = sys.argv[1:] if len(sys.argv) >= 2 else []
platform_patterns = BUILTIN_PLATFORM_PATTERNS
joined_platform_patterns = "(" + ")|(".join(platform_patterns) + ")"
platform_regex = re.compile(joined_platform_patterns)
for_platform = lambda filename: platform_regex.match(filename)

unignored_filenames = filter(not_ignored, repo_filenames)
platform_filenames = filter(for_platform, unignored_filenames)
link_filenames = platform_filenames

print repo_filenames
print link_filenames
