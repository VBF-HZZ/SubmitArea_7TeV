#!/bin/bash             

JobsPerDataset=1

if [ "$1" == "" ]; then 
    echo "Please pass a dir with txt files for datasets to be processed!"
    exit 1;
fi


dir=${1}


if [ ! -d "Submission_${dir}" ]
      then mkdir Submission_${dir}
fi


cd $dir

for f in $(ls *.txt)
  do
  
  patTuples=$(cat $f)
  
  txtFile=${f%%.txt*}

  mH=$(../bin/getHiggsMass.exe ${txtFile} )  
  if [[ "$mH" == "0" ]]; then
      isSignal="False"
  else
      isSignal="True"
  fi

  CrossSect=$(../bin/getCrossSection.exe ${txtFile} )
  FilterEff=$(../bin/getFilterEff.exe ${txtFile} )
  nEvents=$(../bin/getNEvents.exe ${txtFile} )
  
  workDir=../Submission_${dir}
  cfgSRC2=../${cfgSRC}

  echo $f

  nJobsPerDataset=${JobsPerDataset}  
  nLines=$(cat $f | wc -l)
    
  nFilesPerJob=$( echo "scale=0;${nLines}/${nJobsPerDataset}" | bc)
  nFilesLeftover=$( echo "${nLines}%${nJobsPerDataset}" | bc)
  
  nJobsPerDataset=${JobsPerDataset}

  if(( $nLines < $nJobsPerDataset)); then
      nJobsPerDataset=1
      counterArray[0]=$nLines
  else
      
      totalJobs=${nJobsPerDataset}
      if [[ "$nFilesLeftover" == "0" ]]; then
	  
	  for(( i=0; i<${totalJobs}; i++ ));
	    do
	    counterArray[$i]=${nFilesPerJob}
	  done
      else
	  let lastJob=${nJobsPerDataset}-1
	  
	  for(( i=0; i<${totalJobs}; i++ ));
	    do

	    if [[ "$i" == "$lastJob" ]]; then
		counterArray[$i]=$( echo "scale=0;${nFilesLeftover}+${nFilesPerJob}" | bc)
	    else
		counterArray[$i]=${nFilesPerJob}
	    fi
	  done
	  
      fi
      
  fi
  
  tmpCounter=1
  arrayCounter=0
  jobCounter=0
  
  files=""
  while read line
    do

    if [[ "$tmpCounter" != "${counterArray[arrayCounter]}" ]]; then
      
	files+=$line,
	let tmpCounter=${tmpCounter}+1
    else
	files+=$line
	let arrayCounter=${arrayCounter}+1
	
	cfgFile=${txtFile}_cfg_${jobCounter}.py
	let jobCounter=${jobCounter}+1
	
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

echo $files >> ${workDir}/${cfgFile}

echo "

]
)

process.source = cms.Source(\"PoolSource\",fileNames = myfilelist)
process.source.skipBadFiles = cms.untracked.bool( True )

process.TFileService = cms.Service(\"TFileService\",
                                   fileName = cms.string(\""${txtFile}_${jobCounter}".root\")
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
                                                            #'HLT_DoubleMu7_v*',
                                                            #'HLT_DoubleMu3_v*',
                                                            #'HLT_Ele10_LW_LR1',
                                                            #'HLT_Ele15_SW_LR1',
                                                            #'HLT_Ele15_SW_CaloEleId_L1R',
                                                            #'HLT_Ele17_SW_TightEleId_L1R_v*',
                                                            #'HLT_Ele17_SW_TighterEleIdIsol_L1R_v*',
                                                            #'HLT_Ele17_CaloIdL_CaloIsoVL_Ele8_CaloIdL_CaloIsoVL_v*',
                                                            'HLT_Mu17_Ele8_CaloIdL*',
                                                            'HLT_Mu8_Ele17_CaloIdT_CaloIsoVL*',
                                                            'HLT_Ele17_CaloIdT_CaloIsoVL_TrkIdVL_TrkIsoVL_Ele8_CaloIdT_CaloIsoVL_TrkIdVL_TrkIsoVL*',
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

files=""
tmpCounter=1


  fi


done < $f

jobCounter=0
done

cd ../