filepath=${1:-/eos/cms/store/group/phys_heavyions/wangj/RECO2023/miniaod_PhysicsHIPhysicsRawPrime0_375549_ZB}
outputfile=${filepath##*/}.txt

[[ $filepath == /eos/cms/* ]] && {

    echo $outputfile
    rm $outputfile 2> /dev/null

    for i in `ls -d $filepath/*`
    do
        infile=${i/'/eos/cms'/}
        echo $infile >> $outputfile
    done

} || {
    echo "usage: ./eosdir_to_filelist.sh [directory path starting from /eos/cms/]"
    echo "example: ./eosdir_to_filelist.sh /eos/cms/store/group/phys_heavyions/wangj/RECO2023/miniaod_PhysicsHIPhysicsRawPrime0_375549_ZB"
    
}
