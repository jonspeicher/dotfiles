# .bashrc is for non-login interactive shells (e.g. Terminal),
# .bash_profile is for login shells (e.g. remote ssh).

# Change readline to vi mode.

set -o vi

# Convenient aliases.

alias cls='clear'
alias ls='ls -GF'
alias la='ls -laGF'

# Modern Xcode installs git inside the application bundle. Use the git that comes with Xcode
# for now. See man xcrun for more information.

alias git='xcrun git'

# Define a few colors for later use.  The escaped brackets tell bash that they
# are non-printable and keep word-wrapping sane.  The LSCOLORS identifier
# follows each color.  The RGB for the 16 stock ANSI colors are redefined in
# Terminal under Lion and above using the built-in preferences.

BLACK='\['`tput setaf 0`'\]' # a
RED='\['`tput setaf 1`'\]' # b
GREEN='\['`tput setaf 2`'\]' # c
ORANGE='\['`tput setaf 3`'\]' # d
PURPLE='\['`tput setaf 4`'\]' # e
PINK='\['`tput setaf 5`'\]' # f
CYAN='\['`tput setaf 6`'\]' # g
WHITE='\['`tput setaf 7`'\]' # h
DEFAULT='\['`tput sgr0`'\]' # x

# Configure colorized ls output.  See the ls man page for the format.

export LSCOLORS="fxexxxxxcxxxxxxxxxgxgx"

# Build a prompt decorator if we're in a git repo.  The branch name is included
# in green if the branch is master, red otherwise.  An asterisk appears if the
# working directory is not clean.

function parse_git_branch {

    status="$(git status 2> /dev/null)"
    pattern="^# On branch ([^${IFS}]*)"
    git_prompt_decorator=""

    if [[ ${status} =~ ${pattern} ]]; then

        branch=${BASH_REMATCH[1]}
        dirty=""
        color=${RED}

        if [[ ! ${status} =~ "working directory clean" ]]; then
            dirty="*"
        fi

        if [[ ${branch} == "master" ]]; then
            color=${GREEN}
        fi

        git_prompt_decorator="on ${color}${branch}${DEFAULT}${dirty} "
    fi
}

# Set up a function that is run every time the shell prompt is generated.

function set_shell_prompt {
    parse_git_branch
    PS1="${ORANGE}\h${DEFAULT}:${PINK}\W${DEFAULT} ${git_prompt_decorator}\$ "
}

export PROMPT_COMMAND=set_shell_prompt
