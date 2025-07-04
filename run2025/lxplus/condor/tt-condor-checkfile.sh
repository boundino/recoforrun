#!/bin/bash

# https://batchdocs.web.cern.ch/local/submit.html

if [[ $# -ne 5 ]]; then
    echo "usage: ./tt-condor-checkfile.sh [input dir] [output dir] [max jobs] [log dir] [python config]"
    exit 1
fi

FILELIST=$1
DESTINATION=$2
MAXFILES=$3
LOGDIR=$4
PYCONFIG=$5

# PROXYFILE=$(ls /tmp/ -lt | grep $USER | grep -m 1 x509 | awk '{print $NF}')
PROXYFILE=$HOME/$(ls $HOME -lt | grep $USER | grep -m 1 x509 | awk '{print $NF}')

tag="reco"

set -x
DEST_CONDOR=${DESTINATION}
DEST_MUON=${DESTINATION%%/}_muon

mkdir -p $DESTINATION $DEST_MUON $LOGDIR

set +x

counter=0
for i in `cat $FILELIST`
do
    if [ $counter -ge $MAXFILES ]
    then
        break
    fi
    inputname=${i}
    infn=${inputname##*/}
    infn=${infn%%.*} # no .root
    outputfile=${tag}_${infn}.root
    if [ ! -f ${DESTINATION}/${outputfile} ]
    then
        echo -e "\033[38;5;242mSubmitting a job for output\033[0m ${DESTINATION}/${outputfile}"
        
        cat > tt-${tag}.condor <<EOF

Universe     = vanilla
Initialdir   = $PWD/
Notification = Error
Executable   = $PWD/tt-${tag}-checkfile.sh
Arguments    = $inputname $DEST_CONDOR ${outputfile} $PYCONFIG $CMSSW_VERSION $DEST_MUON
Output       = $LOGDIR/log-${infn}.out
Error        = $LOGDIR/log-${infn}.err
Log          = $LOGDIR/log-${infn}.log
# Rank         = Mips
+AccountingGroup = "group_u_CMST3.all"
+JobFlavour = "workday"
# Requirements = ( OpSysAndVer =?= "CentOS8" )
should_transfer_files = YES
use_x509userproxy = True
x509userproxy = $PROXYFILE
transfer_input_files = $PYCONFIG,emap_2025_full.txt
Queue 
EOF

condor_submit tt-${tag}.condor
mv tt-${tag}.condor $LOGDIR/log-${infn}.condor
counter=$(($counter+1))
    fi
done

echo -e "Submitted \033[1;36m$counter\033[0m jobs to Condor."
