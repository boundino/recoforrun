
[[ $1 == *.txt || ! -f $1 ]] && {
    for i in `cat $1`; do
        echo -n '"'$i'",'
    done
    echo
}
