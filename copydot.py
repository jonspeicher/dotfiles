#!/usr/bin/env python

import collections, glob, itertools, os, shutil

COMMON_DIRECTORY = 'Dotfiles'
CURRENT_DIRECTORY = '.'

IGNORE_FILENAME = '.copydot_ignore'
LEADER_FILENAME = '.copydot_leader'
DEFAULT_LEADER = '.'

def constant_factory(value):
    return itertools.repeat(value).next

def lines(filename):
    with open(filename, 'r') as f:
        return [line.strip() for line in f.readlines()]

def pairs(filename):
    for line in lines(filename):
        yield line.split()

def paths(directory, filenames):
    return [os.path.join(directory, filename) for filename in filenames]

def copy(source_paths, destination_paths):
    copy_pairs = zip(source_paths, destination_paths)
    for copy_pair in copy_pairs:
        source, destination = copy_pair[0], copy_pair[1]
        print 'Copying ' + source + ' to ' + destination
        shutil.copyfile(source, destination)

leaders = collections.defaultdict(constant_factory(DEFAULT_LEADER), pairs(LEADER_FILENAME))
ignore_filenames = lines(IGNORE_FILENAME)

filenames = os.listdir(COMMON_DIRECTORY)
common_filenames = [filename for filename in filenames if filename not in ignore_filenames]
common_paths = paths(COMMON_DIRECTORY, common_filenames)

cwd_filenames = [leaders[filename] + filename for filename in common_filenames]
cwd_paths = paths(CURRENT_DIRECTORY, cwd_filenames)

copy(common_paths, cwd_paths)
