loop ()
{
    if [ "$*" = "" ]; then
        echo "Usage:\n\tloop <args>\n" 1>&2;
        return 1;
    fi;
    count=1;
    while true; do
        echo "`date`: Running iteration $count: $*" 1>&2;
        "$@";
        if [ "$?" != "0" ]; then
            echo "`date`: $* failed at iteration $count" 1>&2;
            break;
        else
            echo "`date`: $* passed at iteration $count" 1>&2;
        fi;
        count=$(( $count + 1 ));
    done
}

alias v="cd $HOME/dev/rust/vrproto/"
alias c_w='cargo watch -s "cargo check --color always 2>&1 | head -63" -c -q'
alias c_t='cargo watch -s "cargo test --color always 2>&1| head -63" -c -q'
alias t="cd $HOME/dev/rust/threes"
alias s="cd $HOME/dev/rust/space_survivors"
alias r="(s;./wsl-launch.sh)"
