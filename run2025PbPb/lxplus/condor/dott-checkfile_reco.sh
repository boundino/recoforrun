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
tag="_prompt_ZB" # label and/or hlt filter
config="recorawPr_RAW2DIGI_L1Reco_RECO_PAT_ZB.py"

INPUTS=(
    list/PhysicsHIPhysicsRawPrime0_399766.txt
    list/PhysicsHIPhysicsRawPrime10_399766.txt
)

# 
OUTPUTPRIDIR="/eos/cms/store/group/phys_heavyions/wangj/RECO2025PbPb/"
WORKDIR="../"

#### Don't change below ####

numEvents=$(grep "input = cms" $config) ; echo $numEvents ;
[[ $numEvents == *-1* ]] || { echo -e "\e[31merror: Change nevents to -1 before submission. exit.\e[0m" ; exit 2; }

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

