#!/usr/bin/env python

# TBD: test for the existance of os.link or whatever, then try mklink
# as a fallback? clean up the organization of this file? vim -> vimfiles,
# .linkdotrc? clean up the conditional in make_filter? make_include_filter and make_exclude_filter?

import os, re, sys

USER_IGNORE_FILENAME_TEMPLATE = '.%s_ignore'
BUILTIN_IGNORE_PATTERNS = ['^README.*', '^\..*']

USER_PLATFORM_PATTERN_TEMPLATE = '.*\.%s$'
BUILTIN_PLATFORM_PATTERNS = ['^[^\.]+$']

def stripped_lines(filename):
    try:
        with open(filename, 'r') as file_to_read:
            lines = file_to_read.readlines()
    except IOError:
        lines = []
    return [line.strip() for line in lines]

def make_filter(patterns, negate = False):
    joined_patterns = "(" + ")|(".join(patterns) + ")"
    regex = re.compile(joined_patterns)
    if negate:
        filter_lambda = lambda item: not regex.match(item)
    else:
        filter_lambda = lambda item: regex.match(item)
    return filter_lambda

def strip_platform(filename):
    return re.sub('\.[^\.]+$', '', filename)

def link(source_filename, dest_filename):
    print 'Linking %s to %s' % (source_filename, dest_filename)

repo_directory, script_filename = os.path.split(sys.argv[0])
script_basename, script_extension = os.path.splitext(script_filename)
user_ignore_filename = USER_IGNORE_FILENAME_TEMPLATE % script_basename
repo_filenames = os.listdir(repo_directory)

user_ignore_patterns = stripped_lines(user_ignore_filename)
ignore_patterns = BUILTIN_IGNORE_PATTERNS + user_ignore_patterns + [script_filename]
not_ignored = make_filter(ignore_patterns, negate = True)

user_platforms = sys.argv[1:] if len(sys.argv) >= 2 else []
user_platform_patterns = [USER_PLATFORM_PATTERN_TEMPLATE % platform for platform in user_platforms]
platform_patterns = BUILTIN_PLATFORM_PATTERNS + user_platform_patterns
for_platform = make_filter(platform_patterns)

unignored_filenames = filter(not_ignored, repo_filenames)
platform_filenames = filter(for_platform, unignored_filenames)
source_filenames = [os.path.join(repo_directory, filename) for filename in platform_filenames]
dest_filenames = ['.' + strip_platform(filename) for filename in platform_filenames]
link_pairs = zip(source_filenames, dest_filenames)

for pair in link_pairs:
    link(*pair)
