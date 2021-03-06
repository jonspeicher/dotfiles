#!/usr/bin/env python

# TBD: inconsistency: .dotlink_ignore won't work if the leader is specified (with proper escaping)
#      and .dotlink_alias won't work if it isn't
# TBD: store .dotlink_ignore and .dotlink_alias somewhere for win/osx?

import os, re, subprocess, sys

USER_IGNORE_FILENAME_TEMPLATE = '.%s_ignore'      # .scriptname_ignore is the ignore config file
BUILTIN_IGNORE_PATTERNS = ['^README.*', '^\..*']  # Ignore README variants and dotfiles by default

USER_ALIAS_FILENAME_TEMPLATE = '.%s_alias'        # .scriptname_alias is the alias config file
BUILTIN_ALIASES = {}                              # Don't alias anything by default

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

def split_to_dict(lines):
    '''Return a dictionary of key/value pairs from each line split into a tuple on whitespace.'''
    return dict([line.split() for line in lines])

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

def link(source_path, destination_path):
    '''Create the destination filename as a platform-appropriate link to the source filename.'''
    print '%s => %s' % (destination_path, source_path)
    try:
        os.symlink(source_path, destination_path)
    except AttributeError:
        dir_link_switch = '/d' if os.path.isdir(source_path) else ''
        # TBD: This can actually fail with an OSError if for some reason it winds up here and the
        # subprocess call is not valid; that exception won't be caught since this isn't tried. This
        # could also return a nonzero status code which could be caught with subprocess.check_call,
        # but it's a) not tried and b) unclear what to do if it's caught.
        subprocess.call(['MKLINK', dir_link_switch, destination_path, source_path])
    except OSError:
        # TBD: The code will wind up here if the file exists an an os.symlink is attempted; this is
        # fine except if changing platforms and wanting to link e.g. foo -> foo.osx when it is
        # already linked to foo -> foo.win; this code won't update the link
        pass

# Determine the relevant directories, paths, and filenames.

repo_directory, script_filename = os.path.split(sys.argv[0])
script_basename, script_extension = os.path.splitext(script_filename)
user_ignore_filename = USER_IGNORE_FILENAME_TEMPLATE % script_basename
user_alias_filename = USER_ALIAS_FILENAME_TEMPLATE % script_basename
repo_filenames = os.listdir(repo_directory)

# Build a filter to exclude files based on the configured exclude patterns.

user_ignore_patterns = stripped_lines(user_ignore_filename)
ignore_patterns = BUILTIN_IGNORE_PATTERNS + user_ignore_patterns + [script_filename]
not_ignored = make_exclude_filter(ignore_patterns)

# Build a dictionary to contain the configured destination filename aliases.

user_aliases = split_to_dict(stripped_lines(user_alias_filename))
aliases = BUILTIN_ALIASES
aliases.update(user_aliases)

# Build patterns and a filter to include platforms based on the specified platform identifiers.

user_platforms = sys.argv[1:] if len(sys.argv) >= 2 else []
user_platform_patterns = [USER_PLATFORM_PATTERN_TEMPLATE % platform for platform in user_platforms]
platform_patterns = BUILTIN_PLATFORM_PATTERNS + user_platform_patterns
for_platform = make_include_filter(platform_patterns)

# Filter the list of files in the repo and transform it into a list of paths to create links to.

filtered_filenames = filter(for_platform, filter(not_ignored, repo_filenames))
source_paths = [os.path.join(repo_directory, filename) for filename in filtered_filenames]

# Transform the list of source filenames into a list of aliased paths to link to those files.

dotted_filenames = ['.' + strip_platform(filename) for filename in filtered_filenames]
aliased_filenames = [aliases.get(filename, filename) for filename in dotted_filenames]
destination_paths = [os.path.join('.', filename) for filename in aliased_filenames]

# Create the destination paths as links to the source paths.

link_pairs = zip(source_paths, destination_paths)

for pair in link_pairs:
    # TBD: The printing should be done here, along with maybe some indication that a file was
    # skipped because it existed or something; maybe for s,d in zip(sp,dp):
    link(*pair)
