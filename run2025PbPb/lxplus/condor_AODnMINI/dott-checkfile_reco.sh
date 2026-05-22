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
MAXFILENO=1000000
#
runjobs=${1:-0}

PRIMARY="miniaod" # event content
tag="_express_v0" # hlt filter
config="recoPbPbrawPr_RAW2DIGI_L1Reco_RECO_PAT.py"

INPUTS=(
    # list/PhysicsSpecialHLTPhysics0_398683.txt
    # list/PhysicsSpecialZeroBias2_398683.txt
    # list/PhysicsVRZeroBias7_398861.txt
    # list/PhysicsHIPhysicsRawPrime0_399465.txt
    # # list/PhysicsHIPhysicsRawPrime0_399466.txt
    # # list/PhysicsHIPhysicsRawPrime0_399467.txt
    # list/PhysicsHIPhysicsRawPrime0_399471.txt
    # list/PhysicsHIPhysicsRawPrime1_399465.txt
    # # list/PhysicsHIPhysicsRawPrime1_399466.txt
    # # list/PhysicsHIPhysicsRawPrime1_399467.txt
    # list/PhysicsHIPhysicsRawPrime1_399471.txt
    list/PhysicsHIPhysicsRawPrime2_399465.txt
    # list/PhysicsHIPhysicsRawPrime2_399466.txt
    # list/PhysicsHIPhysicsRawPrime2_399467.txt
    list/PhysicsHIPhysicsRawPrime2_399471.txt
    list/PhysicsHIPhysicsRawPrime3_399465.txt
    # list/PhysicsHIPhysicsRawPrime3_399466.txt
    # list/PhysicsHIPhysicsRawPrime3_399467.txt
    list/PhysicsHIPhysicsRawPrime3_399471.txt
    list/PhysicsHIPhysicsRawPrime4_399465.txt
    # list/PhysicsHIPhysicsRawPrime4_399466.txt
    # list/PhysicsHIPhysicsRawPrime4_399467.txt
    list/PhysicsHIPhysicsRawPrime4_399471.txt
    list/PhysicsHIPhysicsRawPrime5_399465.txt
    # list/PhysicsHIPhysicsRawPrime5_399466.txt
    # list/PhysicsHIPhysicsRawPrime5_399467.txt
    list/PhysicsHIPhysicsRawPrime5_399471.txt
    list/PhysicsHIPhysicsRawPrime6_399465.txt
    # list/PhysicsHIPhysicsRawPrime6_399466.txt
    # list/PhysicsHIPhysicsRawPrime6_399467.txt
    list/PhysicsHIPhysicsRawPrime6_399471.txt
    list/PhysicsHIPhysicsRawPrime7_399465.txt
    # list/PhysicsHIPhysicsRawPrime7_399466.txt
    # list/PhysicsHIPhysicsRawPrime7_399467.txt
    list/PhysicsHIPhysicsRawPrime7_399471.txt
    list/PhysicsHIPhysicsRawPrime8_399465.txt
    # list/PhysicsHIPhysicsRawPrime8_399466.txt
    # list/PhysicsHIPhysicsRawPrime8_399467.txt
    list/PhysicsHIPhysicsRawPrime8_399471.txt
    list/PhysicsHIPhysicsRawPrime9_399465.txt
    # list/PhysicsHIPhysicsRawPrime9_399466.txt
    # list/PhysicsHIPhysicsRawPrime9_399467.txt
    list/PhysicsHIPhysicsRawPrime9_399471.txt
)

# 
OUTPUTPRIDIR="/eos/cms/store/group/phys_heavyions/wangj/RECO2025PbPb/"
WORKDIR="../"

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
    LOGDIR="$WORKDIR/logs/log_${OUTPUTSUBDIR}"

    echo "$OUTPUTDIR"
    ##

    if [ "$runjobs" -eq 1 ]
    then 
        set -x
        ./tt-condor-checkfile.sh "$INPUTFILELIST" $OUTPUTDIR $MAXFILENO $LOGDIR $config 
        set +x
    fi

done

