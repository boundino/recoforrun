# file:/eos/cms/store/t0streamer/Data/PhysicsHIPhysicsRawPrime43/000/387/867/run387867_ls0001_streamPhysicsHIPhysicsRawPrime43_StorageManager.dat

[[ $1 == *.txt && -f $1 && $2 =~ ^[0-9]+ && $3 =~ ^[0-9]+ ]] && {

    echo $1
    
    tmp_file=$(mktemp)
    for i in `cat $1`; do
        ls=${i##*_ls}
        ls=${ls%%_stream*}
        ls=`echo $ls | sed -E 's/^(0)+//'`

        [[ $ls -lt $2 || $ls -gt $3 ]] && continue
        
        echo $i >> $tmp_file
    done

    diff $1 $tmp_file --old-group-format=$'\e[38;2;210;106;112m%<\e[0m' --new-group-format=$'\e[38;2;132;192;127m%>\e[0m' --report-identical-files --unchanged-group-format=''
    mv $tmp_file $1
}
