#!/bin/bash
#set -x
#=====================VARIABLES========================

#--------------------TAB COMPLETION---------------------------------



_my_completion() {
    local cur prev
    . ~/.LAGO_USR_INFO
    HOME_FILE=~/.LAGO_USR_INFO
    LAST_LINE=$(/bin/tail -n 1 $HOME_FILE)
    FILE_NAME=${LAST_LINE#TOP_FILE=} && FILE_NAME=${FILE_NAME%.sv}
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    JSON_FILE=${LAGO_DIR}/files/Baseboard/${FILE_NAME}.json
    words=($(/bin/grep -Eo '[[:alnum:]_\[\]\-]+' "$JSON_FILE" | /bin/sed 's/_/ /g'))
    # add your completion logic here
    COMPREPLY=( $(compgen -W "${words[*]}" -- ${cur}) )
    return 0
}

# register the completion function
complete -F _my_completion create connect plug add rename delete 


_my_plug_completion() {
    local cur prev
    LAGO_LIB="${LAGO_DIR}/files/library"
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    if [ "${prev}" == "-inst" ]; then
        words=($(ls ${LAGO_LIB}/*.sv | xargs -n1 basename ))
        COMPREPLY=( $(compgen -W "${words[*]}" -- ${cur}) )
    fi
    return 0
}

# register the completion function for plug with -inst option
complete -F _my_plug_completion plug
