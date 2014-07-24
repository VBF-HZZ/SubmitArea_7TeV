#!/bin/sh

SETNJOBS=1

if [ "$1" == "" ]; then
  echo "Please pass a dir with txt files for datasets to be processed!"
  exit 1;
fi


INPUTDIR=${1}


if [ ! -d "Submission_${INPUTDIR}" ]; then
  mkdir Submission_${INPUTDIR}
fi


cd ${INPUTDIR}

for file in  *.txt;
do

  patTuples=`cat $file`

  txtFile=`basename $file .txt`

  workDir=../Submission_${INPUTDIR}

  echo $file

  NFILES_TOTAL=`cat $file | wc -l`

  NFILES_PERJOB1=$(( NFILES_TOTAL / SETNJOBS + 1 )) # N files for each job except the last job
  NJOBS=$(( NFILES_TOTAL / NFILES_PERJOB1 + 1 )) # reset NJOBS
  NFILES_PERJOB2=$(( NFILES_TOTAL % NFILES_PERJOB1 )) # N files for the last job

  echo "NJOBS=$NJOBS; NFILES_PERJOB1=$NFILES_PERJOB1; NFILES_PERJOB2=$NFILES_PERJOB2"

  NFILES=1 #counter, number of jobs added per job
  IJOB=1 # job number, counter
  FILES_IN_JOB="" #string to hold the files

  for infile in `cat $file`;
  do
    # decide with NFILES_PERJOB to use
    NFILES_PERJOB=""
    if [ "$IJOB" -lt "$NJOBS" ]; then
      NFILES_PERJOB=${NFILES_PERJOB1}
    else
      NFILES_PERJOB=${NFILES_PERJOB2}
    fi

    # if less than number fo files per job, count it
    if [ "$NFILES" -le "$NFILES_PERJOB" ]; then
    #
      if [ "$NFILES" -eq "1" ]; then
        FILES_IN_JOB="${infile}"
      else
        FILES_IN_JOB="${FILES_IN_JOB},${infile}"
      fi
      # if eq number of files per job, fill in file
      if [ "$NFILES" -eq "$NFILES_PERJOB" ]; then

        cfgFile=${txtFile}_cfg_$(( IJOB - 1 )).py




####################	
echo "import FWCore.ParameterSet.Config as cms

process = cms.Process(\"UFHZZ4LAnalysis\")

process.load(\"FWCore.MessageService.MessageLogger_cfi\")
process.MessageLogger.cerr.FwkReport.reportEvery = 1000
process.MessageLogger.categories.append('UFHZZ4LAna')
process.load(\"Configuration.StandardSequences.MagneticField_cff\") 
process.Timing = cms.Service(\"Timing\",
                             summaryOnly = cms.untracked.bool(True)
                             )


process.maxEvents = cms.untracked.PSet( input = cms.untracked.int32(-1) )

myfilelist = cms.untracked.vstring()
myfilelist.extend( [

" >> ${workDir}/${cfgFile}

echo ${FILES_IN_JOB} >> ${workDir}/${cfgFile}

echo "

]
)

process.source = cms.Source(\"PoolSource\",fileNames = myfilelist)
process.source.skipBadFiles = cms.untracked.bool( True )

process.TFileService = cms.Service(\"TFileService\",
                                   fileName = cms.string(\""${txtFile}_$(( IJOB - 1 ))".root\")
                                   )

process.AnaAfterHlt = cms.EDAnalyzer('UFHZZ4LAna',
                              photonSrc    = cms.untracked.InputTag(\"cleanPatPhotons\"),
                              electronSrc  = cms.untracked.InputTag(\"calibratedPatElectrons\"),
                              muonSrc      = cms.untracked.InputTag(\"muscleMuons\"),
                              jetSrc       = cms.untracked.InputTag(\"cleanPatJets\"),
                              metSrc       = cms.untracked.InputTag(\"patMETsPF\"),
                              vertexSrc    = cms.untracked.InputTag(\"goodOfflinePrimaryVertices\"), #or selectedVertices 
                              isMC         = cms.untracked.bool(False),
                              weightEvents = cms.untracked.bool(False),
                              muRhoSrc       = cms.untracked.InputTag(\"kt6PFJetsForIso\", \"rho\"),
                              elRhoSrc       = cms.untracked.InputTag(\"kt6PFJetsForIso\", \"rho\")
                             )

# Trigger
process.hltHighLevel = cms.EDFilter(\"HLTHighLevel\",
                                    TriggerResultsTag = cms.InputTag(\"TriggerResults\",\"\",\"HLT\"),
                                    HLTPaths = cms.vstring( 'HLT_Mu13_Mu8*',
                                                            'HLT_Mu17_Mu8*',                                         
                                                            'HLT_DoubleMu7_v*',
                                                            #'HLT_DoubleMu3_v*',
                                                            #'HLT_Ele10_LW_LR1',
                                                            #'HLT_Ele15_SW_LR1',
                                                            #'HLT_Ele15_SW_CaloEleId_L1R',
                                                            #'HLT_Ele17_SW_TightEleId_L1R_v*',
                                                            #'HLT_Ele17_SW_TighterEleIdIsol_L1R_v*',
                                                            #'HLT_Ele17_CaloIdL_CaloIsoVL_Ele8_CaloIdL_CaloIsoVL_v*',
                                                            'HLT_Mu8_Ele17_CaloIdT_CaloIsoVL*',
                                                            'HLT_Mu17_Ele8_CaloIdL*',
                                                            'HLT_Ele17_CaloIdT_CaloIsoVL_TrkIdVL_TrkIsoVL_Ele8_CaloIdT_CaloIsoVL_TrkIdVL_TrkIsoVL*',
                                                            'HLT_Ele17_CaloIdT_TrkIdVL_CaloIsoVL_TrkIsoVL_Ele8_CaloIdT_TrkIdVL_CaloIsoVL_TrkIsoVL*',
                                                            'HLT_TripleEle10_CaloIdL_TrkIdVL_v*' 
                                                            ),
                                    # provide list of HLT paths (or patterns) you want
                                    eventSetupPathsKey = cms.string(''), # not empty => use read paths from AlCaRecoTriggerBitsRcd via this key
                                    andOr = cms.bool(True),             # how to deal with multiple triggers: True (OR) accept if ANY is true, False (AND) accept if ALL are true  
                                    throw = cms.bool(False)    # throw exception on unknown path names 
                                    )



process.p = cms.Path(process.hltHighLevel
                    *process.AnaAfterHlt)



" >> ${workDir}/${cfgFile}

########################


        IJOB=$(( IJOB + 1 )) # reset
        FILES_IN_JOB="" #reset
        NFILES=1 #reset
      else
        NFILES=$(( NFILES + 1 ))
      fi
    fi
  done

done


cd ../


