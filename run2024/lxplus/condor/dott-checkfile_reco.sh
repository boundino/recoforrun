#!/bin/bash

######
# Need to turn on ivars.inputFiles and ivars.outputFile
######

if [[ $0 != *.sh ]]
then
    echo -e "\e[31;1merror:\e[0m use \e[32;1m./script.sh\e[0m instead of \e[32;1msource script.sh\e[0m"
    return 1
fi

#
MAXFILENO=100000
#
runjobs=${1:-0}

PRIMARY="miniaod" # event content
tag="_HLT_HIPhysics_v14" # hlt filter
config="recoPbPbprime2mini_RAW2DIGI_L1Reco_RECO_PAT_2.py"
# config="recoUPCraw2miniaod_RAW2DIGI_L1Reco_RECO_PAT.py"

INPUTS=(
    # list/PhysicsPPRefZeroBiasPlusForward0_387590.txt
    # list/PhysicsPPRefHardProbes0_387607.txt
    # list/PhysicsPPRefDoubleMuon0_387607.txt
    # list/PhysicsPPRefSingleMuon0_387590.txt
    # list/PhysicsHIPhysicsRawPrime0_388095.txt
    # list/PhysicsHIForward0_388353.txt
    list/HIExpressRawPrime_388769.txt
    # list/PhysicsHIPhysicsRawPrime0_388306.txt
    # list/PhysicsHIPhysicsRawPrime40_388095.txt
    # list/PhysicsHIPhysicsRawPrime41_388095.txt
    # list/PhysicsHIPhysicsRawPrime42_388095.txt
    # list/PhysicsHIPhysicsRawPrime43_388095.txt
    # list/PhysicsHIPhysicsRawPrime44_388095.txt
    # list/PhysicsHIPhysicsRawPrime45_388095.txt
    # list/PhysicsHIPhysicsRawPrime46_388095.txt
    # list/PhysicsHIPhysicsRawPrime47_388095.txt
    # list/PhysicsHIPhysicsRawPrime48_388095.txt
    # list/PhysicsHIPhysicsRawPrime49_388095.txt
    # list/PhysicsHIPhysicsRawPrime50_388095.txt
    # list/PhysicsHIPhysicsRawPrime51_388095.txt
    # list/PhysicsHIPhysicsRawPrime52_388095.txt
    # list/PhysicsHIPhysicsRawPrime53_388095.txt
    # list/PhysicsHIPhysicsRawPrime54_388095.txt
    # list/PhysicsHIPhysicsRawPrime55_388095.txt
    # list/PhysicsHIPhysicsRawPrime56_388095.txt
    # list/PhysicsHIPhysicsRawPrime57_388095.txt
    # list/PhysicsHIPhysicsRawPrime58_388095.txt
    # list/PhysicsHIPhysicsRawPrime59_388095.txt
)

# 
OUTPUTPRIDIR="/eos/cms/store/group/phys_heavyions/wangj/RECO2024/"
WORKDIR="$PWD"

#
mkdir -p $WORKDIR

for INPUTDIR in "${INPUTS[@]}"
do
    echo -e "\e[32;1m$INPUTDIR\e[0m"
    
    if [[ $INPUTDIR == *.txt ]]
    then
        INPUTFILELIST=$INPUTDIR 
    else
        CRABNAME=${INPUTDIR##*crab_} ; CRABNAME=${CRABNAME%%/*} ;
        INPUTFILELIST="$WORKDIR/filelists/filelist_"$CRABNAME".txt"
        ls --color=no $INPUTDIR/* -d | sed -e "s/\/mnt\/T2_US_MIT\/hadoop\/cms/root:\/\/xrootd.cmsaf.mit.edu\//g" > $INPUTFILELIST
    fi
    echo "$INPUTFILELIST"
    REQUESTNAME=${INPUTFILELIST##*/} ; REQUESTNAME=${REQUESTNAME%%.txt} ;
    OUTPUTSUBDIR="${PRIMARY}_${REQUESTNAME}${tag}"

    ##
    OUTPUTDIR="${OUTPUTPRIDIR}/${OUTPUTSUBDIR}"
    LOGDIR="logs/log_${OUTPUTSUBDIR}"

    echo "$OUTPUTDIR"
    ##

    if [ "$runjobs" -eq 1 ]
    then 
        set -x
        ./tt-condor-checkfile.sh "$INPUTFILELIST" $OUTPUTDIR $MAXFILENO $LOGDIR $config
        set +x
    fi

done

