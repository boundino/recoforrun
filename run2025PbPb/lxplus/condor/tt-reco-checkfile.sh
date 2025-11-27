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
DESTINATION_SECONDARY=$6

echo "SCRAM_ARCH:          "$SCRAM_ARCH
echo "PWD:                 "$PWD
echo "_CONDOR_SCRATCH_DIR: "$_CONDOR_SCRATCH_DIR
echo "hostname:            "$(hostname)
echo "INFILE:              "$INFILE
echo "DESTINATION:         "$DESTINATION
# echo "DESTINATION_SECONDARY:     "$DESTINATION_SECONDARY

source /cvmfs/cms.cern.ch/cmsset_default.sh
scram p CMSSW $RELEASE
cd $RELEASE/src
eval `scram runtime -sh`
cp ../../$PYCONFIG .
# cp ../../emap_2025_full.txt .

cmsRun $PYCONFIG inputFiles=$INFILE outputFile=$OUTFILE

ls

SRM_PREFIX="/eos/cms/" ; SRM_PATH=${DESTINATION#${SRM_PREFIX}} ; SRM_PATH_SECONDARY=${DESTINATION_SECONDARY#${SRM_PREFIX}} ;
if [[ $(wc -c $OUTFILE | awk '{print $1}') -gt 700 ]]; then
    xrdcp $OUTFILE root://eoscms.cern.ch//${SRM_PATH}/$OUTFILE
fi

# [[ $(wc -c IonDimuon.root | awk '{print $1}') -gt 700 ]] && {
#     xrdcp IonDimuon.root  root://eoscms.cern.ch//${SRM_PATH_SECONDARY}/$OUTFILE
# }

cd ../../
rm -rf $RELEASE
