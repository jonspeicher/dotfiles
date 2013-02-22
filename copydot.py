#!/usr/bin/env python

# TBD: .vimrc vs. _vimrc, .vim vs vimfiles, Windows vs. OS X, copying vs. linking, recursive copy of
# .vim/vimfiles? Symlinking on Windows? Finding .copydot_ files when invoked from outside the dotfiles
# directory?

# TBD: Moment of clarity: .copydot_ignore and .copydot_leader or whatever are OS-specific and maybe even
# machine-specific, so they should live in ~ on each machine, and copydot should be run from ~ on each machine,
# so finding them shouldn't be hard. Or, there can be "base" versions like copydot_ignore.win that live in dotfiles
# that can be copied up when copydot is first run, and everything should be symlinked, even on Windows with mklink
# or whatever, unless and until I decide I need copying, which I should try to get by without. KISS.

# TBD: idea: dotfiles/copydot.py, dotfiles/copydot/copydot_leader.win copydot_ignore.win copydot_leader.osx
# copydot_ignore.osx; copydot, when run from ~, copies those templates up if not found, then links all other
# files and directories (e.g. .vim/vimfiles) using a system-specific symlink call, period, end of story, for now.
# What later happens with Windows-specific gitconfig for example?

# TBD: thoughts from the ride home last night: Have several steps. Keep all the files flat, and use platform-
# specific extensions, e.g. gitconfig.win and gitconfig.osx. There could be a gitconfig common that was included
# by both, and the script would assemble all common files, then assemble all platform-specific files, then do
# the linking. The vimfiles directory could be linked, and things like color schemes could be added as git
# subprojects if it's at all possible. The very first thing the script could do would be to copy into ~ a
# copydot_ignore.win file or whatever if it doesn't exist, or this could be a special 'copydot init win' step
# or something. I could even go as far as having the script init with 'copydot init win jspeicher@vascor.com' and
# have it set my email address in gitconfig but maybe that's getting a little bit out-of-hand, although, maybe
# it could copy up a stub gitconfig that included gitconfig-platform-win and gitconfig-platform-common or something
# and just let me edit that by hand to get the email address in there. The leader would have to be a full rename
# file so that it could handle things like .vim vs vimfiles.

# TBD: idea: combine ignore and leader in one file, format:
#
#   autotest
#   vimrc       _vimrc
#
# meaning autotest is ignored and vimrc is linked to _vimrc; there could also be a special character
# meaning that a file is to be ignored, like:
#
#   autotest    -
#   vimrc       _vimrc

import collections, glob, itertools, os, shutil, sys

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

def copy_from_to(source_paths, destination_paths, print_copy):
    copy_pairs = zip(source_paths, destination_paths)
    for copy_pair in copy_pairs:
        source, destination = copy_pair[0], copy_pair[1]
        print_copy(source, destination)
        shutil.copyfile(source, destination)

def print_file_copy_from_to(from_path, to_path):
    print '    ' + os.path.basename(from_path) + ' => ' + os.path.basename(to_path)

copy_out = ((len(sys.argv) > 1) and (sys.argv[1] == 'out'))
leaders = collections.defaultdict(constant_factory(DEFAULT_LEADER), pairs(LEADER_FILENAME))
ignore_filenames = lines(IGNORE_FILENAME)

filenames = os.listdir(COMMON_DIRECTORY)
common_filenames = [filename for filename in filenames if filename not in ignore_filenames]
common_paths = paths(COMMON_DIRECTORY, common_filenames)

cwd_filenames = [leaders[filename] + filename for filename in common_filenames]
cwd_paths = paths(CURRENT_DIRECTORY, cwd_filenames)

if copy_out:
    print '\nCopying out from ' + CURRENT_DIRECTORY + ' to ' + COMMON_DIRECTORY
    copy_from_to(cwd_paths, common_paths, print_file_copy_from_to)
else:
    print '\nCopying in to ' + CURRENT_DIRECTORY + ' from ' + COMMON_DIRECTORY
    copy_from_to(common_paths, cwd_paths, print_file_copy_from_to)
