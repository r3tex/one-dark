#!/usr/bin/env bash
PROMPT_DIRTRIM=2 # bash4 and above

DEBUG=0
debug() {
    if [[ ${DEBUG} -ne 0 ]]; then
        >&2 echo -e $*
    fi
}

CURRENT_BG='NONE'
CURRENT_RBG='NONE'
SEGMENT_SEPARATOR=''
RIGHT_SEPARATOR=''
LEFT_SUBSEG=''
RIGHT_SUBSEG=''

text_effect() {
    case "$1" in
        reset)      echo 0;;
        bold)       echo 1;;
        underline)  echo 4;;
    esac
}

fg_color() {
    case "$1" in
        black)      echo 38\;2\;40\;44\;52;;
        red)        echo 38\;2\;224\;108\;117;;
        green)      echo 38\;2\;152\;195\;121;;
        yellow)     echo 38\;2\;229\;192\;123;;
        blue)       echo 38\;2\;97\;175\;239;;
        magenta)    echo 38\;2\;198\;120\;221;;
        cyan)       echo 38\;2\;86\;182\;194;;
        white)      echo 38\;2\;171\;178\;191;;
        orange)     echo 38\;2\;209\;154\;102;;
    esac
}

bg_color() {
    case "$1" in
        black)      echo 48\;2\;40\;44\;52;;
        red)        echo 48\;2\;224\;108\;117;;
        green)      echo 48\;2\;152\;195\;121;;
        yellow)     echo 48\;2\;229\;192\;123;;
        blue)       echo 48\;2\;97\;175\;239;;
        magenta)    echo 48\;2\;198\;120\;221;;
        cyan)       echo 48\;2\;86\;182\;194;;
        white)      echo 48\;2\;171\;178\;191;;
        orange)     echo 48\;2\;209\;154\;102;;
    esac;
}

ansi() {
    local seq
    declare -a mycodes=("${!1}")

    debug "ansi: ${!1} all: $* aka ${mycodes[@]}"

    seq=""
    for ((i = 0; i < ${#mycodes[@]}; i++)); do
        if [[ -n $seq ]]; then
            seq="${seq};"
        fi
        seq="${seq}${mycodes[$i]}"
    done
    debug "ansi debug:" '\\[\\033['${seq}'m\\]'
    echo -ne '\[\033['${seq}'m\]'
}

ansi_single() {
    echo -ne '\[\033['$1'm\]'
}

prompt_segment() {
    local bg fg
    declare -a codes

    debug "Prompting $1 $2 $3"

    codes=("${codes[@]}" $(text_effect reset))
    if [[ -n $1 ]]; then
        bg=$(bg_color $1)
        codes=("${codes[@]}" $bg)
        debug "Added $bg as background to codes"
    fi
    if [[ -n $2 ]]; then
        fg=$(fg_color $2)
        codes=("${codes[@]}" $fg)
        debug "Added $fg as foreground to codes"
    fi

    debug "Codes: "

    if [[ $CURRENT_BG != NONE && $1 != $CURRENT_BG ]]; then
        declare -a intermediate=($(fg_color $CURRENT_BG) $(bg_color $1))
        debug "pre prompt " $(ansi intermediate[@])
        PR="$PR $(ansi intermediate[@])$SEGMENT_SEPARATOR"
        debug "post prompt " $(ansi codes[@])
        PR="$PR$(ansi codes[@]) "
    else
        debug "no current BG, codes is $codes[@]"
        PR="$PR$(ansi codes[@]) "
    fi
    CURRENT_BG=$1
    [[ -n $3 ]] && PR="$PR$3"
}

prompt_end() {
    if [[ -n $CURRENT_BG ]]; then
        declare -a codes=($(text_effect reset) $(fg_color $CURRENT_BG))
        PR="$PR $(ansi codes[@])$SEGMENT_SEPARATOR"
    fi
    declare -a reset=($(text_effect reset))
    PR="$PR $(ansi reset[@])"
    CURRENT_BG=''
}

prompt_virtualenv() {
    if [[ -n $VIRTUAL_ENV ]]; then
        color=cyan
        prompt_segment $color $PRIMARY_FG
        prompt_segment $color white "$(basename $VIRTUAL_ENV)"
    fi
}


prompt_context() {
    local user=`whoami`

    if [[ $user != $DEFAULT_USER || -n $SSH_CLIENT ]]; then
        prompt_segment black default "\h"
    fi
}

prompt_histdt() {
    prompt_segment black default "\! [\A]"
}


git_status_dirty() {
    dirty=$(git status -s 2> /dev/null | tail -n 1)
    [[ -n $dirty ]] && echo " ●"
}

prompt_git() {
    local ref dirty
    if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        ZSH_THEME_GIT_PROMPT_DIRTY='±'
        dirty=$(git_status_dirty)
        ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
        if [[ -n $dirty ]]; then
            prompt_segment red black
        else
            prompt_segment green black
        fi
        PR="$PR${ref/refs\/heads\// }$dirty"
    fi
}

prompt_dir() {
    prompt_segment blue black '\w'
}

prompt_status() {
    local symbols
    symbols=()
    [[ $RETVAL -ne 0 ]] && symbols+="$(ansi_single $(fg_color red))✘"
    [[ $UID -eq 0 ]] && symbols+="$(ansi_single $(fg_color yellow))⚡"
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="$(ansi_single $(fg_color cyan))⚙"

    [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

build_prompt() {
    [[ ! -z ${AG_EMACS_DIR+x} ]] && prompt_emacsdir
    prompt_status
    [[ -z ${AG_NO_CONTEXT+x} ]] && prompt_context
    prompt_virtualenv
    prompt_dir
    prompt_git
    prompt_end
}

set_bash_prompt() {
    RETVAL=$?
    PR=""
    PRIGHT=""
    CURRENT_BG=NONE
    PR="$(ansi_single $(text_effect reset))"
    build_prompt
    PS1=$PR
}

PROMPT_COMMAND=set_bash_prompt
