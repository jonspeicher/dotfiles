#!/usr/bin/env python

import collections, glob, itertools, os, shutil

DOTFILE_DIRECTORY = 'Dotfiles'
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

leaders = collections.defaultdict(constant_factory(DEFAULT_LEADER), pairs(LEADER_FILENAME))
ignore_filenames = lines(IGNORE_FILENAME)
filenames = os.listdir(DOTFILE_DIRECTORY)
source_filenames = [filename for filename in filenames if filename not in ignore_filenames]
dest_filenames = [leaders[filename] + filename for filename in source_filenames]
source_filepaths = [os.path.join(DOTFILE_DIRECTORY, filename) for filename in source_filenames]
dest_filepaths = [os.path.join('.', filename) for filename in dest_filenames]
copy_pairs = zip(source_filepaths, dest_filepaths)

for copy_pair in copy_pairs:
    print 'Copying ' + copy_pair[0] + ' to ' + copy_pair[1]
    shutil.copyfile(copy_pair[0], copy_pair[1])
