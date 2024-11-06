filepath=$(readlink -f $1) # input directory
outputfile=${filepath##*/}.root
echo $filepath
echo $outputfile

temp_file=$(mktemp)

[[ $filepath == /eos/cms/* ]] && {

    for i in `ls -d $filepath/*`
    do
        infile=file:$i
        echo $infile >> $temp_file
    done

} || {
    echo "usage: ./eosdir_to_filelist.sh [directory path starting from /eos/cms/]"
    echo "example: ./eosdir_to_filelist.sh /eos/cms/store/group/phys_heavyions/wangj/RECO2023/miniaod_PhysicsHIPhysicsRawPrime0_375549_ZB"
    exit 1
}

cat $temp_file
edmCopyPickMerge inputFiles_load=$temp_file outputFile=$outputfile maxSize=1000000
