function fish_prompt --description 'Write out the prompt'
    set basename (basename $PWD)
    set cwd (string replace -r '^'"$USER"'($|/)' '~$1' $basename)

    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showuntrackedfiles 1
    set -g __fish_git_prompt_showcolorhints 1

    echo -n -s (set_color $fish_color_host) (prompt_hostname) ':' (set_color $fish_color_cwd) $cwd (set_color normal) (fish_vcs_prompt) (set_color normal) ' > '
end
