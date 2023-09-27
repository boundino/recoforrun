runnumber=$1
pd=${2:-PhysicsHIPhysicsRawPrime0}


t_run=${runnumber/"/"/""}
echo $t_run
outputfile=${pd}_${t_run}.txt
rm $outputfile
for i in `ls -d /eos/cms/store/t0streamer/Data/$pd/000/$runnumber/*`
do
    echo "file:"$i >> $outputfile
done
mkdir -p /eos/cms/store/group/phys_heavyions/wangj/RECO2023/$pd/$t_run
