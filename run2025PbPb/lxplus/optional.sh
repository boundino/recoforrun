
INPUT0=(
    'PhysicsPPRefZeroBiasPlusForward0:387474:HLT_PPRefZeroBias_v6:ppRef RAW'
    'PhysicsHIPhysicsRawPrime0:387757:HLT_HIZeroBias_HighRate_v7:PbPb RAW prime'
    'PhysicsHIZeroBiasRAW0:387757:HLT_HIZeroBias_HighRateRAW_v4:PbPb RAW'
)

config=$1
[[ $config == *.py ]] || { echo "error: bad config: ./optional.sh [config.py]" ; exit 1 ; }
index=$2
[[ x$index == x ]] && {
    [[ $config == *prime* ]] && index=1 || {
            [[ $config == *PbPb* ]] && index=2 || {
                    [[ $config == *pp* ]] && index=0 
                }
        }
}
[[ $index =~ [012] ]] || { echo "error: bad index." ; exit 1 ; }

IFS=':' ; inputs=(${INPUT0[index]}) ; unset IFS
PD0=${inputs[0]}
RUN0=${inputs[1]}
HLT0=${inputs[2]}
tag=${inputs[3]}
LS0='0055'
FILE0=/store/t0streamer/Data/$PD0/000/"${RUN0:0:3}/${RUN0:3:3}"/run${RUN0}_ls${LS0}_stream${PD0}_StorageManager.dat
echo -e "\e[32m["$tag"]\e[0m \e[32;2m"$HLT0 $FILE0"\e[0m"

ls /eos/cms/$FILE0 # || exit 1
OUT0=/eos/cms/store/group/phys_heavyions/wangj/RECO2024/miniaod_${PD0}_${RUN0}_ls${LS0}.root

STREAMER='
process.source = cms.Source("NewEventStreamFileReader",
    fileNames = cms.untracked.vstring("file:/")
)
'
HCALDIGI='process.MINIAODoutput.outputCommands += ["keep QIE10DataFrameHcalDataFrameContainer_hcalDigis_*_*"]'
HLT='
#
process.triggerSelection = cms.EDFilter("TriggerResultsFilter",
    triggerConditions = cms.vstring(
        "*",
	# "'$HLT0'",
    ),
    hltResults = cms.InputTag("TriggerResults", "", "HLT"),
    l1tResults = cms.InputTag(""),
    throw = cms.bool(False)
)
process.filterSequence = cms.Sequence(
    process.triggerSelection
)
process.filterPath = cms.Path(process.triggerSelection)
#
process.MINIAODoutput.SelectEvents = cms.untracked.PSet(SelectEvents = cms.vstring("filterPath"))
# Add filterPath to schedule: process.schedule = cms.Schedule(process.filterPath,process.raw2digi_step, ...
# customisation of the process.
for path in process.paths:
    getattr(process, path)._seq = process.filterSequence * getattr(process,path)._seq
'

MESSENGER='
process.MessageLogger.cerr.FwkReport.reportEvery = 1000
# process.MessageLogger.suppressWarning = cms.untracked.vstring("hiPuRho", "akPu4CaloJets", "ak4CaloJetsForTrk", "ak4CaloJetsForTrkPreSplitting", "toomanystripclus53X", "manystripclus53X")
'

MODIFY='
# process.GlobalTag.toGet = cms.VPSet(
#   cms.PSet(record = cms.string("HeavyIonRPRcd"),
#            tag = cms.string("HeavyIonRPRcd_75x_v0_prompt"),
#            label = cms.untracked.string(''),
#            connect = cms.string("frontier://FrontierProd/CMS_CONDITIONS")
#            )
# )
'

ARGU='
import FWCore.ParameterSet.VarParsing as VarParsing
ivars = VarParsing.VarParsing("analysis")
ivars.inputFiles = "'$FILE0'"
ivars.outputFile = "'$OUT0'"
ivars.maxEvents = 10
ivars.parseArguments() # get and parse the command line arguments
process.source.fileNames = ivars.inputFiles
process.maxEvents.input = cms.untracked.int32(ivars.maxEvents)
# process.MINIAODoutput.fileName = ivars.outputFile
'

##

temp_file=$(mktemp)
# add HLT filter
{
    while IFS= read -r line; do
        if [[ "$line" == *"# Schedule definition"* ]]; then
            echo "$HLT"
        fi
        echo "$line"
    done < $config
} > $temp_file
sed -i 's/Schedule(process.raw2digi_step/Schedule(process.filterPath,process.raw2digi_step/g' $temp_file
# add other helpers
echo "$STREAMER$HCALDIGI$MESSENGER$MODIFY$ARGU" >> $temp_file

diff $config $temp_file --report-identical-files --old-group-format=$'\e[38;2;210;106;112m%<\e[0m' --new-group-format=$'\e[38;2;132;192;127m%>\e[0m' --unchanged-group-format=$'\e[38;2;128;128;128m%=\e[0m'
mv -v $temp_file $config

echo "done"
echo -e "\e[32m["$tag"]\e[0m \e[32;2m"$HLT0 $FILE0"\e[0m"
