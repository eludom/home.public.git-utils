# git stuff ... and ???setting the prompt using git???

# simple aliases
alias glm='git ls-files -m'
alias glf='git ls-files'
alias gam='git add `git ls-files -m`'
alias gcm='git commit -m'
#alias gs='git status'
alias gs='gitcheck -s'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gd="git diff"
alias grv="git remote -v"

# because rcs....
alias co="git checkout"
alias ci="git commit"

# shortcuts to my gitcheck srript
alias gc=gitcheck
alias gcs='gitcheck -s'
alias gcf='gitcheck -f'

# Deep magic from before the dawn of time.
#
# Add git branch to the prompt
#
# http://thelucid.com/2008/12/02/git-setting-up-a-remote-repository-and-doing-an-initial-push/
#

function git-branch-name {
    # Get the current git branch nane.
    #
    # Yes, I really am running git and cut with every promt
    #

    git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3
}

function git-branch-prompt {
    # Print the branch name with formatting if it exists

    local branch=`git-branch-name`
    if [ $branch ]; then
        printf " [%s]" $branch;
    fi
}

function prompt-hostname {
    # Get the current hostname or blame the mac
    #
    # and let's run head or echo on every prompt to !!!
    #

    if [ -f ~/etc/hostname ]; then
        head -1 ~/etc/hostname;
    elif [ -f /etc/hostname ]; then
        head -1 /etc/hostname;
    else echo STUPIDMAC; fi
}

# And now the deep magic

# I *think* this was supposed to set the prompt to root (#)
# in a new shell and/or a subsell, buy maybe not working
export PS1="\# [\t] \u@\h \W/\$(git-branch-prompt) $ "

# Set the prompt to to something like:
#
#   gmj@ed stow [master] $
#
# with, of course, ANSI control characters imbedded
# to colorize the prompt.  Are we done yet ???
#
PS1="\u@\$(prompt-hostname) \[\033[0;36m\]\W\[\033[0m\]\[\033[0;32m\]\$(git-branch-prompt)\[\033[0m\] \$ "

function git-fetch-urls {
    if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "help" ]; then
        echo "$FUNCNAME: Usage: $FUNCNAME --help|[dir [dir [dir ...]]]" 1>&2
        echo "$FUNCNAME: Show the git fetch URLs for git repos in a list of directories" 1>&2
        return
    fi

    # args passed in via ARGV
    args=("$@")

    # add $PWD if none
    if [ ${#args[@]} == 0 ]; then
        args+=($PWD)
    fi

    # show fetch for all dirs
    for DIR in "${args[@]}"; do
        (cd $DIR > /dev/null; \
         git remote -v | \
             grep fetch |\
             head -1| \
             sed -r 's#\w+\W+##;s# +\(fetch.*##' \
         )
    done

}
