# .bashrc is the user-specific configuration file for the Bourne Again Shell (bash). It must exist
# in $HOME and will be sourced by bash after system-wide configuration files in /etc for all non-
# login shells..bashrc is used
# for non-login interactive shells (e.g. Terminal), while .bash_profile is used for
# login shells (e.g. remote ssh).
# See http://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html for information on
# bash startup file execution precedence.
# See http://www.linuxfromscratch.org/blfs/view/svn/postlfs/profile.html for what should go where.

# TBD: Some more links to read:
# http://www.linuxquestions.org/questions/linux-general-1/etc-profile-v-s-etc-bashrc-273992/
# http://www.linuxfromscratch.org/blfs/view/svn/postlfs/profile.html
# http://savage.net.au/Linux/html/bash.files.html
# http://superuser.com/questions/147043/where-to-find-the-bashrc-file-on-mac-os-x-snow-leopard-and-lion
# http://hacktux.com/bash/bashrc/bash_profile
# http://parsedcontent.blogspot.com/2011/09/osx-and-bashrc.html
# http://superuser.com/questions/479703/profile-and-bashrc-doesnt-work-on-my-mac
# http://apple.stackexchange.com/questions/14651/where-are-environment-variables-specified-when-profile-bash-login-bash-prof/14655#14655

# TBD: address OS X specifics, organize the file much better than it is, clean up comments for
# consistency, how much of this should go in...~/Code/scripts? ~/bin?

# Change readline to vi mode for bash shells. See ~/.inputrc for non-bash applications as well as
# for vi keymap modifications that apply to all readline-using programs, including bash.

set -o vi

# Convenient aliases.

alias cls='clear'
# TBD: ls -l@? ls -l? does the ls alias get expanded by default in subsequent aliases? I bet it
# does
alias ls='ls -GF'
alias la='ls -laGF'

# Modern Xcode on OS X installs Git inside the application bundle. Use the Git that comes with Xcode
# for now. See man xcrun for more information.

alias git='xcrun git'

# The Launch Services database on OS X frequently gets corrupted such that the Open With menu
# contains a number of incorrect and duplicate entries. Alias a command to make cleaning it easy.

alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -all system,local,user'

# Sometimes a file will be marked to explicitly open with some custom program or another. Reverting
# it to the default involves deleting extended attributes for that file. Use this with extreme
# caution as there may be data beyond the opening application stored in the resource fork, which
# this command unconditionally deletes.

alias nukeresourcefork='xattr -d com.apple.ResourceFork'

# Define a function that will output each of the 16 ANSI color numbers and LSCOLORS identifiers to
# the terminal in the actual corresponding color. This can be used to check color mappings in
# terminals that allow for the ANSI colors to be overridden.

function colors {
    letters=(a b c d e f g h A B C D E F G H)
    for i in {0..15}
    do
        printf "%s%2d (%s) " `tput setaf $i` $i ${letters[$i]}
        if (( ($i + 1) % 8 == 0 )); then printf "\n"; fi
    done
}

# Define a few colors for later use. The escaped brackets tell bash that they are non-printable and
# keep word-wrapping sane. The colors are defined with their ANSI color numbers rather than their
# names because the actual colors may not correspond to the classic names if the RGB for the stock
# colors are redefined in a terminal that supports this feature in its preferences or profiles.

COLOR_DEFAULT='\['`tput sgr0`'\]'
COLOR_0='\['`tput setaf 0`'\]'
COLOR_1='\['`tput setaf 1`'\]'
COLOR_2='\['`tput setaf 2`'\]'
COLOR_3='\['`tput setaf 3`'\]'
COLOR_4='\['`tput setaf 4`'\]'
COLOR_5='\['`tput setaf 5`'\]'
COLOR_6='\['`tput setaf 6`'\]'
COLOR_7='\['`tput setaf 7`'\]'

# Configure colorized ls output. See the ls man page for the format.

export LSCOLORS="fxexbxbxcxbxbxcxcxgxgx"

# Configure colorized grep output.

export GREP_OPTIONS="--color"

# Build a prompt decorator if we're in a Git repo. The branch name appears in one color if the
# branch is master and in a different color otherwise. An asterisk appears if the working directory
# is not clean.

function parse_git_branch {

    status="$(git status 2> /dev/null)"
    pattern="^# On branch ([^${IFS}]*)"
    git_prompt_decorator=""

    if [[ ${status} =~ ${pattern} ]]; then

        branch=${BASH_REMATCH[1]}
        dirty=""
        color=${COLOR_1}

        if [[ ! ${status} =~ "working directory clean" ]]; then
            dirty="*"
        fi

        if [[ ${branch} == "master" ]]; then
            color=${COLOR_2}
        fi

        git_prompt_decorator="on ${color}${branch}${COLOR_DEFAULT}${dirty} "
    fi
}

# Set up a function that is run every time the shell prompt is generated.

function set_shell_prompt {
    parse_git_branch
    PS1="${COLOR_3}\h${COLOR_DEFAULT}:${COLOR_5}\W${COLOR_DEFAULT} ${git_prompt_decorator}\$ "
}

# TBD: /etc/profile doesn't get executed for non-login bashes; for login shells, everything is fine,
# as /etc/profile will define update_cwd or whatever. For non-login bashes, that won't get exported,
# but this prompt will, leading to an error. Non-login bashes still get the git prompt magic,
# though, since they source ~/.bashrc, which defines it for every non-login bash.

export PROMPT_COMMAND+="set_shell_prompt;"
