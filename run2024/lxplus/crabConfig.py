#

from CRABClient.UserUtilities import config
config = config()
config.General.transferOutputs = True
# ==============================
config.General.requestName = 'miniaod_241026_PhysicsHIPhysicsRawPrime0_375549_ZB'
inputList = 'list/example_streamer.txt'
config.Data.userInputFiles = open(inputList).readlines()
# config.Data.inputDataset = '/HIPhysicsRawPrime9/HIRun2023A-PromptReco-v1/MINIAOD'
# config.Data.runRange = '374354-374354'
# config.Data.lumiMask = '/eos/user/c/cmsdqm/www/CAF/certification/Collisions22/Collisions2022HISpecial/Cert_Collisions2022HISpecial_362293_362323_Golden.json'
# ==============================
config.General.workArea = 'crab_projects'
config.JobType.psetName = 'recoPbPbprime2mini_RAW2DIGI_L1Reco_RECO_PAT.py'

# config.JobType.pluginName = 'PrivateMC'
config.JobType.pluginName = 'Analysis'
config.JobType.maxMemoryMB = 2500
config.JobType.pyCfgParams = ['noprint']
# config.JobType.numCores = 4
config.JobType.allowUndistributedCMSSW = True

##
# config.Data.inputDBS = 'phys03'
config.Data.unitsPerJob = 1 ##
config.Data.totalUnits = -1
config.Data.splitting = 'FileBased'
# config.Data.splitting = 'EventAwareLumiBased'
config.Data.publication = False
# if publish
# config.Data.outputPrimaryDataset = 'PhysicsHIPhysicsRawPrime0'

##
config.Site.storageSite = 'T2_CH_CERN'
config.Data.outLFNDirBase = '/store/group/phys_heavyions/wangj/RECO2024'
# config.Site.whitelist = ['T2_US_MIT']
# config.Site.blacklist = ['T2_US_Nebraska','T2_US_UCSD','T2_US_Wisconsin','T2_FR_GRIF_IRFU','T3_US_Rutgers','T3_BG_UNI_SOFIA','T3_IT_Perugia']
# config.Site.ignoreGlobalBlacklist = True
# config.section_("Debug")
# config.Debug.extraJDL = ['+CMS_ALLOW_OVERFLOW=False']
