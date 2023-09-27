#!/bin/bash

if [[ $# -ne 4 ]]; then
    echo "usage: ./tt-tracklet-checkfile.sh [input file] [output dir] [output filename] [random] [split]"
    exit 1
fi

INFILE=$1
DESTINATION=$2
OUTFILE=$3
PYCONFIG=$4
RELEASE=CMSSW_13_2_4

echo $SCRAM_ARCH

source /cvmfs/cms.cern.ch/cmsset_default.sh
scram p CMSSW $RELEASE
cd $RELEASE/src
eval `scram runtime -sh`
cp ../../$PYCONFIG .
set -x

input_file=$INFILE

cmsRun $PYCONFIG inputFiles=$INFILE outputFile=$OUTFILE

if [[ $(wc -c $OUTFILE | awk '{print $1}') -gt 700 ]]; then
    # gfal-copy
    # SRM_PREFIX="/mnt/T2_US_MIT/hadoop/" ; SRM_PATH=${DESTINATION#${SRM_PREFIX}} ;
    # LD_LIBRARY_PATH='' PYTHONPATH='' gfal-copy file://$PWD/${OUTFILE} gsiftp://se01.cmsaf.mit.edu:2811/${SRM_PATH}/${OUTFILE}

    # xrdcp
    SRM_PREFIX="/eos/cms/" ; SRM_PATH=${DESTINATION#${SRM_PREFIX}} ;
    xrdcp ${OUTFILE} root://eoscms.cern.ch//${SRM_PATH}/$OUTFILE
fi
set +x

cd ../../
rm -rf $RELEASE
