#!/bin/bash

if [[ $# -ne 5 && $# -ne 6 ]]; then
    echo "usage: ./tt-reco-checkfile.sh [input file] [output dir] [output filename] [python config] [cmssw release] ([muon skim output dir])"
    exit 1
fi

INFILE=$1
DESTINATION=$2
OUTFILE=$3
PYCONFIG=$4
RELEASE=$5
DESTINATION_MUON=$6

echo $SCRAM_ARCH

source /cvmfs/cms.cern.ch/cmsset_default.sh
scram p CMSSW $RELEASE
cd $RELEASE/src
eval `scram runtime -sh`
cp ../../$PYCONFIG .
# cp ../../emap_2025_full.txt .

cmsRun $PYCONFIG inputFiles=$INFILE outputFile=$OUTFILE

SRM_PREFIX="/eos/cms/" ; SRM_PATH=${DESTINATION#${SRM_PREFIX}} ; SRM_PATH_MUON=${DESTINATION_MUON#${SRM_PREFIX}} ;
if [[ $(wc -c $OUTFILE | awk '{print $1}') -gt 700 ]]; then
    # gfal-copy
    # SRM_PREFIX="/mnt/T2_US_MIT/hadoop/" ; SRM_PATH=${DESTINATION#${SRM_PREFIX}} ;
    # LD_LIBRARY_PATH='' PYTHONPATH='' gfal-copy file://$PWD/${OUTFILE} gsiftp://se01.cmsaf.mit.edu:2811/${SRM_PATH}/${OUTFILE}

    # xrdcp
    xrdcp ${OUTFILE} root://eoscms.cern.ch//${SRM_PATH}/$OUTFILE

fi

# [[ $(wc -c IonDimuon.root | awk '{print $1}') -gt 700 ]] && {
#     xrdcp IonDimuon.root  root://eoscms.cern.ch//${SRM_PATH_MUON}/$OUTFILE
# }

cd ../../
rm -rf $RELEASE
