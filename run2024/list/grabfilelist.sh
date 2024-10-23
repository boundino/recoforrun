runnumber=$1 # 375xxx
pd=${2:-PhysicsHIPhysicsRawPrime0}

[[ $runnumber =~ ^[0-9]{6}$ ]] && {

    t_run="${runnumber:0:3}/${runnumber:3:3}"
    outputfile=${pd}_${runnumber}.txt
    rm $outputfile 2> /dev/null
    echo "/eos/cms/store/t0streamer/Data/$pd/000/$t_run/"
    for i in `ls -d /eos/cms/store/t0streamer/Data/$pd/000/$t_run/*`
    do
        echo "file:"$i >> $outputfile
    done
    # # mkdir -p /eos/cms/store/group/phys_heavyions/wangj/RECO2023/$pd/$t_run
}