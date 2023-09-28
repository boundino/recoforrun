#!/bin/bash

if [[ $0 != *.sh ]]
then
    echo -e "\e[31;1merror:\e[0m use \e[32;1m./script.sh\e[0m instead of \e[32;1msource script.sh\e[0m"
    return 1
fi

#
MAXFILENO=10000000
#
runjobs=${1:-0}

PRIMARY="miniaod"
# config="step3raw_RAW2DIGI_L1Reco_RECO_PAT.py" # RAW
config="step3_RAW2DIGI_L1Reco_RECO_PAT.py" # RAW prime
# config="pp_RAW2DIGI_L1Reco_RECO_PAT.py" # Forward
# PRIMARY="aodclus"
# config="step3raw_RAW2DIGI_L1Reco_RECO.py" # RAW
# config="step3_RAW2DIGI_L1Reco_RECO.py" #RAW prim
# PRIMARY="aod"
# config="pp_RAW2DIGI_L1Reco_RECO.py" # Forward

INPUTS=(
    # "../list/HIExpressRawPrime_374354.txt"
    # "../list/HIExpress_374354.txt"
    "../list/PhysicsHIPhysicsRawPrime0_374354.txt"
    # "../list/PhysicsHIForward0_374354.txt"
)

OUTPUTPRIDIR="/eos/cms/store/group/phys_heavyions/wangj/RECO2023/"
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
    OUTPUTSUBDIR="${PRIMARY}_${REQUESTNAME}"

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

