#!/bin/bash

if [[ $0 != *.sh ]]
then
    echo -e "\e[31;1merror:\e[0m use \e[32;1m./script.sh\e[0m instead of \e[32;1msource script.sh\e[0m"
    return 1
fi

#
MAXFILENO=100000
#
movetosubmit=${1:-0}
runjobs=${2:-0}

PRIMARY="aodclus"
# config="step3raw_RAW2DIGI_L1Reco_RECO_PAT_forcondor.py"
# config="step3_RAW2DIGI_L1Reco_RECO_PAT_forcondor.py"
config="step3raw_RAW2DIGI_L1Reco_RECO.py"

INPUTS=(
    # "../list/HIExpressRawPrime_374289.txt"
    "../list/HIExpress_374289.txt"
    # "../list/PhysicsHIPhysicsRawPrime0_374289.txt"
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

if [ "$movetosubmit" -eq 1 ]
then
    # cd ../
    # make transmute_trees || exit 1
    # cd lxplus    
    # mv -v ../transmute_trees $WORKDIR/

    cp ../step3_RAW2DIGI_L1Reco_RECO_PAT_forcondor.py .
    
fi

