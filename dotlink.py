#!/usr/bin/env python

# TBD: clean up the organization of this file? vim -> vimfiles, .linkdotrc?

import os, re, sys

USER_IGNORE_FILENAME_TEMPLATE = '.%s_ignore'      # .scriptname_ignore is the ignore config file
BUILTIN_IGNORE_PATTERNS = ['^README.*', '^\..*']  # Ignore README variants and dotfiles by default

USER_PLATFORM_PATTERN_TEMPLATE = '.*\.%s$'        # The platform is indicated by the file extension
BUILTIN_PLATFORM_PATTERNS = ['^[^\.]+$']          # Include files with no platform by default

def stripped_lines(filename):
    '''Return a list of lines from the file, each stripped of leading and trailing whitespace.'''
    try:
        with open(filename, 'r') as file_to_read:
            lines = file_to_read.readlines()
    except IOError:
        lines = []
    return [line.strip() for line in lines]

def make_include_filter(patterns):
    '''Return a filter predicate that includes strings matching any of the patterns provided.'''
    joined_patterns = "(" + ")|(".join(patterns) + ")"
    regex = re.compile(joined_patterns)
    return lambda item: regex.match(item)

def make_exclude_filter(patterns):
    '''Return a filter predicate that excludes strings matching any of the patterns provided.'''
    include_filter = make_include_filter(patterns)
    return lambda item: not include_filter(item)

def strip_platform(filename):
    '''Strip the platform identifier, which is just the file extension, from the given filename.'''
    basename, extension = os.path.splitext(filename)
    return basename

def link(source_path, dest_path):
    '''Create the destination filename as a platform-appropriate link to the source filename.'''
    # TBD: This should try os.link and then fall back to shelling to mklink
    print 'Linking %s to %s' % (source_path, dest_path)

# Determine the relevant directories, paths, and filenames.
repo_directory, script_filename = os.path.split(sys.argv[0])
script_basename, script_extension = os.path.splitext(script_filename)
user_ignore_filename = USER_IGNORE_FILENAME_TEMPLATE % script_basename
repo_filenames = os.listdir(repo_directory)

# Build a filter to exclude files based on the configured exclude patterns.
user_ignore_patterns = stripped_lines(user_ignore_filename)
ignore_patterns = BUILTIN_IGNORE_PATTERNS + user_ignore_patterns + [script_filename]
not_ignored = make_exclude_filter(ignore_patterns)

# Build patterns and a filter to include platforms based on the specified platform identifiers.
user_platforms = sys.argv[1:] if len(sys.argv) >= 2 else []
user_platform_patterns = [USER_PLATFORM_PATTERN_TEMPLATE % platform for platform in user_platforms]
platform_patterns = BUILTIN_PLATFORM_PATTERNS + user_platform_patterns
for_platform = make_include_filter(platform_patterns)

# Filter the list of files in the repo and transform it into a list of paths to create links to.
source_filenames = filter(for_platform, filter(not_ignored, repo_filenames))
source_paths = [os.path.join(repo_directory, filename) for filename in source_filenames]

# Transform the list of source filenames into a list of links to create to those source files.
dest_paths = ['.' + strip_platform(filename) for filename in source_filenames]

# Create the destination paths as links to the source paths.
link_pairs = zip(source_paths, dest_paths)
for pair in link_pairs:
    link(*pair)
